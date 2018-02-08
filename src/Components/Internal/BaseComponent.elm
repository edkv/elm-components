module Components.Internal.BaseComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , baseComponent
        , baseComponentWithOptions
        , defaultOptions
        , sendToChild
        , wrapAttribute
        , wrapNode
        , wrapSignal
        , wrapSlot
        )

import Components.Internal.Core exposing (..)
import Components.Internal.Shared exposing (identify, toParentSignal)
import Dict exposing (Dict)
import Html.Styled
import Html.Styled.Attributes
import Html.Styled.Keyed
import Svg.Styled.Attributes
import VirtualDom


type alias Spec v w s m c pM pC =
    { init : Self s m c pC -> ( s, Cmd m, List (Signal pM pC) )
    , update : Self s m c pC -> m -> s -> ( s, Cmd m, List (Signal pM pC) )
    , subscriptions : Self s m c pC -> s -> Sub m
    , view : Self s m c pC -> s -> Node v w pM pC
    , children : c
    }


type alias SpecWithOptions v w s m c pM pC =
    { init : Self s m c pC -> ( s, Cmd m, List (Signal pM pC) )
    , update : Self s m c pC -> m -> s -> ( s, Cmd m, List (Signal pM pC) )
    , subscriptions : Self s m c pC -> s -> Sub m
    , view : Self s m c pC -> s -> Node v w pM pC
    , children : c
    , options : Options m
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


type alias Options m =
    { onContextUpdate : Maybe m
    }


type alias Hidden v w s m c pM pC =
    { spec : SpecWithOptions v w s m c pM pC
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
    baseComponentWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , children = spec.children
        , options = defaultOptions
        }


baseComponentWithOptions :
    SpecWithOptions v w s m c pM pC
    -> Component v w (Container s m c) pM pC
baseComponentWithOptions spec =
    Component <|
        \slot ->
            ComponentNode (touch spec slot)


touch :
    SpecWithOptions v w s m c pM pC
    -> Slot (Container s m c) pC
    -> Touch pM pC
touch spec (( get, _ ) as slot) args =
    case get args.states of
        StateContainer state ->
            case spec.options.onContextUpdate of
                Just msg ->
                    ( state.id
                    , doLocalUpdate spec slot state msg args
                    )

                Nothing ->
                    rebuild spec slot state args

        _ ->
            init spec slot args


init :
    SpecWithOptions v w s m c pM pC
    -> Slot (Container s m c) pC
    -> Touch pM pC
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
    , change spec slot state cmd sub signals tree updatedArgs
    )


rebuild :
    SpecWithOptions v w s m c pM pC
    -> Slot (Container s m c) pC
    -> ComponentState s m c
    -> Touch pM pC
rebuild spec slot state args =
    let
        self =
            getSelf spec slot state.id args

        sub =
            spec.subscriptions self state.localState

        tree =
            spec.view self state.localState
    in
    ( state.id
    , change spec slot state Cmd.none sub [] tree args
    )


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

        _ ->
            noUpdate hidden args


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


doLocalUpdate :
    SpecWithOptions v w s m c pM pC
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
    change spec slot updatedState cmd sub signals tree args


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


change :
    SpecWithOptions v w s m c pM pC
    -> Slot (Container s m c) pC
    -> ComponentState s m c
    -> Cmd m
    -> Sub m
    -> List (Signal pM pC)
    -> Node v w pM pC
    -> CommonArgs a pM pC
    -> Change pM pC
change spec (( _, set ) as slot) state cmd sub signals tree args =
    let
        updatedStates =
            set (StateContainer state) args.states

        mappedLocalCmd =
            Cmd.map (wrapLocalMsg slot args.freshContainers) cmd

        mappedLocalSub =
            Sub.map (wrapLocalMsg slot args.freshContainers) sub

        touchFunctions =
            collectTouchFunctions tree []

        touchInitialData =
            { components = []
            , orderedComponentIds = []
            , states = updatedStates
            , cache = args.cache
            , cmd = mappedLocalCmd
            , signals = signals
            , componentLocations = args.componentLocations
            , lastComponentId = args.lastComponentId
            }

        touchComponent touchFunction acc =
            let
                ( id, change ) =
                    touchFunction
                        { states = acc.states
                        , cache = acc.cache
                        , componentLocations = acc.componentLocations
                        , lastComponentId = acc.lastComponentId
                        , freshContainers = args.freshContainers
                        , namespace = args.namespace
                        }

                newComponentLocations =
                    Dict.insert id state.id change.componentLocations
            in
            { components = ( id, change.component ) :: acc.components
            , orderedComponentIds = id :: acc.orderedComponentIds
            , states = change.states
            , cache = change.cache
            , cmd = Cmd.batch [ acc.cmd, change.cmd ]
            , signals = acc.signals ++ change.signals
            , componentLocations = newComponentLocations
            , lastComponentId = change.lastComponentId
            }

        touchResults =
            List.foldr touchComponent touchInitialData touchFunctions

        renderedComponents =
            Dict.fromList touchResults.components

        component =
            buildComponent
                { spec = spec
                , slot = slot
                , sub = mappedLocalSub
                , tree = tree
                , components = renderedComponents
                , orderedComponentIds = touchResults.orderedComponentIds
                }

        updatedCache =
            Dict.insert state.id renderedComponents touchResults.cache
    in
    { component = component
    , states = touchResults.states
    , cache = updatedCache
    , cmd = touchResults.cmd
    , signals = touchResults.signals
    , componentLocations = touchResults.componentLocations
    , lastComponentId = touchResults.lastComponentId
    }


collectTouchFunctions : Node v w m c -> List (Touch m c) -> List (Touch m c)
collectTouchFunctions node acc =
    case node of
        SimpleElement { children } ->
            List.foldl collectTouchFunctions acc children

        Embedding { children } ->
            List.foldl collectTouchFunctions acc children

        ReversedEmbedding { children } ->
            List.foldl collectTouchFunctions acc children

        KeyedSimpleElement { children } ->
            List.foldl (Tuple.second >> collectTouchFunctions) acc children

        KeyedEmbedding { children } ->
            List.foldl (Tuple.second >> collectTouchFunctions) acc children

        KeyedReversedEmbedding { children } ->
            List.foldl (Tuple.second >> collectTouchFunctions) acc children

        Text _ ->
            acc

        PlainNode _ ->
            acc

        ComponentNode touchFunction ->
            touchFunction :: acc


buildComponent : Hidden v w s m c pM pC -> ComponentInterface pM pC
buildComponent hidden =
    ComponentInterface
        { update = update hidden
        , subscriptions = subscriptions hidden
        , view = view hidden
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
    render hidden.components hidden.orderedComponentIds hidden.tree
        |> Tuple.first


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
    SpecWithOptions v w s m c pM pC
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


wrapSignal : Self s m c pC -> Signal m c -> Signal pM pC
wrapSignal self =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    toParentSignal slot freshParentContainers


wrapAttribute : Self s m c pC -> Attribute v m c -> Attribute v pM pC
wrapAttribute self attribute =
    case attribute of
        PlainAttribute property ->
            property
                |> VirtualDom.mapProperty (wrapSignal self)
                |> PlainAttribute

        Styles strategy styles ->
            Styles strategy styles


wrapNode : Self s m c pC -> Node v w m c -> Node v w pM pC
wrapNode self node =
    case node of
        SimpleElement { tag, attributes, children } ->
            SimpleElement
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (wrapNode self) children
                }

        Embedding { tag, attributes, children } ->
            Embedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (wrapNode self) children
                }

        ReversedEmbedding { tag, attributes, children } ->
            ReversedEmbedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (wrapNode self) children
                }

        KeyedSimpleElement { tag, attributes, children } ->
            KeyedSimpleElement
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (Tuple.mapSecond (wrapNode self)) children
                }

        KeyedEmbedding { tag, attributes, children } ->
            KeyedEmbedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (Tuple.mapSecond (wrapNode self)) children
                }

        KeyedReversedEmbedding { tag, attributes, children } ->
            KeyedReversedEmbedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (Tuple.mapSecond (wrapNode self)) children
                }

        Text string ->
            Text string

        PlainNode node ->
            PlainNode (VirtualDom.map (wrapSignal self) node)

        ComponentNode touchFunction ->
            ComponentNode (wrapTouch self touchFunction)


wrapTouch : Self s m c pC -> Touch m c -> Touch pM pC
wrapTouch self touchFunction args =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            let
                ( id, change ) =
                    touchFunction
                        { states = state.childStates
                        , cache = state.cache
                        , freshContainers = freshContainers
                        , lastComponentId = args.lastComponentId
                        , componentLocations = args.componentLocations
                        , namespace = args.namespace
                        }

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
            ( id
            , { component = wrapComponent self change.component
              , states = set (StateContainer updatedState) args.states
              , cache = args.cache
              , cmd = cmd
              , signals = signals
              , componentLocations = change.componentLocations
              , lastComponentId = change.lastComponentId
              }
            )

        _ ->
            ( -1, dummyChange args )


wrapComponent :
    Self s m c pC
    -> ComponentInterface m c
    -> ComponentInterface pM pC
wrapComponent self component =
    ComponentInterface <|
        { update = wrapUpdate self component
        , subscriptions = wrapSubscriptions self component
        , view = wrapView self component
        }


wrapUpdate :
    Self s m c pC
    -> ComponentInterface m c
    -> UpdateArgs pM pC
    -> Change pM pC
wrapUpdate self (ComponentInterface component) args =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case ( get args.states, get args.signalContainers ) of
        ( StateContainer state, SignalContainer (ChildMsg _ signalContainers) ) ->
            let
                change =
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
            { component = wrapComponent self change.component
            , states = set (StateContainer updatedState) args.states
            , cache = args.cache
            , cmd = cmd
            , signals = signals
            , componentLocations = change.componentLocations
            , lastComponentId = change.lastComponentId
            }

        ( _, _ ) ->
            { component = wrapComponent self (ComponentInterface component)
            , states = args.states
            , cache = args.cache
            , cmd = Cmd.none
            , signals = []
            , componentLocations = args.componentLocations
            , lastComponentId = args.lastComponentId
            }


wrapSubscriptions :
    Self s m c pC
    -> ComponentInterface m c
    -> ()
    -> Sub (Signal pM pC)
wrapSubscriptions self (ComponentInterface component) () =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    component.subscriptions ()
        |> Sub.map (toParentSignal slot freshParentContainers)


wrapView :
    Self s m c pC
    -> ComponentInterface m c
    -> ()
    -> Html.Styled.Html (Signal pM pC)
wrapView self (ComponentInterface component) () =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal
    in
    component.view ()
        |> Html.Styled.map (toParentSignal slot freshParentContainers)


wrapSlot :
    Self s m c pC
    -> Slot (Container cS cM cC) c
    -> Slot (Container cS cM cC) pC
wrapSlot self (( getChild, setChild ) as childSlot) =
    let
        (InternalStuff { slot, freshContainers }) =
            self.internal

        ( get, set ) =
            slot

        wrappedGet parentContainers =
            case get parentContainers of
                EmptyContainer ->
                    EmptyContainer

                StateContainer state ->
                    getChild state.childStates

                SignalContainer (LocalMsg _) ->
                    EmptyContainer

                SignalContainer (ChildMsg _ containers) ->
                    getChild containers

        wrappedSet childContainer parentContainers =
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
    ( wrappedGet, wrappedSet )


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


wrapLocalMsg : Slot (Container s m c) pC -> pC -> m -> Signal pM pC
wrapLocalMsg slot freshParentContainers msg =
    msg
        |> LocalMsg
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


dummyComponent : ComponentInterface m a
dummyComponent =
    ComponentInterface
        { update = dummyChange
        , subscriptions = \_ -> Sub.none
        , view = \_ -> Html.Styled.text ""
        }


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
