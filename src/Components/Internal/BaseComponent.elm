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


type alias Spec v w s m p pM pP =
    { init : Self s m p pP -> ( s, Cmd m, List (Signal pM pP) )
    , update : Self s m p pP -> m -> s -> ( s, Cmd m, List (Signal pM pP) )
    , subscriptions : Self s m p pP -> s -> Sub m
    , view : Self s m p pP -> s -> Node v w pM pP
    , parts : p
    , options : Options s m
    }


type alias Self s m p pP =
    { id : String
    , internal : InternalStuff s m p pP
    }


type InternalStuff s m p pP
    = InternalStuff
        { slot : Slot (Container s m p) pP
        , freshContainers : p
        , freshParentContainers : pP
        }


type alias Options s m =
    { onContextUpdate : Maybe m
    , shouldRecalculate : s -> Bool
    , lazyRender : Bool
    }


type alias Hidden v w s m p pM pP =
    { spec : Spec v w s m p pM pP
    , slot : Slot (Container s m p) pP
    , sub : Sub (Signal pM pP)
    , tree : Node v w pM pP
    , children : Dict ComponentId (ComponentInterface pM pP)
    , orderedChildIds : List ComponentId
    }


type alias CommonArgs a m p =
    { a
        | states : p
        , cache : Cache m p
        , freshContainers : p
        , componentLocations : ComponentLocations
        , lastComponentId : ComponentId
        , namespace : String
    }


baseComponent : Spec v w s m p pM pP -> Component v w (Container s m p) pM pP
baseComponent spec =
    Component <|
        \slot ->
            ComponentNode (renderedComponent spec slot)


renderedComponent :
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> RenderedComponent pM pP
renderedComponent spec slot =
    { status = status spec slot
    , touch = touch spec slot
    }


status :
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> { states : pP }
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
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> TouchArgs pM pP
    -> ( ComponentId, Change pM pP )
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
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> TouchArgs pM pP
    -> ( ComponentId, Change pM pP )
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
            , childStates = spec.parts
            , cache = Dict.empty
            }

        updatedArgs =
            { args | lastComponentId = id }
    in
    ( id
    , doChange spec slot state cmd sub signals tree updatedArgs
    )


rebuild :
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> ComponentState s m p
    -> TouchArgs pM pP
    -> Change pM pP
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


update : Hidden v w s m p pM pP -> UpdateArgs pM pP -> Change pM pP
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
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> ComponentState s m p
    -> m
    -> CommonArgs a pM pP
    -> Change pM pP
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
    Hidden v w s m p pM pP
    -> ComponentState s m p
    -> UpdateArgs pM pP
    -> Change pM pP
updateChild hidden state args =
    case args.pathToTarget of
        [] ->
            noUpdate hidden args

        id :: pathToTarget ->
            case Dict.get id hidden.children of
                Just (ComponentInterface component) ->
                    let
                        change =
                            component.update
                                { args | pathToTarget = pathToTarget }

                        updatedChildren =
                            Dict.insert id change.component hidden.children

                        updatedCache =
                            Dict.insert state.id updatedChildren change.cache

                        updatedComponent =
                            buildComponent
                                { hidden | children = updatedChildren }
                    in
                    { component = updatedComponent
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
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> ComponentState s m p
    -> Cmd m
    -> Sub m
    -> List (Signal pM pP)
    -> Node v w pM pP
    -> CommonArgs a pM pP
    -> Change pM pP
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
                , children = children
                , orderedChildIds = childrenFoldResults.orderedChildIds
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
    Node v w m p
    -> List (RenderedComponent m p)
    -> List (RenderedComponent m p)
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
    -> Cache m p
    -> Maybe (ComponentInterface m p)
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


buildComponent : Hidden v w s m p pM pP -> ComponentInterface pM pP
buildComponent hidden =
    ComponentInterface
        { update = update hidden
        , subscriptions = subscriptions hidden
        , view = view hidden
        }


buildPathToTarget :
    UpdateArgs pM pP
    -> ComponentState s m p
    -> Identify p
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


noUpdate : Hidden v w s m p pM pP -> UpdateArgs pM pP -> Change pM pP
noUpdate hidden args =
    { component = buildComponent hidden
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , componentLocations = args.componentLocations
    , lastComponentId = args.lastComponentId
    }


subscriptions : Hidden v w s m p pM pP -> () -> Sub (Signal pM pP)
subscriptions hidden () =
    Dict.foldl
        (\_ (ComponentInterface child) acc ->
            Sub.batch
                [ acc
                , child.subscriptions ()
                ]
        )
        hidden.sub
        hidden.children


view : Hidden v w s m p pM pP -> () -> Html.Styled.Html (Signal pM pP)
view hidden () =
    if hidden.spec.options.lazyRender then
        Html.Styled.Lazy.lazy3 viewHelpLazy
            hidden.children
            hidden.orderedChildIds
            hidden.tree
    else
        viewHelp
            hidden.children
            hidden.orderedChildIds
            hidden.tree


viewHelp :
    Dict ComponentId (ComponentInterface m p)
    -> List ComponentId
    -> Node v w m p
    -> Html.Styled.Html (Signal m p)
viewHelp components orderedComponentIds tree =
    render components orderedComponentIds tree
        |> Tuple.first


viewHelpLazy :
    Dict ComponentId (ComponentInterface m p)
    -> List ComponentId
    -> Node v w m p
    -> VirtualDom.Node (Signal m p)
viewHelpLazy components orderedComponentIds tree =
    viewHelp components orderedComponentIds tree
        |> Html.Styled.toUnstyled


render :
    Dict ComponentId (ComponentInterface m p)
    -> List ComponentId
    -> Node v w m p
    -> ( Html.Styled.Html (Signal m p), List ComponentId )
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
    Dict ComponentId (ComponentInterface m p)
    -> List ComponentId
    -> Element x y z m p
    -> ( Html.Styled.Html (Signal m p), List ComponentId )
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
    Dict ComponentId (ComponentInterface m p)
    -> List ComponentId
    -> KeyedElement x y z m p
    -> ( Html.Styled.Html (Signal m p), List ComponentId )
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


toStyledAttribute : Attribute v m p -> Html.Styled.Attribute (Signal m p)
toStyledAttribute attribute =
    case attribute of
        PlainAttribute property ->
            Html.Styled.Attributes.fromUnstyled property

        Styles ClassNameProperty styles ->
            Html.Styled.Attributes.css styles

        Styles ClassAttribute styles ->
            Svg.Styled.Attributes.css styles


getSelf :
    Spec v w s m p pM pP
    -> Slot (Container s m p) pP
    -> ComponentId
    -> { a | freshContainers : pP, namespace : String }
    -> Self s m p pP
getSelf spec slot id args =
    { id = "_" ++ args.namespace ++ "_" ++ toString id
    , internal =
        InternalStuff
            { slot = slot
            , freshContainers = spec.parts
            , freshParentContainers = args.freshContainers
            }
    }


convertSignal : Self s m p pP -> Signal m p -> Signal pM pP
convertSignal self =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    toParentSignal slot freshParentContainers


convertAttribute : Self s m p pP -> Attribute v m p -> Attribute v pM pP
convertAttribute self attribute =
    case attribute of
        PlainAttribute property ->
            property
                |> VirtualDom.mapProperty (convertSignal self)
                |> PlainAttribute

        Styles strategy styles ->
            Styles strategy styles


convertNode : Self s m p pP -> Node v w m p -> Node v w pM pP
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


convertElement : Self s m p pP -> Element x y z m p -> Element x y z pM pP
convertElement self element =
    { tag = element.tag
    , attributes = List.map (convertAttribute self) element.attributes
    , children = List.map (convertNode self) element.children
    }


convertKeyedElement :
    Self s m p pP
    -> KeyedElement x y z m p
    -> KeyedElement x y z pM pP
convertKeyedElement self element =
    { tag = element.tag
    , attributes = List.map (convertAttribute self) element.attributes
    , children = List.map (Tuple.mapSecond (convertNode self)) element.children
    }


convertRenderedComponent :
    Self s m p pP
    -> RenderedComponent m p
    -> RenderedComponent pM pP
convertRenderedComponent self component =
    { status = convertStatus self component
    , touch = convertTouch self component
    }


convertStatus :
    Self s m p pP
    -> RenderedComponent m p
    -> { states : pP }
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
    Self s m p pP
    -> RenderedComponent m p
    -> TouchArgs pM pP
    -> ( ComponentId, Change pM pP )
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
    Self s m p pP
    -> ComponentInterface m p
    -> ComponentInterface pM pP
convertComponent self component =
    ComponentInterface <|
        { update = convertUpdate self component
        , subscriptions = convertSubscriptions self component
        , view = convertView self component
        }


convertUpdate :
    Self s m p pP
    -> ComponentInterface m p
    -> UpdateArgs pM pP
    -> Change pM pP
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
    Self s m p pP
    -> CommonArgs a pM pP
    -> ComponentState s m p
    -> Change m p
    -> Change pM pP
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
    Self s m p pP
    -> ComponentInterface m p
    -> ()
    -> Sub (Signal pM pP)
convertSubscriptions self (ComponentInterface component) () =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    component.subscriptions ()
        |> Sub.map (toParentSignal slot freshParentContainers)


convertView :
    Self s m p pP
    -> ComponentInterface m p
    -> ()
    -> Html.Styled.Html (Signal pM pP)
convertView self (ComponentInterface component) () =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    component.view ()
        |> Html.Styled.map (toParentSignal slot freshParentContainers)


convertSlot :
    Self s m p pP
    -> Slot (Container cS cM cP) p
    -> Slot (Container cS cM cP) pP
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


sendToChild : Self s m p pP -> Slot (Container cS cM cP) p -> cM -> Signal pM pP
sendToChild self childSlot childMsg =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal
    in
    childMsg
        |> LocalMsg
        |> toParentSignal childSlot freshContainers
        |> toParentSignal slot freshParentContainers


dummyChange : CommonArgs a m p -> Change m p
dummyChange args =
    { component = dummyComponent
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , componentLocations = args.componentLocations
    , lastComponentId = args.lastComponentId
    }


dummyComponent : ComponentInterface m p
dummyComponent =
    ComponentInterface
        { update = dummyChange
        , subscriptions = \_ -> Sub.none
        , view = \_ -> Html.Styled.text ""
        }
