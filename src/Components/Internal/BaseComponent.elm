module Components.Internal.BaseComponent
    exposing
        ( InternalStuff
        , Options
        , Self
        , Spec
        , baseComponent
        , convertAttribute
        , convertNode
        , convertSignal
        , convertSlot
        , sendToChild
        )

import Components.Internal.Core exposing (..)
import Components.Internal.Shared exposing (identify, toParentSignal)
import Dict exposing (Dict)
import Html.Styled
import Html.Styled.Attributes
import Html.Styled.Keyed
import Html.Styled.Lazy
import Svg.Styled.Attributes
import VirtualDom


type alias Spec v w s m c pM pC =
    { init : Self s m c pC -> ( s, Cmd m, List (Signal pM pC) )
    , update : Self s m c pC -> m -> s -> ( s, Cmd m, List (Signal pM pC) )
    , subscriptions : Self s m c pC -> s -> Sub m
    , view : Self s m c pC -> s -> Node v w pM pC
    , children : c
    , options : Options s m
    }


type alias Self s m c pC =
    { id : String
    , internal : InternalStuff s m c pC
    }


type InternalStuff s m c pC
    = InternalStuff
        { slot : Slot (Container s m c) pC
        , freshContainers : c
        , freshParentContainers : pC
        }


type alias Options s m =
    { onContextUpdate : Maybe m
    , shouldRecalculate : s -> Bool
    , lazyRender : Bool
    }


type alias Hidden v w s m c pM pC =
    { spec : Spec v w s m c pM pC
    , slot : Slot (Container s m c) pC
    , sub : Sub (Signal pM pC)
    , tree : Node v w pM pC
    , components : Dict ComponentId (ComponentInterface pM pC)
    , orderedComponentIds : List ComponentId
    }


type alias CommonArgs a m c =
    { a
        | states : c
        , cache : Cache m c
        , freshContainers : c
        , componentLocations : ComponentLocations
        , lastComponentId : ComponentId
        , namespace : String
    }


baseComponent : Spec v w s m c pM pC -> Component v w (Container s m c) pM pC
baseComponent spec =
    Component <|
        \slot ->
            ComponentNode (renderedComponent spec slot)


renderedComponent :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> RenderedComponent pM pC
renderedComponent spec slot =
    { status = status spec slot
    , touch = touch spec slot
    }


status :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> { states : pC }
    -> ComponentStatus
status spec ( get, _ ) args =
    case get args.states of
        StateContainer state ->
            if spec.options.shouldRecalculate state.localState then
                NewOrChanged
            else
                Unchanged state.id

        _ ->
            NewOrChanged


touch :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> TouchArgs pM pC
    -> ( ComponentId, Change pM pC )
touch spec (( get, _ ) as slot) args =
    case get args.states of
        StateContainer state ->
            case spec.options.onContextUpdate of
                Just msg ->
                    ( state.id
                    , doLocalUpdate spec slot state msg args
                    )

                Nothing ->
                    ( state.id
                    , rebuild spec slot state args
                    )

        _ ->
            init spec slot args


init :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> TouchArgs pM pC
    -> ( ComponentId, Change pM pC )
init spec slot args =
    let
        id =
            args.lastComponentId + 1

        self =
            getSelf spec slot id args

        ( localState, cmd, signals ) =
            spec.init self

        sub =
            spec.subscriptions self localState

        tree =
            spec.view self localState

        state =
            { id = id
            , localState = localState
            , childStates = spec.children
            , cache = Dict.empty
            }

        updatedArgs =
            { args | lastComponentId = id }
    in
    ( id
    , doChange spec slot state cmd sub signals tree updatedArgs
    )


rebuild :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> ComponentState s m c
    -> TouchArgs pM pC
    -> Change pM pC
rebuild spec slot state args =
    let
        self =
            getSelf spec slot state.id args

        sub =
            spec.subscriptions self state.localState

        tree =
            spec.view self state.localState
    in
    doChange spec slot state Cmd.none sub [] tree args


update : Hidden v w s m c pM pC -> UpdateArgs pM pC -> Change pM pC
update hidden args =
    let
        ( get, _ ) =
            hidden.slot
    in
    case get args.states of
        StateContainer state ->
            case get args.signalContainers of
                EmptyContainer ->
                    updateChild hidden state args

                StateContainer _ ->
                    -- This is an "impossible" case and should be ignored, but
                    -- it shouldn't be handled last so that an exception will be
                    -- thrown if a user runs into this bug:
                    -- https://github.com/elm-lang/virtual-dom/issues/73
                    -- (otherwise it will be silently ignored).
                    --
                    -- The error occurs if a user applies laziness directly to
                    -- component's root node because we use `VirtualDom.map`
                    -- around components.
                    noUpdate hidden args

                SignalContainer (LocalMsg msg) ->
                    doLocalUpdate hidden.spec hidden.slot state msg args

                SignalContainer (ChildMsg identifyTarget _) ->
                    let
                        path =
                            buildPathToTarget args state identifyTarget
                    in
                    updateChild hidden state { args | pathToTarget = path }

        _ ->
            noUpdate hidden args


doLocalUpdate :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> ComponentState s m c
    -> m
    -> CommonArgs a pM pC
    -> Change pM pC
doLocalUpdate spec (( _, set ) as slot) state msg args =
    let
        self =
            getSelf spec slot state.id args

        ( newLocalState, cmd, signals ) =
            spec.update self msg state.localState

        sub =
            spec.subscriptions self newLocalState

        tree =
            spec.view self newLocalState

        updatedState =
            { state | localState = newLocalState }
    in
    doChange spec slot updatedState cmd sub signals tree args


updateChild :
    Hidden v w s m c pM pC
    -> ComponentState s m c
    -> UpdateArgs pM pC
    -> Change pM pC
updateChild hidden state args =
    case args.pathToTarget of
        [] ->
            noUpdate hidden args

        id :: pathToTarget ->
            case Dict.get id hidden.components of
                Just (ComponentInterface component) ->
                    let
                        change =
                            component.update
                                { args | pathToTarget = pathToTarget }

                        updatedComponents =
                            Dict.insert id change.component hidden.components

                        updatedCache =
                            Dict.insert state.id updatedComponents change.cache

                        updatedHidden =
                            { hidden | components = updatedComponents }
                    in
                    { component = buildComponent updatedHidden
                    , states = change.states
                    , cache = updatedCache
                    , cmd = change.cmd
                    , signals = change.signals
                    , componentLocations = change.componentLocations
                    , lastComponentId = change.lastComponentId
                    }

                Nothing ->
                    noUpdate hidden args


doChange :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> ComponentState s m c
    -> Cmd m
    -> Sub m
    -> List (Signal pM pC)
    -> Node v w pM pC
    -> CommonArgs a pM pC
    -> Change pM pC
doChange spec (( _, set ) as slot) state cmd sub signals tree args =
    let
        updatedStates =
            set (StateContainer state) args.states

        mappedLocalCmd =
            Cmd.map (LocalMsg >> toParentSignal slot args.freshContainers) cmd

        mappedLocalSub =
            Sub.map (LocalMsg >> toParentSignal slot args.freshContainers) sub

        renderedComponents =
            collectRenderedComponents tree []

        childrenFoldInitialData =
            { children = []
            , orderedChildIds = []
            , states = updatedStates
            , cache = args.cache
            , cmd = mappedLocalCmd
            , signals = signals
            , componentLocations = args.componentLocations
            , lastComponentId = args.lastComponentId
            }

        processChild renderedComponent acc =
            let
                result =
                    case renderedComponent.status { states = acc.states } of
                        NewOrChanged ->
                            touchChild ()

                        Unchanged childId ->
                            reuseOrTouchChild childId

                touchChild () =
                    let
                        ( childId, change ) =
                            renderedComponent.touch
                                { states = acc.states
                                , cache = acc.cache
                                , componentLocations = acc.componentLocations
                                , lastComponentId = acc.lastComponentId
                                , freshContainers = args.freshContainers
                                , namespace = args.namespace
                                }
                    in
                    { childId = childId
                    , child = change.component
                    , states = change.states
                    , cache = change.cache
                    , cmd = change.cmd
                    , signals = change.signals
                    , componentLocations = change.componentLocations
                    , lastComponentId = change.lastComponentId
                    }

                reuseOrTouchChild childId =
                    case findCachedComponent state.id childId acc.cache of
                        Just cachedComponent ->
                            { childId = childId
                            , child = cachedComponent
                            , states = acc.states
                            , cache = acc.cache
                            , cmd = Cmd.none
                            , signals = []
                            , componentLocations = acc.componentLocations
                            , lastComponentId = acc.lastComponentId
                            }

                        Nothing ->
                            touchChild ()

                newComponentLocations =
                    result.componentLocations
                        |> Dict.insert result.childId state.id
            in
            { children = ( result.childId, result.child ) :: acc.children
            , orderedChildIds = result.childId :: acc.orderedChildIds
            , states = result.states
            , cache = result.cache
            , cmd = Cmd.batch [ acc.cmd, result.cmd ]
            , signals = acc.signals ++ result.signals
            , componentLocations = newComponentLocations
            , lastComponentId = result.lastComponentId
            }

        childrenFoldResults =
            List.foldr processChild childrenFoldInitialData renderedComponents

        children =
            Dict.fromList childrenFoldResults.children

        updatedComponent =
            buildComponent
                { spec = spec
                , slot = slot
                , sub = mappedLocalSub
                , tree = tree
                , components = children
                , orderedComponentIds = childrenFoldResults.orderedChildIds
                }

        updatedCache =
            Dict.insert state.id children childrenFoldResults.cache
    in
    { component = updatedComponent
    , states = childrenFoldResults.states
    , cache = updatedCache
    , cmd = childrenFoldResults.cmd
    , signals = childrenFoldResults.signals
    , componentLocations = childrenFoldResults.componentLocations
    , lastComponentId = childrenFoldResults.lastComponentId
    }


collectRenderedComponents :
    Node v w m c
    -> List (RenderedComponent m c)
    -> List (RenderedComponent m c)
collectRenderedComponents node acc =
    case node of
        SimpleElement { children } ->
            List.foldl collectRenderedComponents acc children

        Embedding { children } ->
            List.foldl collectRenderedComponents acc children

        ReversedEmbedding { children } ->
            List.foldl collectRenderedComponents acc children

        KeyedSimpleElement { children } ->
            List.foldl (Tuple.second >> collectRenderedComponents) acc children

        KeyedEmbedding { children } ->
            List.foldl (Tuple.second >> collectRenderedComponents) acc children

        KeyedReversedEmbedding { children } ->
            List.foldl (Tuple.second >> collectRenderedComponents) acc children

        Text _ ->
            acc

        PlainNode _ ->
            acc

        ComponentNode component ->
            component :: acc


findCachedComponent :
    ComponentId
    -> ComponentId
    -> Cache m c
    -> Maybe (ComponentInterface m c)
findCachedComponent thisId componentToFindId cache =
    case Dict.get thisId cache |> Maybe.andThen (Dict.get componentToFindId) of
        Just component ->
            Just component

        Nothing ->
            -- The component may have been moved here from another parent after
            -- the last update. We don't have access to all cached components,
            -- but at least we can try to find it among other owner's parts.
            Dict.foldl
                (\ownerPartId ownerPartChildren result ->
                    if result == Nothing && ownerPartId /= thisId then
                        Dict.get componentToFindId ownerPartChildren
                    else
                        result
                )
                Nothing
                cache


buildComponent : Hidden v w s m c pM pC -> ComponentInterface pM pC
buildComponent hidden =
    ComponentInterface
        { update = update hidden
        , subscriptions = subscriptions hidden
        , view = view hidden
        }


buildPathToTarget :
    UpdateArgs pM pC
    -> ComponentState s m c
    -> Identify c
    -> List ComponentId
buildPathToTarget args state identifyTarget =
    case identifyTarget { states = state.childStates } of
        Just targetId ->
            let
                build id path =
                    case Dict.get id args.componentLocations of
                        Just nextId ->
                            if nextId == state.id then
                                path
                            else
                                build nextId (nextId :: path)

                        Nothing ->
                            []
            in
            build targetId [ targetId ]

        Nothing ->
            []


noUpdate : Hidden v w s m c pM pC -> UpdateArgs pM pC -> Change pM pC
noUpdate hidden args =
    { component = buildComponent hidden
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , componentLocations = args.componentLocations
    , lastComponentId = args.lastComponentId
    }


subscriptions : Hidden v w s m c pM pC -> () -> Sub (Signal pM pC)
subscriptions hidden () =
    Dict.foldl
        (\_ (ComponentInterface component) acc ->
            Sub.batch
                [ acc
                , component.subscriptions ()
                ]
        )
        hidden.sub
        hidden.components


view : Hidden v w s m c pM pC -> () -> Html.Styled.Html (Signal pM pC)
view hidden () =
    if hidden.spec.options.lazyRender then
        Html.Styled.Lazy.lazy3 viewHelpLazy
            hidden.components
            hidden.orderedComponentIds
            hidden.tree
    else
        viewHelp
            hidden.components
            hidden.orderedComponentIds
            hidden.tree


viewHelp :
    Dict ComponentId (ComponentInterface m c)
    -> List ComponentId
    -> Node v w m c
    -> Html.Styled.Html (Signal m c)
viewHelp components orderedComponentIds tree =
    render components orderedComponentIds tree
        |> Tuple.first


viewHelpLazy :
    Dict ComponentId (ComponentInterface m c)
    -> List ComponentId
    -> Node v w m c
    -> VirtualDom.Node (Signal m c)
viewHelpLazy components orderedComponentIds tree =
    viewHelp components orderedComponentIds tree
        |> Html.Styled.toUnstyled


render :
    Dict ComponentId (ComponentInterface m c)
    -> List ComponentId
    -> Node v w m c
    -> ( Html.Styled.Html (Signal m c), List ComponentId )
render components orderedComponentIds node =
    case node of
        SimpleElement element ->
            renderElement components orderedComponentIds element

        Embedding element ->
            renderElement components orderedComponentIds element

        ReversedEmbedding element ->
            renderElement components orderedComponentIds element

        KeyedSimpleElement element ->
            renderKeyedElement components orderedComponentIds element

        KeyedEmbedding element ->
            renderKeyedElement components orderedComponentIds element

        KeyedReversedEmbedding element ->
            renderKeyedElement components orderedComponentIds element

        Text string ->
            ( Html.Styled.text string
            , orderedComponentIds
            )

        PlainNode node ->
            ( Html.Styled.fromUnstyled node
            , orderedComponentIds
            )

        ComponentNode _ ->
            case orderedComponentIds of
                id :: otherIds ->
                    case Dict.get id components of
                        Just (ComponentInterface component) ->
                            ( component.view ()
                            , otherIds
                            )

                        Nothing ->
                            ( Html.Styled.text ""
                            , otherIds
                            )

                [] ->
                    ( Html.Styled.text ""
                    , []
                    )


renderElement :
    Dict ComponentId (ComponentInterface m c)
    -> List ComponentId
    -> Element x y z m c
    -> ( Html.Styled.Html (Signal m c), List ComponentId )
renderElement components orderedComponentIds element =
    let
        renderChild child ( renderedChildren, ids ) =
            let
                ( renderedChild, newIds ) =
                    render components ids child
            in
            ( renderedChild :: renderedChildren
            , newIds
            )

        ( children, remainingIds ) =
            List.foldr renderChild ( [], orderedComponentIds ) element.children

        attributes =
            List.map toStyledAttribute element.attributes

        renderedElement =
            Html.Styled.node element.tag attributes children
    in
    ( renderedElement, remainingIds )


renderKeyedElement :
    Dict ComponentId (ComponentInterface m c)
    -> List ComponentId
    -> KeyedElement x y z m c
    -> ( Html.Styled.Html (Signal m c), List ComponentId )
renderKeyedElement components orderedComponentIds element =
    let
        renderChild ( key, child ) ( renderedChildren, ids ) =
            let
                ( renderedChild, newIds ) =
                    render components ids child
            in
            ( ( key, renderedChild ) :: renderedChildren
            , newIds
            )

        ( children, remainingIds ) =
            List.foldr renderChild ( [], orderedComponentIds ) element.children

        attributes =
            List.map toStyledAttribute element.attributes

        renderedElement =
            Html.Styled.Keyed.node element.tag attributes children
    in
    ( renderedElement, remainingIds )


toStyledAttribute : Attribute v m c -> Html.Styled.Attribute (Signal m c)
toStyledAttribute attribute =
    case attribute of
        PlainAttribute property ->
            Html.Styled.Attributes.fromUnstyled property

        Styles ClassNameProperty styles ->
            Html.Styled.Attributes.css styles

        Styles ClassAttribute styles ->
            Svg.Styled.Attributes.css styles


getSelf :
    Spec v w s m c pM pC
    -> Slot (Container s m c) pC
    -> ComponentId
    -> { a | freshContainers : pC, namespace : String }
    -> Self s m c pC
getSelf spec slot id args =
    { id = "_" ++ args.namespace ++ "_" ++ toString id
    , internal =
        InternalStuff
            { slot = slot
            , freshContainers = spec.children
            , freshParentContainers = args.freshContainers
            }
    }


convertSignal : Self s m c pC -> Signal m c -> Signal pM pC
convertSignal self =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    toParentSignal slot freshParentContainers


convertAttribute : Self s m c pC -> Attribute v m c -> Attribute v pM pC
convertAttribute self attribute =
    case attribute of
        PlainAttribute property ->
            property
                |> VirtualDom.mapProperty (convertSignal self)
                |> PlainAttribute

        Styles strategy styles ->
            Styles strategy styles


convertNode : Self s m c pC -> Node v w m c -> Node v w pM pC
convertNode self node =
    case node of
        SimpleElement element ->
            SimpleElement (convertElement self element)

        Embedding element ->
            Embedding (convertElement self element)

        ReversedEmbedding element ->
            ReversedEmbedding (convertElement self element)

        KeyedSimpleElement element ->
            KeyedSimpleElement (convertKeyedElement self element)

        KeyedEmbedding element ->
            KeyedEmbedding (convertKeyedElement self element)

        KeyedReversedEmbedding element ->
            KeyedReversedEmbedding (convertKeyedElement self element)

        Text string ->
            Text string

        PlainNode node ->
            PlainNode (VirtualDom.map (convertSignal self) node)

        ComponentNode component ->
            ComponentNode (convertRenderedComponent self component)


convertElement : Self s m c pC -> Element x y z m c -> Element x y z pM pC
convertElement self element =
    { tag = element.tag
    , attributes = List.map (convertAttribute self) element.attributes
    , children = List.map (convertNode self) element.children
    }


convertKeyedElement :
    Self s m c pC
    -> KeyedElement x y z m c
    -> KeyedElement x y z pM pC
convertKeyedElement self element =
    { tag = element.tag
    , attributes = List.map (convertAttribute self) element.attributes
    , children = List.map (Tuple.mapSecond (convertNode self)) element.children
    }


convertRenderedComponent :
    Self s m c pC
    -> RenderedComponent m c
    -> RenderedComponent pM pC
convertRenderedComponent self component =
    { status = convertStatus self component
    , touch = convertTouch self component
    }


convertStatus :
    Self s m c pC
    -> RenderedComponent m c
    -> { states : pC }
    -> ComponentStatus
convertStatus self component args =
    let
        (InternalStuff { slot }) =
            self.internal

        ( get, _ ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            component.status { states = state.childStates }

        _ ->
            NewOrChanged


convertTouch :
    Self s m c pC
    -> RenderedComponent m c
    -> TouchArgs pM pC
    -> ( ComponentId, Change pM pC )
convertTouch self component args =
    let
        (InternalStuff { slot, freshContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            component.touch
                { states = state.childStates
                , cache = state.cache
                , freshContainers = freshContainers
                , lastComponentId = args.lastComponentId
                , componentLocations = args.componentLocations
                , namespace = args.namespace
                }
                |> Tuple.mapSecond (convertChange self args state)

        _ ->
            ( -1, dummyChange args )


convertComponent :
    Self s m c pC
    -> ComponentInterface m c
    -> ComponentInterface pM pC
convertComponent self component =
    ComponentInterface <|
        { update = convertUpdate self component
        , subscriptions = convertSubscriptions self component
        , view = convertView self component
        }


convertUpdate :
    Self s m c pC
    -> ComponentInterface m c
    -> UpdateArgs pM pC
    -> Change pM pC
convertUpdate self (ComponentInterface component) args =
    let
        (InternalStuff { slot, freshContainers }) =
            self.internal

        ( get, _ ) =
            slot
    in
    case ( get args.states, get args.signalContainers ) of
        ( StateContainer state, SignalContainer (ChildMsg _ signalContainers) ) ->
            component.update
                { states = state.childStates
                , cache = state.cache
                , pathToTarget = args.pathToTarget
                , signalContainers = signalContainers
                , freshContainers = freshContainers
                , componentLocations = args.componentLocations
                , lastComponentId = args.lastComponentId
                , namespace = args.namespace
                }
                |> convertChange self args state

        ( _, _ ) ->
            { component = convertComponent self (ComponentInterface component)
            , states = args.states
            , cache = args.cache
            , cmd = Cmd.none
            , signals = []
            , componentLocations = args.componentLocations
            , lastComponentId = args.lastComponentId
            }


convertChange :
    Self s m c pC
    -> CommonArgs a pM pC
    -> ComponentState s m c
    -> Change m c
    -> Change pM pC
convertChange self args state change =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal

        ( _, set ) =
            slot

        updatedState =
            { state
                | childStates = change.states
                , cache = change.cache
            }

        cmd =
            change.cmd
                |> Cmd.map (toParentSignal slot freshParentContainers)

        signals =
            change.signals
                |> List.map (toParentSignal slot freshParentContainers)
    in
    { component = convertComponent self change.component
    , states = set (StateContainer updatedState) args.states
    , cache = args.cache
    , cmd = cmd
    , signals = signals
    , componentLocations = change.componentLocations
    , lastComponentId = change.lastComponentId
    }


convertSubscriptions :
    Self s m c pC
    -> ComponentInterface m c
    -> ()
    -> Sub (Signal pM pC)
convertSubscriptions self (ComponentInterface component) () =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    component.subscriptions ()
        |> Sub.map (toParentSignal slot freshParentContainers)


convertView :
    Self s m c pC
    -> ComponentInterface m c
    -> ()
    -> Html.Styled.Html (Signal pM pC)
convertView self (ComponentInterface component) () =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    component.view ()
        |> Html.Styled.map (toParentSignal slot freshParentContainers)


convertSlot :
    Self s m c pC
    -> Slot (Container cS cM cC) c
    -> Slot (Container cS cM cC) pC
convertSlot self (( getChild, setChild ) as childSlot) =
    let
        (InternalStuff { slot, freshContainers }) =
            self.internal

        ( get, set ) =
            slot

        convertedGet parentContainers =
            case get parentContainers of
                EmptyContainer ->
                    EmptyContainer

                StateContainer state ->
                    getChild state.childStates

                SignalContainer (LocalMsg _) ->
                    EmptyContainer

                SignalContainer (ChildMsg _ containers) ->
                    getChild containers

        convertedSet childContainer parentContainers =
            case get parentContainers of
                EmptyContainer ->
                    case childContainer of
                        EmptyContainer ->
                            parentContainers

                        StateContainer _ ->
                            -- We don't have current component's local state
                            -- so we can't do anything here. This situation
                            -- mustn't occur in practice anyway.
                            parentContainers

                        SignalContainer _ ->
                            set (wrapSignal childContainer) parentContainers

                StateContainer state ->
                    let
                        updatedChildStates =
                            setChild childContainer state.childStates

                        updatedState =
                            { state | childStates = updatedChildStates }
                    in
                    set (StateContainer updatedState) parentContainers

                SignalContainer _ ->
                    set (wrapSignal childContainer) parentContainers

        wrapSignal childContainer =
            freshContainers
                |> setChild childContainer
                |> ChildMsg (identify childSlot)
                |> SignalContainer
    in
    ( convertedGet, convertedSet )


sendToChild : Self s m c pC -> Slot (Container cS cM cC) c -> cM -> Signal pM pC
sendToChild self childSlot childMsg =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal
    in
    childMsg
        |> LocalMsg
        |> toParentSignal childSlot freshContainers
        |> toParentSignal slot freshParentContainers


dummyChange : CommonArgs a m c -> Change m c
dummyChange args =
    { component = dummyComponent
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , componentLocations = args.componentLocations
    , lastComponentId = args.lastComponentId
    }


dummyComponent : ComponentInterface m c
dummyComponent =
    ComponentInterface
        { update = dummyChange
        , subscriptions = \_ -> Sub.none
        , view = \_ -> Html.Styled.text ""
        }
