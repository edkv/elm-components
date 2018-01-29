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
import Dict exposing (Dict)
import Html.Styled
import Html.Styled.Attributes
import Html.Styled.Keyed
import Svg.Styled.Attributes
import VirtualDom


type alias Spec v w c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node v w pC pM
    , children : c
    }


type alias SpecWithOptions v w c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node v w pC pM
    , children : c
    , options : Options m
    }


type alias Self c m s pC =
    { id : String
    , internal : InternalStuff c m s pC
    }


type InternalStuff c m s pC
    = InternalStuff
        { slot : Slot (Container c m s) pC
        , freshContainers : c
        , freshParentContainers : pC
        }


type alias Options m =
    { onContextUpdate : Maybe m
    }


type alias CommonArgs a c m =
    { a
        | states : c
        , cache : Cache c m
        , freshContainers : c
        , lastComponentId : ComponentId
        , namespace : String
    }


baseComponent : Spec v w c m s pC pM -> Component v w (Container c m s) pC pM
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
    SpecWithOptions v w c m s pC pM
    -> Component v w (Container c m s) pC pM
baseComponentWithOptions spec =
    Component <|
        \slot ->
            ComponentNode <|
                buildComponent spec slot Sub.none (Text "")


identify : Slot (Container c m s) pC -> { states : pC } -> Maybe ComponentId
identify ( get, _ ) args =
    case get args.states of
        StateContainer state ->
            Just state.id

        _ ->
            Nothing


touch :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> Sub (Signal pC pM)
    -> Node v w pC pM
    -> TouchArgs pC pM
    -> Change pC pM
touch spec (( get, _ ) as slot) localSub tree args =
    case get args.states of
        EmptyContainer ->
            init spec slot args

        StateContainer state ->
            case spec.options.onContextUpdate of
                Just msg ->
                    doLocalUpdate spec slot args state msg

                Nothing ->
                    rebuild spec slot args state

        _ ->
            { component = buildComponent spec slot localSub tree
            , states = args.states
            , cache = args.cache
            , cmd = Cmd.none
            , signals = []
            , lastComponentId = args.lastComponentId
            }


init :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> TouchArgs pC pM
    -> Change pC pM
init spec (( _, set ) as slot) args =
    let
        id =
            args.lastComponentId + 1

        self =
            getSelf spec slot id args

        ( localState, nonmappedLocalCmd, localSignals ) =
            spec.init self

        localCmd =
            nonmappedLocalCmd
                |> Cmd.map (wrapLocalMsg set args.freshContainers)

        localSub =
            spec.subscriptions self localState
                |> Sub.map (wrapLocalMsg set args.freshContainers)

        tree =
            spec.view self localState

        state =
            { id = id
            , localState = localState
            , childStates = spec.children
            , cache = Dict.empty
            }

        updatedStates =
            set (StateContainer state) args.states

        treeTouchResult =
            touchTree
                { args
                    | states = updatedStates
                    , lastComponentId = id
                }
                id
                tree
    in
    { component = buildComponent spec slot localSub tree
    , states = treeTouchResult.states
    , cache = treeTouchResult.cache
    , cmd = Cmd.batch [ localCmd, treeTouchResult.cmd ]
    , signals = localSignals ++ treeTouchResult.signals
    , lastComponentId = treeTouchResult.lastComponentId
    }


rebuild :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> TouchArgs pC pM
    -> ComponentState c m s
    -> Change pC pM
rebuild spec (( get, set ) as slot) args state =
    let
        self =
            getSelf spec slot state.id args

        localSub =
            spec.subscriptions self state.localState
                |> Sub.map (wrapLocalMsg set args.freshContainers)

        tree =
            spec.view self state.localState
    in
    { component = buildComponent spec slot localSub tree
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , lastComponentId = args.lastComponentId
    }


update :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> Sub (Signal pC pM)
    -> Node v w pC pM
    -> UpdateArgs pC pM
    -> Maybe (Change pC pM)
update spec (( get, _ ) as slot) localSub tree args =
    case get args.states of
        StateContainer state ->
            case get args.signalContainers of
                EmptyContainer ->
                    maybeUpdateChild spec slot localSub tree args state

                SignalContainer signal ->
                    case signal of
                        LocalMsg msg ->
                            Just (doLocalUpdate spec slot args state msg)

                        ChildMsg _ ->
                            maybeUpdateChild spec slot localSub tree args state

                _ ->
                    Nothing

        _ ->
            Nothing


doLocalUpdate :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> CommonArgs a pC pM
    -> ComponentState c m s
    -> m
    -> Change pC pM
doLocalUpdate spec (( _, set ) as slot) args state msg =
    let
        self =
            getSelf spec slot state.id args

        ( updatedLocalState, nonmappedLocalCmd, localSignals ) =
            spec.update self msg state.localState

        localCmd =
            nonmappedLocalCmd
                |> Cmd.map (wrapLocalMsg set args.freshContainers)

        localSub =
            spec.subscriptions self updatedLocalState
                |> Sub.map (wrapLocalMsg set args.freshContainers)

        tree =
            spec.view self updatedLocalState

        updatedState =
            { state | localState = updatedLocalState }

        updatedStates =
            set (StateContainer updatedState) args.states

        treeTouchResult =
            touchTree { args | states = updatedStates } state.id tree
    in
    { component = buildComponent spec slot localSub tree
    , states = treeTouchResult.states
    , cache = treeTouchResult.cache
    , cmd = Cmd.batch [ localCmd, treeTouchResult.cmd ]
    , signals = localSignals ++ treeTouchResult.signals
    , lastComponentId = treeTouchResult.lastComponentId
    }


maybeUpdateChild :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> Sub (Signal pC pM)
    -> Node v w pC pM
    -> UpdateArgs pC pM
    -> ComponentState c m s
    -> Maybe (Change pC pM)
maybeUpdateChild spec (( _, set ) as slot) localSub tree args state =
    let
        renderedComponents =
            Dict.get state.id args.cache
                |> Maybe.withDefault Dict.empty
                |> Dict.toList

        findAndUpdate components =
            case components of
                ( id, RenderedComponent component ) :: otherComponents ->
                    case component.update args of
                        Just change ->
                            let
                                updatedRenderedComponents =
                                    Dict.get state.id change.cache
                                        |> Maybe.withDefault Dict.empty
                                        |> Dict.insert id change.component

                                updatedCache =
                                    Dict.insert
                                        state.id
                                        updatedRenderedComponents
                                        change.cache

                                component =
                                    buildComponent spec slot localSub tree
                            in
                            Just
                                { component = component
                                , states = change.states
                                , cache = updatedCache
                                , cmd = change.cmd
                                , signals = change.signals
                                , lastComponentId = change.lastComponentId
                                }

                        Nothing ->
                            findAndUpdate otherComponents

                [] ->
                    Nothing
    in
    findAndUpdate renderedComponents


touchTree :
    CommonArgs a pC pM
    -> ComponentId
    -> Node v w pC pM
    ->
        { states : pC
        , cache : Cache pC pM
        , cmd : Cmd (Signal pC pM)
        , signals : List (Signal pC pM)
        , lastComponentId : ComponentId
        }
touchTree args id tree =
    let
        result =
            List.foldl touchComponent initialData renderedComponents

        renderedComponents =
            collectRenderedComponents tree []

        initialData =
            { idComponentPairs = []
            , states = args.states
            , cache = args.cache
            , cmd = Cmd.none
            , signals = []
            , lastComponentId = args.lastComponentId
            }

        touchComponent (RenderedComponent component) acc =
            let
                change =
                    component.touch
                        { states = acc.states
                        , cache = acc.cache
                        , lastComponentId = acc.lastComponentId
                        , freshContainers = args.freshContainers
                        , namespace = args.namespace
                        }

                (RenderedComponent changedComponent) =
                    change.component

                updatedPairs =
                    case changedComponent.identify { states = change.states } of
                        Just id ->
                            ( id, change.component ) :: acc.idComponentPairs

                        Nothing ->
                            -- It should never be Nothing after a touch.
                            acc.idComponentPairs
            in
            { idComponentPairs = updatedPairs
            , states = change.states
            , cache = change.cache
            , cmd = Cmd.batch [ acc.cmd, change.cmd ]
            , signals = acc.signals ++ change.signals
            , lastComponentId = change.lastComponentId
            }

        updatedRenderedComponents =
            Dict.fromList result.idComponentPairs
    in
    { states = result.states
    , cache = Dict.insert id updatedRenderedComponents result.cache
    , cmd = result.cmd
    , signals = result.signals
    , lastComponentId = result.lastComponentId
    }


collectRenderedComponents :
    Node v w c m
    -> List (RenderedComponent c m)
    -> List (RenderedComponent c m)
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


buildComponent :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> Sub (Signal pC pM)
    -> Node v w pC pM
    -> RenderedComponent pC pM
buildComponent spec slot localSub tree =
    RenderedComponent
        { identify = identify slot
        , touch = touch spec slot localSub tree
        , update = update spec slot localSub tree
        , subscriptions = subscriptions slot localSub
        , view = view slot tree
        }


subscriptions :
    Slot (Container c m s) pC
    -> Sub (Signal pC pM)
    -> SubscriptionsArgs pC pM
    -> Sub (Signal pC pM)
subscriptions (( get, set ) as slot) localSub args =
    case get args.states of
        StateContainer state ->
            let
                renderedComponents =
                    Dict.get state.id args.cache
                        |> Maybe.withDefault Dict.empty
            in
            Dict.foldl
                (\_ (RenderedComponent component) acc ->
                    Sub.batch
                        [ acc
                        , component.subscriptions args
                        ]
                )
                localSub
                renderedComponents

        _ ->
            Sub.none


view :
    Slot (Container c m s) pC
    -> Node v w pC pM
    -> ViewArgs pC pM
    -> Html.Styled.Html (Signal pC pM)
view (( get, _ ) as slot) tree args =
    case get args.states of
        StateContainer state ->
            let
                renderedComponents =
                    Dict.get state.id args.cache
                        |> Maybe.withDefault Dict.empty
            in
            toStyledHtml args renderedComponents tree

        _ ->
            Html.Styled.text ""


toStyledHtml :
    ViewArgs pC pM
    -> Dict ComponentId (RenderedComponent pC pM)
    -> Node v w pC pM
    -> Html.Styled.Html (Signal pC pM)
toStyledHtml args cache node =
    case node of
        SimpleElement { tag, attributes, children } ->
            Html.Styled.node tag
                (List.map toStyledAttribute attributes)
                (List.map (toStyledHtml args cache) children)

        Embedding { tag, attributes, children } ->
            Html.Styled.node tag
                (List.map toStyledAttribute attributes)
                (List.map (toStyledHtml args cache) children)

        ReversedEmbedding { tag, attributes, children } ->
            Html.Styled.node tag
                (List.map toStyledAttribute attributes)
                (List.map (toStyledHtml args cache) children)

        KeyedSimpleElement { tag, attributes, children } ->
            Html.Styled.Keyed.node tag
                (List.map toStyledAttribute attributes)
                (List.map (Tuple.mapSecond (toStyledHtml args cache)) children)

        KeyedEmbedding { tag, attributes, children } ->
            Html.Styled.Keyed.node tag
                (List.map toStyledAttribute attributes)
                (List.map (Tuple.mapSecond (toStyledHtml args cache)) children)

        KeyedReversedEmbedding { tag, attributes, children } ->
            Html.Styled.Keyed.node tag
                (List.map toStyledAttribute attributes)
                (List.map (Tuple.mapSecond (toStyledHtml args cache)) children)

        Text string ->
            Html.Styled.text string

        PlainNode node ->
            Html.Styled.fromUnstyled node

        ComponentNode (RenderedComponent component) ->
            component.identify { states = args.states }
                |> Maybe.andThen (\id -> Dict.get id cache)
                |> Maybe.andThen (\(RenderedComponent c) -> Just (c.view args))
                |> Maybe.withDefault (Html.Styled.text "")


toStyledAttribute : Attribute v c m -> Html.Styled.Attribute (Signal c m)
toStyledAttribute attribute =
    case attribute of
        PlainAttribute property ->
            Html.Styled.Attributes.fromUnstyled property

        Styles ClassNameProperty styles ->
            Html.Styled.Attributes.css styles

        Styles ClassAttribute styles ->
            Svg.Styled.Attributes.css styles


getSelf :
    SpecWithOptions v w c m s pC pM
    -> Slot (Container c m s) pC
    -> ComponentId
    -> { a | freshContainers : pC, namespace : String }
    -> Self c m s pC
getSelf spec slot id { namespace, freshContainers } =
    { id = "_" ++ namespace ++ "_" ++ toString id
    , internal =
        InternalStuff
            { slot = slot
            , freshContainers = spec.children
            , freshParentContainers = freshContainers
            }
    }


wrapSignal : Self c m s pC -> Signal c m -> Signal pC pM
wrapSignal self =
    let
        (InternalStuff { slot, freshParentContainers }) =
            self.internal

        ( _, set ) =
            slot
    in
    toParentSignal set freshParentContainers


wrapAttribute : Self c m s pC -> Attribute v c m -> Attribute v pC pM
wrapAttribute self attribute =
    case attribute of
        PlainAttribute property ->
            property
                |> VirtualDom.mapProperty (wrapSignal self)
                |> PlainAttribute

        Styles strategy styles ->
            Styles strategy styles


wrapNode : Self c m s pC -> Node v w c m -> Node v w pC pM
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

        ComponentNode renderedComponent ->
            wrapRenderedComponent self renderedComponent
                |> ComponentNode


wrapRenderedComponent :
    Self c m s pC
    -> RenderedComponent c m
    -> RenderedComponent pC pM
wrapRenderedComponent self component =
    RenderedComponent <|
        { identify = wrapIdentify self component
        , touch = wrapTouch self component
        , update = wrapUpdate self component
        , subscriptions = wrapSubscriptions self component
        , view = wrapView self component
        }


wrapIdentify :
    Self c m s pC
    -> RenderedComponent c m
    -> { states : pC }
    -> Maybe ComponentId
wrapIdentify self (RenderedComponent component) args =
    let
        (InternalStuff { slot }) =
            self.internal

        ( get, _ ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            component.identify { states = state.childStates }

        _ ->
            Nothing


wrapTouch :
    Self c m s pC
    -> RenderedComponent c m
    -> TouchArgs pC pM
    -> Change pC pM
wrapTouch self (RenderedComponent component) args =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            let
                change =
                    component.touch
                        { states = state.childStates
                        , cache = state.cache
                        , freshContainers = freshContainers
                        , lastComponentId = args.lastComponentId
                        , namespace = args.namespace
                        }

                newComponent =
                    wrapRenderedComponent self change.component

                updatedState =
                    { state
                        | childStates = change.states
                        , cache = change.cache
                    }

                updatedStates =
                    set (StateContainer updatedState) args.states

                cmd =
                    Cmd.map
                        (toParentSignal set freshParentContainers)
                        change.cmd

                signals =
                    List.map
                        (toParentSignal set freshParentContainers)
                        change.signals
            in
            { component = newComponent
            , states = updatedStates
            , cache = args.cache
            , cmd = cmd
            , signals = signals
            , lastComponentId = change.lastComponentId
            }

        _ ->
            let
                sameComponent =
                    wrapRenderedComponent self (RenderedComponent component)
            in
            { component = sameComponent
            , states = args.states
            , cache = args.cache
            , cmd = Cmd.none
            , signals = []
            , lastComponentId = args.lastComponentId
            }


wrapUpdate :
    Self c m s pC
    -> RenderedComponent c m
    -> UpdateArgs pC pM
    -> Maybe (Change pC pM)
wrapUpdate self (RenderedComponent component) args =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case ( get args.states, get args.signalContainers ) of
        ( StateContainer state, SignalContainer (ChildMsg signalContainers) ) ->
            let
                maybeChange =
                    component.update
                        { states = state.childStates
                        , cache = state.cache
                        , signalContainers = signalContainers
                        , freshContainers = freshContainers
                        , lastComponentId = args.lastComponentId
                        , namespace = args.namespace
                        }
            in
            case maybeChange of
                Just change ->
                    let
                        newComponent =
                            wrapRenderedComponent self change.component

                        updatedState =
                            { state
                                | childStates = change.states
                                , cache = change.cache
                            }

                        updatedStates =
                            set (StateContainer updatedState) args.states

                        cmd =
                            Cmd.map
                                (toParentSignal set freshParentContainers)
                                change.cmd

                        signals =
                            List.map
                                (toParentSignal set freshParentContainers)
                                change.signals
                    in
                    Just
                        { component = newComponent
                        , states = updatedStates
                        , cache = args.cache
                        , cmd = cmd
                        , signals = signals
                        , lastComponentId = change.lastComponentId
                        }

                Nothing ->
                    Nothing

        ( _, _ ) ->
            Nothing


wrapSubscriptions :
    Self c m s pC
    -> RenderedComponent c m
    -> SubscriptionsArgs pC pM
    -> Sub (Signal pC pM)
wrapSubscriptions self (RenderedComponent component) args =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            component.subscriptions
                { states = state.childStates
                , cache = state.cache
                }
                |> Sub.map (toParentSignal set freshParentContainers)

        _ ->
            Sub.none


wrapView :
    Self c m s pC
    -> RenderedComponent c m
    -> ViewArgs pC pM
    -> Html.Styled.Html (Signal pC pM)
wrapView self (RenderedComponent component) args =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        StateContainer state ->
            component.view
                { states = state.childStates
                , cache = state.cache
                }
                |> Html.Styled.map (toParentSignal set freshParentContainers)

        _ ->
            Html.Styled.text ""


wrapSlot :
    Self c m s pC
    -> Slot (Container cC cM cS) c
    -> Slot (Container cC cM cS) pC
wrapSlot self ( getChild, setChild ) =
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

                SignalContainer (ChildMsg containers) ->
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
                |> ChildMsg
                |> SignalContainer
    in
    ( wrappedGet, wrappedSet )


sendToChild : Self c m s pC -> Slot (Container cC cM cS) c -> cM -> Signal pC pM
sendToChild self ( _, setChild ) childMsg =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( _, set ) =
            slot
    in
    childMsg
        |> LocalMsg
        |> toParentSignal setChild freshContainers
        |> toParentSignal set freshParentContainers


wrapLocalMsg : (Container c m s -> pC -> pC) -> pC -> m -> Signal pC pM
wrapLocalMsg set freshParentContainers msg =
    msg
        |> LocalMsg
        |> toParentSignal set freshParentContainers


toParentSignal :
    (Container c m s -> pC -> pC)
    -> pC
    -> Signal c m
    -> Signal pC pM
toParentSignal set freshParentContainers signal =
    freshParentContainers
        |> set (SignalContainer signal)
        |> ChildMsg


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
