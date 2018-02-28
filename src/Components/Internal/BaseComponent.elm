module Components.Internal.BaseComponent
    exposing
        ( Self
        , Spec
        , baseComponent
        , convertAttribute
        , convertNode
        , convertSignal
        , convertSlot
        )

import Components.Internal.Core exposing (..)
import Components.Internal.Shared exposing (identify, toOwnerSignal)
import Dict exposing (Dict)
import Html.Styled
import Html.Styled.Attributes
import Html.Styled.Keyed
import Html.Styled.Lazy
import Svg.Styled.Attributes
import VirtualDom


type alias Spec v w s m p oM oP =
    { init : Self s m p oP -> ( s, Cmd m, List (Signal oM oP) )
    , update : Self s m p oP -> m -> s -> ( s, Cmd m, List (Signal oM oP) )
    , subscriptions : Self s m p oP -> s -> Sub m
    , view : Self s m p oP -> s -> Node v w oM oP
    , onContextUpdate : Maybe m
    , shouldRecalculate : s -> Bool
    , lazyRender : Bool
    , parts : p
    }


type alias Self s m p oP =
    { id : String
    , internal : ComponentInternalStuff s m p oP
    }


type alias Hidden v w s m p oM oP =
    { spec : Spec v w s m p oM oP
    , slot : Slot (Container s m p) oP
    , id : ComponentId
    , sub : Sub (Signal oM oP)
    , tree : Node v w oM oP
    , children : Dict ComponentId (ComponentInterface oM oP)
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


baseComponent : Spec v w s m p oM oP -> Component v (Container s m p) oM oP
baseComponent spec =
    Component (\slot -> renderedComponent spec slot)


renderedComponent :
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> RenderedComponent oM oP
renderedComponent spec slot =
    { status = status spec slot
    , touch = touch spec slot
    }


status :
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> { states : oP }
    -> ComponentStatus
status spec ( get, _ ) args =
    case get args.states of
        StateContainer state ->
            if spec.shouldRecalculate state.localState then
                NewOrChanged
            else
                Unchanged state.id

        _ ->
            NewOrChanged


touch :
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> TouchArgs oM oP
    -> ( ComponentId, Change oM oP )
touch spec (( get, _ ) as slot) args =
    case get args.states of
        StateContainer state ->
            case spec.onContextUpdate of
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
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> TouchArgs oM oP
    -> ( ComponentId, Change oM oP )
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
            , partStates = spec.parts
            , cache = Dict.empty
            }

        updatedArgs =
            { args | lastComponentId = id }
    in
    ( id
    , doChange spec slot state cmd sub signals tree updatedArgs
    )


rebuild :
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> ComponentState s m p
    -> TouchArgs oM oP
    -> Change oM oP
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


update : Hidden v w s m p oM oP -> UpdateArgs oM oP -> Change oM oP
update ({ spec, slot } as hidden) args =
    let
        ( get, _ ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            case args.path of
                childId :: subpath ->
                    updateChild childId subpath hidden state args

                [] ->
                    case get args.signalContainers of
                        EmptyContainer ->
                            noUpdate hidden args

                        StateContainer _ ->
                            -- This is an "impossible" case and should be
                            -- ignored, but it shouldn't be handled last so that
                            -- an exception will be thrown if a user runs into
                            -- this bug:
                            -- https://github.com/elm-lang/virtual-dom/issues/73
                            -- (otherwise it will be silently ignored).
                            noUpdate hidden args

                        SignalContainer (LocalMsg msg) ->
                            if state.id <= args.maxPossibleTargetId then
                                doLocalUpdate spec slot state msg args
                            else
                                noUpdate hidden args

                        SignalContainer (PartMsg identifyPart _) ->
                            case buildPathToPart args state identifyPart of
                                childId :: path ->
                                    updateChild childId path hidden state args

                                [] ->
                                    noUpdate hidden args

        _ ->
            noUpdate hidden args


buildPathToPart :
    UpdateArgs oM oP
    -> ComponentState s m p
    -> Identify p
    -> List ComponentId
buildPathToPart args state identifyPart =
    case identifyPart { states = state.partStates } of
        Just partId ->
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
            build partId [ partId ]

        Nothing ->
            []


doLocalUpdate :
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> ComponentState s m p
    -> m
    -> CommonArgs a oM oP
    -> Change oM oP
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
    ComponentId
    -> List ComponentId
    -> Hidden v w s m p oM oP
    -> ComponentState s m p
    -> UpdateArgs oM oP
    -> Change oM oP
updateChild childId path hidden state args =
    case Dict.get childId hidden.children of
        Just (ComponentInterface component) ->
            let
                change =
                    component.update { args | path = path }

                updatedChildren =
                    Dict.insert childId change.component hidden.children

                updatedCache =
                    Dict.insert state.id updatedChildren change.cache

                updatedComponent =
                    buildComponent { hidden | children = updatedChildren }
            in
            { component = updatedComponent
            , states = change.states
            , cache = updatedCache
            , cmd = change.cmd
            , signals = change.signals
            , componentLocations = change.componentLocations
            , lastComponentId = change.lastComponentId
            , cleanup = change.cleanup
            }

        Nothing ->
            noUpdate hidden args


doChange :
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> ComponentState s m p
    -> Cmd m
    -> Sub m
    -> List (Signal oM oP)
    -> Node v w oM oP
    -> CommonArgs a oM oP
    -> Change oM oP
doChange spec (( _, set ) as slot) state cmd sub signals tree args =
    let
        mappedLocalCmd =
            Cmd.map (LocalMsg >> toOwnerSignal slot args.freshContainers) cmd

        mappedLocalSub =
            Sub.map (LocalMsg >> toOwnerSignal slot args.freshContainers) sub

        oldChildren =
            args.cache
                |> Dict.get state.id
                |> Maybe.withDefault Dict.empty

        renderedComponents =
            collectRenderedComponents tree []

        childrenFoldInitialData =
            { children = []
            , orderedChildIds = []
            , states = set (StateContainer state) args.states
            , cache = args.cache
            , cmd = mappedLocalCmd
            , signals = signals
            , componentLocations = args.componentLocations
            , lastComponentId = args.lastComponentId
            , cleanups = []
            }

        processChild renderedComponent data =
            let
                result =
                    case renderedComponent.status { states = data.states } of
                        NewOrChanged ->
                            touchChild ()

                        Unchanged childId ->
                            reuseOrTouchChild childId

                touchChild () =
                    let
                        ( childId, change ) =
                            renderedComponent.touch
                                { states = data.states
                                , cache = data.cache
                                , componentLocations = data.componentLocations
                                , lastComponentId = data.lastComponentId
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
                    , cleanups = change.cleanup :: data.cleanups
                    }

                reuseOrTouchChild childId =
                    case Dict.get childId oldChildren of
                        Just cachedComponent ->
                            { childId = childId
                            , child = cachedComponent
                            , states = data.states
                            , cache = data.cache
                            , cmd = Cmd.none
                            , signals = []
                            , componentLocations = data.componentLocations
                            , lastComponentId = data.lastComponentId
                            , cleanups = data.cleanups
                            }

                        Nothing ->
                            touchChild ()

                componentLocations =
                    result.componentLocations
                        |> Dict.insert result.childId state.id
            in
            { children = ( result.childId, result.child ) :: data.children
            , orderedChildIds = result.childId :: data.orderedChildIds
            , states = result.states
            , cache = result.cache
            , cmd = Cmd.batch [ data.cmd, result.cmd ]
            , signals = data.signals ++ result.signals
            , componentLocations = componentLocations
            , lastComponentId = result.lastComponentId
            , cleanups = result.cleanups
            }

        childrenFoldResults =
            List.foldr processChild childrenFoldInitialData renderedComponents

        newChildren =
            Dict.fromList childrenFoldResults.children

        removedChildren =
            Dict.diff oldChildren newChildren

        updatedComponent =
            buildComponent
                { spec = spec
                , slot = slot
                , id = state.id
                , sub = mappedLocalSub
                , tree = tree
                , children = newChildren
                , orderedChildIds = childrenFoldResults.orderedChildIds
                }

        updatedCache =
            Dict.insert state.id newChildren childrenFoldResults.cache

        cleanup =
            destroyChildComponents state.id removedChildren
    in
    { component = updatedComponent
    , states = childrenFoldResults.states
    , cache = updatedCache
    , cmd = childrenFoldResults.cmd
    , signals = childrenFoldResults.signals
    , componentLocations = childrenFoldResults.componentLocations
    , lastComponentId = childrenFoldResults.lastComponentId
    , cleanup = combineCleanups (cleanup :: childrenFoldResults.cleanups)
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


combineCleanups :
    List (DestroyArgs m p -> DestroyArgs m p)
    -> DestroyArgs m p
    -> DestroyArgs m p
combineCleanups cleanups args =
    List.foldl (\fn result -> fn result) args cleanups


noUpdate : Hidden v w s m p oM oP -> UpdateArgs oM oP -> Change oM oP
noUpdate hidden args =
    { component = buildComponent hidden
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , componentLocations = args.componentLocations
    , lastComponentId = args.lastComponentId
    , cleanup = identity
    }


buildComponent : Hidden v w s m p oM oP -> ComponentInterface oM oP
buildComponent hidden =
    ComponentInterface
        { update = update hidden
        , destroy = destroy hidden
        , subscriptions = subscriptions hidden
        , view = view hidden
        }


destroy : Hidden v w s m p oM oP -> DestroyArgs oM oP -> DestroyArgs oM oP
destroy hidden args =
    let
        ( _, set ) =
            hidden.slot

        { states, cache, componentLocations } =
            destroyChildComponents hidden.id hidden.children args
    in
    { states = set EmptyContainer states
    , cache = Dict.remove hidden.id cache
    , componentLocations = Dict.remove hidden.id componentLocations
    }


destroyChildComponents :
    ComponentId
    -> Dict ComponentId (ComponentInterface m p)
    -> DestroyArgs m p
    -> DestroyArgs m p
destroyChildComponents parentId components args =
    Dict.foldl
        (\id (ComponentInterface component) result ->
            let
                currentParentId =
                    Dict.get id result.componentLocations
            in
            if currentParentId == Just parentId then
                component.destroy result
            else
                result
        )
        args
        components


subscriptions : Hidden v w s m p oM oP -> () -> Sub (Signal oM oP)
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


view : Hidden v w s m p oM oP -> () -> Html.Styled.Html (Signal oM oP)
view hidden () =
    if hidden.spec.lazyRender then
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
            List.filterMap toStyledAttribute element.attributes

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
            List.filterMap toStyledAttribute element.attributes

        renderedElement =
            Html.Styled.Keyed.node element.tag attributes children
    in
    ( renderedElement, remainingIds )


toStyledAttribute :
    Attribute v m p
    -> Maybe (Html.Styled.Attribute (Signal m p))
toStyledAttribute attribute =
    case attribute of
        PlainAttribute property ->
            Just (Html.Styled.Attributes.fromUnstyled property)

        Styles ClassNameProperty styles ->
            Just (Html.Styled.Attributes.css styles)

        Styles ClassAttribute styles ->
            Just (Svg.Styled.Attributes.css styles)

        NullAttribute ->
            Nothing


getSelf :
    Spec v w s m p oM oP
    -> Slot (Container s m p) oP
    -> ComponentId
    -> { a | freshContainers : oP, namespace : String }
    -> Self s m p oP
getSelf spec slot id args =
    { id = "_" ++ args.namespace ++ "_" ++ toString id
    , internal =
        ComponentInternalStuff
            { slot = slot
            , freshContainers = spec.parts
            , freshOwnerContainers = args.freshContainers
            }
    }


convertSignal : Self s m p oP -> Signal m p -> Signal oM oP
convertSignal self =
    let
        (ComponentInternalStuff { slot, freshOwnerContainers }) =
            self.internal
    in
    toOwnerSignal slot freshOwnerContainers


convertAttribute : Self s m p oP -> Attribute v m p -> Attribute v oM oP
convertAttribute self attribute =
    case attribute of
        PlainAttribute property ->
            property
                |> VirtualDom.mapProperty (convertSignal self)
                |> PlainAttribute

        Styles strategy styles ->
            Styles strategy styles

        NullAttribute ->
            NullAttribute


convertNode : Self s m p oP -> Node v w m p -> Node v w oM oP
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


convertElement : Self s m p oP -> Element x y z m p -> Element x y z oM oP
convertElement self element =
    { tag = element.tag
    , attributes = List.map (convertAttribute self) element.attributes
    , children = List.map (convertNode self) element.children
    }


convertKeyedElement :
    Self s m p oP
    -> KeyedElement x y z m p
    -> KeyedElement x y z oM oP
convertKeyedElement self element =
    { tag = element.tag
    , attributes = List.map (convertAttribute self) element.attributes
    , children = List.map (Tuple.mapSecond (convertNode self)) element.children
    }


convertRenderedComponent :
    Self s m p oP
    -> RenderedComponent m p
    -> RenderedComponent oM oP
convertRenderedComponent self component =
    { status = convertStatus self component
    , touch = convertTouch self component
    }


convertStatus :
    Self s m p oP
    -> RenderedComponent m p
    -> { states : oP }
    -> ComponentStatus
convertStatus self component args =
    let
        (ComponentInternalStuff { slot }) =
            self.internal

        ( get, _ ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            component.status { states = state.partStates }

        _ ->
            NewOrChanged


convertTouch :
    Self s m p oP
    -> RenderedComponent m p
    -> TouchArgs oM oP
    -> ( ComponentId, Change oM oP )
convertTouch self component args =
    let
        (ComponentInternalStuff { slot, freshContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            component.touch
                { states = state.partStates
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
    Self s m p oP
    -> ComponentInterface m p
    -> ComponentInterface oM oP
convertComponent self component =
    ComponentInterface <|
        { update = convertUpdate self component
        , destroy = convertDestroy self component
        , subscriptions = convertSubscriptions self component
        , view = convertView self component
        }


convertUpdate :
    Self s m p oP
    -> ComponentInterface m p
    -> UpdateArgs oM oP
    -> Change oM oP
convertUpdate self (ComponentInterface component) args =
    let
        (ComponentInternalStuff { slot, freshContainers }) =
            self.internal

        ( get, _ ) =
            slot
    in
    case ( get args.states, get args.signalContainers ) of
        ( StateContainer state, SignalContainer (PartMsg _ signalContainers) ) ->
            component.update
                { states = state.partStates
                , cache = state.cache
                , signalContainers = signalContainers
                , path = args.path
                , maxPossibleTargetId = args.maxPossibleTargetId
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
            , cleanup = identity
            }


convertChange :
    Self s m p oP
    -> CommonArgs a oM oP
    -> ComponentState s m p
    -> Change m p
    -> Change oM oP
convertChange self args state change =
    let
        (ComponentInternalStuff { slot, freshOwnerContainers }) =
            self.internal

        ( _, set ) =
            slot

        updatedState =
            { state
                | partStates = change.states
                , cache = change.cache
            }

        cmd =
            change.cmd
                |> Cmd.map (toOwnerSignal slot freshOwnerContainers)

        signals =
            change.signals
                |> List.map (toOwnerSignal slot freshOwnerContainers)
    in
    { component = convertComponent self change.component
    , states = set (StateContainer updatedState) args.states
    , cache = args.cache
    , cmd = cmd
    , signals = signals
    , componentLocations = change.componentLocations
    , lastComponentId = change.lastComponentId
    , cleanup = convertDestroyOrCleanup self change.cleanup
    }


convertDestroy :
    Self s m p oP
    -> ComponentInterface m p
    -> DestroyArgs oM oP
    -> DestroyArgs oM oP
convertDestroy self (ComponentInterface component) args =
    convertDestroyOrCleanup self component.destroy args


convertDestroyOrCleanup :
    Self s m p oP
    -> (DestroyArgs m p -> DestroyArgs m p)
    -> (DestroyArgs oM oP -> DestroyArgs oM oP)
convertDestroyOrCleanup self fn args =
    let
        (ComponentInternalStuff { slot }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            let
                result =
                    fn
                        { states = state.partStates
                        , cache = state.cache
                        , componentLocations = args.componentLocations
                        }

                updatedState =
                    { state
                        | partStates = result.states
                        , cache = result.cache
                    }
            in
            { states = set (StateContainer updatedState) args.states
            , cache = args.cache
            , componentLocations = result.componentLocations
            }

        _ ->
            args


convertSubscriptions :
    Self s m p oP
    -> ComponentInterface m p
    -> ()
    -> Sub (Signal oM oP)
convertSubscriptions self (ComponentInterface component) () =
    let
        (ComponentInternalStuff { slot, freshOwnerContainers }) =
            self.internal
    in
    component.subscriptions ()
        |> Sub.map (toOwnerSignal slot freshOwnerContainers)


convertView :
    Self s m p oP
    -> ComponentInterface m p
    -> ()
    -> Html.Styled.Html (Signal oM oP)
convertView self (ComponentInterface component) () =
    let
        (ComponentInternalStuff { slot, freshOwnerContainers }) =
            self.internal
    in
    component.view ()
        |> Html.Styled.map (toOwnerSignal slot freshOwnerContainers)


convertSlot :
    Self s m p oP
    -> Slot (Container pS pM pP) p
    -> Slot (Container pS pM pP) oP
convertSlot self (( getPart, setPart ) as partSlot) =
    let
        (ComponentInternalStuff { slot, freshContainers }) =
            self.internal

        ( get, set ) =
            slot

        convertedGet ownerContainers =
            case get ownerContainers of
                EmptyContainer ->
                    EmptyContainer

                StateContainer state ->
                    getPart state.partStates

                SignalContainer (LocalMsg _) ->
                    EmptyContainer

                SignalContainer (PartMsg _ containers) ->
                    getPart containers

        convertedSet partContainer ownerContainers =
            case get ownerContainers of
                EmptyContainer ->
                    case partContainer of
                        EmptyContainer ->
                            ownerContainers

                        StateContainer _ ->
                            -- We don't have current component's local state
                            -- so we can't do anything here. This situation
                            -- mustn't occur in practice anyway.
                            ownerContainers

                        SignalContainer _ ->
                            set (wrapSignal partContainer) ownerContainers

                StateContainer state ->
                    let
                        updatedPartStates =
                            setPart partContainer state.partStates

                        updatedState =
                            { state | partStates = updatedPartStates }
                    in
                    set (StateContainer updatedState) ownerContainers

                SignalContainer _ ->
                    set (wrapSignal partContainer) ownerContainers

        wrapSignal partContainer =
            freshContainers
                |> setPart partContainer
                |> PartMsg (identify partSlot)
                |> SignalContainer
    in
    ( convertedGet, convertedSet )


dummyChange : CommonArgs a m p -> Change m p
dummyChange args =
    { component = dummyComponent
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , componentLocations = args.componentLocations
    , lastComponentId = args.lastComponentId
    , cleanup = identity
    }


dummyComponent : ComponentInterface m p
dummyComponent =
    ComponentInterface
        { update = dummyChange
        , destroy = identity
        , subscriptions = \_ -> Sub.none
        , view = \_ -> Html.Styled.text ""
        }
