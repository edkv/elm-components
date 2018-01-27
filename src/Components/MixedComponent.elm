module Components.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        , sendToChild
        , wrapAttribute
        , wrapNode
        , wrapSignal
        , wrapSlot
        )

import Components exposing (Attribute, Component, Container, Node, Signal, Slot)
import Components.Internal.Core as Core
    exposing
        ( Cache
        , Change
        , ComponentId
        , ComponentState
        , NewComponent(Changed, Same)
        , RenderedComponent(RenderedComponent)
        , StylingStrategy(ClassAttribute, ClassNameProperty)
        , SubscriptionsArgs
        , TouchArgs
        , UpdateArgs
        , ViewArgs
        )
import Dict exposing (Dict)
import Html.Styled
import Html.Styled.Attributes
import Html.Styled.Keyed
import Svg.Styled.Attributes
import VirtualDom


type alias Spec x y c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node x y pC pM
    , children : c
    }


type alias SpecWithOptions x y c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node x y pC pM
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


mixedComponent : Spec x y c m s pC pM -> Component x y (Container c m s) pC pM
mixedComponent spec =
    mixedComponentWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , children = spec.children
        , options = defaultOptions
        }


mixedComponentWithOptions :
    SpecWithOptions x y c m s pC pM
    -> Component x y (Container c m s) pC pM
mixedComponentWithOptions spec =
    Core.Component <|
        \slot ->
            Core.ComponentNode <|
                RenderedComponent
                    { getId = getId slot
                    , touch = touch spec slot
                    , update = update spec slot
                    , subscriptions = \_ -> Sub.none
                    , view = \_ -> Html.Styled.text ""
                    }


getId : Slot (Container c m s) pC -> { states : pC } -> Maybe ComponentId
getId ( get, _ ) args =
    case get args.states of
        Core.StateContainer state ->
            Just state.id

        _ ->
            Nothing


touch :
    SpecWithOptions x y c m s pC pM
    -> Slot (Container c m s) pC
    -> TouchArgs pC pM
    -> Maybe (Change pC pM)
touch spec (( get, _ ) as slot) args =
    case get args.states of
        Core.EmptyContainer ->
            Just (init spec slot args)

        Core.StateContainer state ->
            case spec.options.onContextUpdate of
                Just msg ->
                    Just (doLocalUpdate spec slot args state msg)

                Nothing ->
                    Just (rebuild spec slot args state)

        _ ->
            Nothing


init :
    SpecWithOptions x y c m s pC pM
    -> Slot (Container c m s) pC
    -> TouchArgs pC pM
    -> Change pC pM
init spec (( _, set ) as slot) args =
    let
        id =
            args.lastComponentId + 1

        self =
            getSelf spec slot id args

        ( localState, nonwrappedLocalCmd, localSignals ) =
            spec.init self

        localCmd =
            nonwrappedLocalCmd
                |> Cmd.map (wrapLocalMsg set args.freshContainers)

        localSub =
            spec.subscriptions self localState

        tree =
            spec.view self localState

        state =
            { id = id
            , localState = localState
            , childStates = spec.children
            , cache = Dict.empty
            }

        updatedStates =
            set (Core.StateContainer state) args.states

        treeTouchResult =
            touchTree
                { args
                    | states = updatedStates
                    , lastComponentId = id
                }
                id
                tree

        component =
            RenderedComponent
                { getId = getId slot
                , touch = touch spec slot
                , update = update spec slot
                , subscriptions = subscriptions slot localSub
                , view = view slot tree
                }
    in
    { component = Changed component
    , states = treeTouchResult.states
    , cache = treeTouchResult.cache
    , cmd = Cmd.batch [ localCmd, treeTouchResult.cmd ]
    , signals = localSignals ++ treeTouchResult.signals
    , lastComponentId = treeTouchResult.lastComponentId
    }


rebuild :
    SpecWithOptions x y c m s pC pM
    -> Slot (Container c m s) pC
    -> TouchArgs pC pM
    -> ComponentState c m s
    -> Change pC pM
rebuild spec slot args state =
    let
        self =
            getSelf spec slot state.id args

        localSub =
            spec.subscriptions self state.localState

        tree =
            spec.view self state.localState

        component =
            RenderedComponent
                { getId = getId slot
                , touch = touch spec slot
                , update = update spec slot
                , subscriptions = subscriptions slot localSub
                , view = view slot tree
                }
    in
    { component = Changed component
    , states = args.states
    , cache = args.cache
    , cmd = Cmd.none
    , signals = []
    , lastComponentId = args.lastComponentId
    }


update :
    SpecWithOptions x y c m s pC pM
    -> Slot (Container c m s) pC
    -> UpdateArgs pC pM
    -> Maybe (Change pC pM)
update spec (( get, _ ) as slot) args =
    case get args.states of
        Core.StateContainer state ->
            case get args.signal of
                Core.EmptyContainer ->
                    maybeUpdateChild spec slot args state

                Core.SignalContainer signal ->
                    case signal of
                        Core.LocalMsg msg ->
                            Just (doLocalUpdate spec slot args state msg)

                        Core.ChildMsg _ ->
                            maybeUpdateChild spec slot args state

                _ ->
                    Nothing

        _ ->
            Nothing


doLocalUpdate :
    SpecWithOptions x y c m s pC pM
    -> Slot (Container c m s) pC
    -> CommonArgs a pC pM
    -> ComponentState c m s
    -> m
    -> Change pC pM
doLocalUpdate spec (( _, set ) as slot) args state msg =
    let
        self =
            getSelf spec slot state.id args

        ( updatedLocalState, nonwrappedLocalCmd, localSignals ) =
            spec.update self msg state.localState

        localCmd =
            nonwrappedLocalCmd
                |> Cmd.map (wrapLocalMsg set args.freshContainers)

        localSub =
            spec.subscriptions self updatedLocalState

        tree =
            spec.view self updatedLocalState

        updatedState =
            { state | localState = updatedLocalState }

        updatedStates =
            set (Core.StateContainer updatedState) args.states

        treeTouchResult =
            touchTree { args | states = updatedStates } state.id tree

        component =
            RenderedComponent
                { getId = getId slot
                , touch = touch spec slot
                , update = update spec slot
                , subscriptions = subscriptions slot localSub
                , view = view slot tree
                }
    in
    { component = Changed component
    , states = treeTouchResult.states
    , cache = treeTouchResult.cache
    , cmd = Cmd.batch [ localCmd, treeTouchResult.cmd ]
    , signals = localSignals ++ treeTouchResult.signals
    , lastComponentId = treeTouchResult.lastComponentId
    }


maybeUpdateChild :
    SpecWithOptions x y c m s pC pM
    -> Slot (Container c m s) pC
    -> UpdateArgs pC pM
    -> ComponentState c m s
    -> Maybe (Change pC pM)
maybeUpdateChild spec (( _, set ) as slot) args state =
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
                                newComponent =
                                    case change.component of
                                        Same ->
                                            RenderedComponent component

                                        Changed changedComponent ->
                                            changedComponent

                                updatedRenderedComponents =
                                    Dict.get state.id change.cache
                                        |> Maybe.withDefault Dict.empty
                                        |> Dict.insert id newComponent

                                updatedCache =
                                    Dict.insert
                                        state.id
                                        updatedRenderedComponents
                                        change.cache
                            in
                            Just
                                { component = Same
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
    -> Node x y pC pM
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
                maybeChange =
                    component.touch
                        { states = acc.states
                        , cache = acc.cache
                        , lastComponentId = acc.lastComponentId
                        , freshContainers = args.freshContainers
                        , namespace = args.namespace
                        }
            in
            case maybeChange of
                Just change ->
                    let
                        newComponent =
                            case change.component of
                                Same ->
                                    RenderedComponent component

                                Changed changedComponent ->
                                    changedComponent

                        (RenderedComponent destructuredNewComponent) =
                            newComponent

                        maybeId =
                            destructuredNewComponent.getId
                                { states = change.states
                                }

                        updatedPairs =
                            case maybeId of
                                Just id ->
                                    ( id, newComponent ) :: acc.idComponentPairs

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

                Nothing ->
                    acc

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
    Node x y c m
    -> List (RenderedComponent c m)
    -> List (RenderedComponent c m)
collectRenderedComponents node acc =
    case node of
        Core.SimpleElement { children } ->
            List.foldl collectRenderedComponents acc children

        Core.Embedding { children } ->
            List.foldl collectRenderedComponents acc children

        Core.ReversedEmbedding { children } ->
            List.foldl collectRenderedComponents acc children

        Core.KeyedSimpleElement { children } ->
            List.foldl (Tuple.second >> collectRenderedComponents) acc children

        Core.KeyedEmbedding { children } ->
            List.foldl (Tuple.second >> collectRenderedComponents) acc children

        Core.KeyedReversedEmbedding { children } ->
            List.foldl (Tuple.second >> collectRenderedComponents) acc children

        Core.Text _ ->
            acc

        Core.PlainNode _ ->
            acc

        Core.ComponentNode component ->
            component :: acc


subscriptions :
    Slot (Container c m s) pC
    -> Sub m
    -> SubscriptionsArgs pC pM
    -> Sub (Signal pC pM)
subscriptions (( get, set ) as slot) localSub args =
    case get args.states of
        Core.StateContainer state ->
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
                (Sub.map (wrapLocalMsg set args.freshContainers) localSub)
                renderedComponents

        _ ->
            Sub.none


view :
    Slot (Container c m s) pC
    -> Node x y pC pM
    -> ViewArgs pC pM
    -> Html.Styled.Html (Signal pC pM)
view (( get, _ ) as slot) tree args =
    case get args.states of
        Core.StateContainer state ->
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
    -> Node x y pC pM
    -> Html.Styled.Html (Signal pC pM)
toStyledHtml args cache node =
    case node of
        Core.SimpleElement { tag, attributes, children } ->
            Html.Styled.node tag
                (List.map toStyledAttribute attributes)
                (List.map (toStyledHtml args cache) children)

        Core.Embedding { tag, attributes, children } ->
            Html.Styled.node tag
                (List.map toStyledAttribute attributes)
                (List.map (toStyledHtml args cache) children)

        Core.ReversedEmbedding { tag, attributes, children } ->
            Html.Styled.node tag
                (List.map toStyledAttribute attributes)
                (List.map (toStyledHtml args cache) children)

        Core.KeyedSimpleElement { tag, attributes, children } ->
            Html.Styled.Keyed.node tag
                (List.map toStyledAttribute attributes)
                (List.map (Tuple.mapSecond (toStyledHtml args cache)) children)

        Core.KeyedEmbedding { tag, attributes, children } ->
            Html.Styled.Keyed.node tag
                (List.map toStyledAttribute attributes)
                (List.map (Tuple.mapSecond (toStyledHtml args cache)) children)

        Core.KeyedReversedEmbedding { tag, attributes, children } ->
            Html.Styled.Keyed.node tag
                (List.map toStyledAttribute attributes)
                (List.map (Tuple.mapSecond (toStyledHtml args cache)) children)

        Core.Text string ->
            Html.Styled.text string

        Core.PlainNode node ->
            Html.Styled.fromUnstyled node

        Core.ComponentNode (RenderedComponent component) ->
            component.getId { states = args.states }
                |> Maybe.andThen (\id -> Dict.get id cache)
                |> Maybe.andThen (\(RenderedComponent c) -> Just (c.view args))
                |> Maybe.withDefault (Html.Styled.text "")


toStyledAttribute : Attribute x c m -> Html.Styled.Attribute (Signal c m)
toStyledAttribute attribute =
    case attribute of
        Core.PlainAttribute property ->
            Html.Styled.Attributes.fromUnstyled property

        Core.Styles ClassNameProperty styles ->
            Html.Styled.Attributes.css styles

        Core.Styles ClassAttribute styles ->
            Svg.Styled.Attributes.css styles


getSelf :
    SpecWithOptions x y c m s pC pM
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


wrapAttribute : Self c m s pC -> Attribute x c m -> Attribute x pC pM
wrapAttribute self attribute =
    case attribute of
        Core.PlainAttribute property ->
            property
                |> VirtualDom.mapProperty (wrapSignal self)
                |> Core.PlainAttribute

        Core.Styles strategy styles ->
            Core.Styles strategy styles


wrapNode : Self c m s pC -> Node x y c m -> Node x y pC pM
wrapNode self node =
    case node of
        Core.SimpleElement { tag, attributes, children } ->
            Core.SimpleElement
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (wrapNode self) children
                }

        Core.Embedding { tag, attributes, children } ->
            Core.Embedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (wrapNode self) children
                }

        Core.ReversedEmbedding { tag, attributes, children } ->
            Core.ReversedEmbedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (wrapNode self) children
                }

        Core.KeyedSimpleElement { tag, attributes, children } ->
            Core.KeyedSimpleElement
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (Tuple.mapSecond (wrapNode self)) children
                }

        Core.KeyedEmbedding { tag, attributes, children } ->
            Core.KeyedEmbedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (Tuple.mapSecond (wrapNode self)) children
                }

        Core.KeyedReversedEmbedding { tag, attributes, children } ->
            Core.KeyedReversedEmbedding
                { tag = tag
                , attributes = List.map (wrapAttribute self) attributes
                , children = List.map (Tuple.mapSecond (wrapNode self)) children
                }

        Core.Text string ->
            Core.Text string

        Core.PlainNode node ->
            Core.PlainNode (VirtualDom.map (wrapSignal self) node)

        Core.ComponentNode renderedComponent ->
            wrapRenderedComponent self renderedComponent
                |> Core.ComponentNode


wrapRenderedComponent :
    Self c m s pC
    -> RenderedComponent c m
    -> RenderedComponent pC pM
wrapRenderedComponent self component =
    RenderedComponent <|
        { getId = wrapGetId self component
        , touch = wrapTouch self component
        , update = wrapUpdate self component
        , subscriptions = wrapSubscriptions self component
        , view = wrapView self component
        }


wrapGetId :
    Self c m s pC
    -> RenderedComponent c m
    -> { states : pC }
    -> Maybe ComponentId
wrapGetId self (RenderedComponent component) args =
    let
        (InternalStuff { slot }) =
            self.internal

        ( get, _ ) =
            slot
    in
    case get args.states of
        Core.StateContainer state ->
            component.getId { states = state.childStates }

        _ ->
            Nothing


wrapTouch :
    Self c m s pC
    -> RenderedComponent c m
    -> TouchArgs pC pM
    -> Maybe (Change pC pM)
wrapTouch self (RenderedComponent component) args =
    let
        (InternalStuff { slot, freshContainers, freshParentContainers }) =
            self.internal

        ( get, set ) =
            slot
    in
    case get args.states of
        Core.StateContainer state ->
            let
                maybeChange =
                    component.touch
                        { states = state.childStates
                        , cache = state.cache
                        , freshContainers = freshContainers
                        , lastComponentId = args.lastComponentId
                        , namespace = args.namespace
                        }
            in
            case maybeChange of
                Just change ->
                    let
                        updatedState =
                            { state
                                | childStates = change.states
                                , cache = change.cache
                            }

                        updatedStates =
                            set
                                (Core.StateContainer updatedState)
                                args.states

                        newComponent =
                            case change.component of
                                Same ->
                                    Same

                                Changed changedComponent ->
                                    wrapRenderedComponent self changedComponent
                                        |> Changed

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

        _ ->
            Nothing


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
    case get args.states of
        Core.StateContainer state ->
            let
                signal =
                    case get args.signal of
                        Core.SignalContainer (Core.ChildMsg containers) ->
                            containers

                        _ ->
                            freshContainers

                maybeChange =
                    component.update
                        { states = state.childStates
                        , cache = state.cache
                        , signal = signal
                        , freshContainers = freshContainers
                        , lastComponentId = args.lastComponentId
                        , namespace = args.namespace
                        }
            in
            case maybeChange of
                Just change ->
                    let
                        updatedState =
                            { state
                                | childStates = change.states
                                , cache = change.cache
                            }

                        updatedStates =
                            set
                                (Core.StateContainer updatedState)
                                args.states

                        newComponent =
                            case change.component of
                                Same ->
                                    Same

                                Changed changedComponent ->
                                    wrapRenderedComponent self changedComponent
                                        |> Changed

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

        _ ->
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
        Core.StateContainer state ->
            component.subscriptions
                { states = state.childStates
                , cache = state.cache
                , freshContainers = freshContainers
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
        Core.StateContainer state ->
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
                Core.EmptyContainer ->
                    Core.EmptyContainer

                Core.StateContainer state ->
                    getChild state.childStates

                Core.SignalContainer (Core.LocalMsg _) ->
                    Core.EmptyContainer

                Core.SignalContainer (Core.ChildMsg containers) ->
                    getChild containers

        wrappedSet childContainer parentContainers =
            case get parentContainers of
                Core.EmptyContainer ->
                    case childContainer of
                        Core.EmptyContainer ->
                            parentContainers

                        Core.StateContainer _ ->
                            -- We don't have current component's local state
                            -- so we can't do anything here. This situation
                            -- mustn't occur in practice anyway.
                            parentContainers

                        Core.SignalContainer _ ->
                            set (wrapSignal childContainer) parentContainers

                Core.StateContainer state ->
                    let
                        updatedChildStates =
                            setChild childContainer state.childStates

                        updatedState =
                            { state | childStates = updatedChildStates }
                    in
                    set (Core.StateContainer updatedState) parentContainers

                Core.SignalContainer _ ->
                    set (wrapSignal childContainer) parentContainers

        wrapSignal childContainer =
            freshContainers
                |> setChild childContainer
                |> Core.ChildMsg
                |> Core.SignalContainer
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
        |> Core.LocalMsg
        |> toParentSignal setChild freshContainers
        |> toParentSignal set freshParentContainers


wrapLocalMsg : (Container c m s -> pC -> pC) -> pC -> m -> Signal pC pM
wrapLocalMsg set freshParentContainers msg =
    msg
        |> Core.LocalMsg
        |> toParentSignal set freshParentContainers


toParentSignal :
    (Container c m s -> pC -> pC)
    -> pC
    -> Signal c m
    -> Signal pC pM
toParentSignal set freshParentContainers signal =
    freshParentContainers
        |> set (Core.SignalContainer signal)
        |> Core.ChildMsg


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
