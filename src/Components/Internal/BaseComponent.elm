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
        { get : pC -> Container c m s
        , set : Container c m s -> pC -> pC
        , freshContainers : c
        , freshParentContainers : pC
        }


type alias Options m =
    { onContextUpdate : Maybe m
    }


type alias Hidden v w c m s pC pM =
    { spec : SpecWithOptions v w c m s pC pM
    , get : pC -> Container c m s
    , set : Container c m s -> pC -> pC
    , renderedComponents : Dict ComponentId (RenderedComponent pC pM)
    , renderedComponentPositions : Dict Int ComponentId
    , localSub : Sub (Signal pC pM)
    , tree : Node v w pC pM
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
        \( get, set ) ->
            ComponentNode <|
                buildComponent
                    { spec = spec
                    , get = get
                    , set = set
                    , renderedComponents = Dict.empty
                    , renderedComponentPositions = Dict.empty
                    , localSub = Sub.none
                    , tree = Text ""
                    }


identify : Hidden v w c m s pC pM -> { states : pC } -> Maybe ComponentId
identify hidden args =
    case hidden.get args.states of
        StateContainer state ->
            Just state.id

        _ ->
            Nothing


touch : Hidden v w c m s pC pM -> TouchArgs pC pM -> Change pC pM
touch hidden args =
    case hidden.get args.states of
        StateContainer state ->
            case hidden.spec.options.onContextUpdate of
                Just msg ->
                    doLocalUpdate hidden args state msg

                Nothing ->
                    rebuild hidden args state

        _ ->
            init hidden args


init : Hidden v w c m s pC pM -> TouchArgs pC pM -> Change pC pM
init hidden args =
    let
        id =
            args.lastComponentId + 1

        self =
            getSelf hidden id args

        ( localState, cmd, signals ) =
            hidden.spec.init self

        sub =
            hidden.spec.subscriptions self localState

        tree =
            hidden.spec.view self localState

        state =
            { id = id
            , localState = localState
            , childStates = hidden.spec.children
            , cache = Dict.empty
            }

        updatedArgs =
            { args
                | states = hidden.set (StateContainer state) args.states
                , lastComponentId = id
            }
    in
    change hidden updatedArgs id cmd sub signals tree


rebuild :
    Hidden v w c m s pC pM
    -> TouchArgs pC pM
    -> ComponentState c m s
    -> Change pC pM
rebuild hidden args state =
    let
        self =
            getSelf hidden state.id args

        sub =
            hidden.spec.subscriptions self state.localState

        tree =
            hidden.spec.view self state.localState
    in
    change hidden args state.id Cmd.none sub [] tree


update : Hidden v w c m s pC pM -> UpdateArgs pC pM -> Maybe (Change pC pM)
update hidden args =
    case hidden.get args.states of
        StateContainer state ->
            case hidden.get args.signalContainers of
                EmptyContainer ->
                    maybeUpdateChild hidden args state

                SignalContainer (LocalMsg msg) ->
                    Just (doLocalUpdate hidden args state msg)

                SignalContainer (ChildMsg _) ->
                    maybeUpdateChild hidden args state

                _ ->
                    Nothing

        _ ->
            Nothing


doLocalUpdate :
    Hidden v w c m s pC pM
    -> CommonArgs a pC pM
    -> ComponentState c m s
    -> m
    -> Change pC pM
doLocalUpdate hidden args state msg =
    let
        self =
            getSelf hidden state.id args

        ( localState, cmd, signals ) =
            hidden.spec.update self msg state.localState

        sub =
            hidden.spec.subscriptions self localState

        tree =
            hidden.spec.view self localState

        updatedState =
            { state | localState = localState }

        updatedStates =
            hidden.set (StateContainer updatedState) args.states

        updatedArgs =
            { args | states = updatedStates }
    in
    change hidden updatedArgs state.id cmd sub signals tree


maybeUpdateChild :
    Hidden v w c m s pC pM
    -> UpdateArgs pC pM
    -> ComponentState c m s
    -> Maybe (Change pC pM)
maybeUpdateChild hidden args state =
    let
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
                                    buildComponent
                                        { hidden
                                            | renderedComponents =
                                                updatedRenderedComponents
                                        }
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
    findAndUpdate (Dict.toList hidden.renderedComponents)


change :
    Hidden v w c m s pC pM
    -> CommonArgs a pC pM
    -> ComponentId
    -> Cmd m
    -> Sub m
    -> List (Signal pC pM)
    -> Node v w pC pM
    -> Change pC pM
change hidden args thisId cmd sub signals tree =
    let
        mappedLocalCmd =
            Cmd.map (wrapLocalMsg hidden.set args.freshContainers) cmd

        mappedLocalSub =
            Sub.map (wrapLocalMsg hidden.set args.freshContainers) sub

        renderedComponents =
            collectRenderedComponents tree []

        treeTouchInitialData =
            { position = 0
            , idComponentPairs = []
            , positionIdPairs = []
            , states = args.states
            , cache = args.cache
            , cmd = mappedLocalCmd
            , signals = signals
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

                ( idComponentPairs, positionIdPairs ) =
                    case changedComponent.identify { states = change.states } of
                        Just id ->
                            ( ( id, change.component ) :: acc.idComponentPairs
                            , ( acc.position, id ) :: acc.positionIdPairs
                            )

                        Nothing ->
                            -- It should never be Nothing after a touch.
                            ( acc.idComponentPairs
                            , acc.positionIdPairs
                            )
            in
            { position = acc.position + 1
            , idComponentPairs = idComponentPairs
            , positionIdPairs = positionIdPairs
            , states = change.states
            , cache = change.cache
            , cmd = Cmd.batch [ acc.cmd, change.cmd ]
            , signals = acc.signals ++ change.signals
            , lastComponentId = change.lastComponentId
            }

        treeTouchResult =
            List.foldl touchComponent treeTouchInitialData renderedComponents

        touchedRenderedComponents =
            Dict.fromList treeTouchResult.idComponentPairs

        renderedComponentPositions =
            Dict.fromList treeTouchResult.positionIdPairs

        component =
            buildComponent
                { hidden
                    | renderedComponents = touchedRenderedComponents
                    , renderedComponentPositions = renderedComponentPositions
                    , localSub = mappedLocalSub
                    , tree = tree
                }

        cache =
            Dict.insert thisId touchedRenderedComponents treeTouchResult.cache
    in
    { component = component
    , states = treeTouchResult.states
    , cache = cache
    , cmd = treeTouchResult.cmd
    , signals = treeTouchResult.signals
    , lastComponentId = treeTouchResult.lastComponentId
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


buildComponent : Hidden v w c m s pC pM -> RenderedComponent pC pM
buildComponent hidden =
    RenderedComponent
        { identify = identify hidden
        , touch = touch hidden
        , update = update hidden
        , subscriptions = subscriptions hidden
        , view = view hidden
        }


subscriptions : Hidden v w c m s pC pM -> () -> Sub (Signal pC pM)
subscriptions hidden () =
    Dict.foldl
        (\_ (RenderedComponent component) acc ->
            Sub.batch
                [ acc
                , component.subscriptions ()
                ]
        )
        hidden.localSub
        hidden.renderedComponents


view : Hidden v w c m s pC pM -> () -> Html.Styled.Html (Signal pC pM)
view hidden () =
    render
        hidden.renderedComponents
        hidden.renderedComponentPositions
        0
        hidden.tree
        |> Tuple.first


render :
    Dict ComponentId (RenderedComponent c m)
    -> Dict Int ComponentId
    -> Int
    -> Node v w c m
    -> ( Html.Styled.Html (Signal c m), Int )
render components positionsMap position node =
    case node of
        SimpleElement element ->
            renderElement components positionsMap position element

        Embedding element ->
            renderElement components positionsMap position element

        ReversedEmbedding element ->
            renderElement components positionsMap position element

        KeyedSimpleElement element ->
            renderKeyedElement components positionsMap position element

        KeyedEmbedding element ->
            renderKeyedElement components positionsMap position element

        KeyedReversedEmbedding element ->
            renderKeyedElement components positionsMap position element

        Text string ->
            ( Html.Styled.text string
            , position
            )

        PlainNode node ->
            ( Html.Styled.fromUnstyled node
            , position
            )

        ComponentNode _ ->
            case Dict.get position positionsMap of
                Just id ->
                    case Dict.get id components of
                        Just (RenderedComponent component) ->
                            ( component.view ()
                            , position + 1
                            )

                        Nothing ->
                            ( Html.Styled.text ""
                            , position
                            )

                Nothing ->
                    ( Html.Styled.text ""
                    , position
                    )


renderElement :
    Dict ComponentId (RenderedComponent c m)
    -> Dict Int ComponentId
    -> Int
    -> Element x y z c m
    -> ( Html.Styled.Html (Signal c m), Int )
renderElement components positionsMap position element =
    let
        renderChild child ( renderedChildren, prevPosition ) =
            let
                ( renderedChild, nextPosition ) =
                    render components positionsMap prevPosition child
            in
            ( renderedChild :: renderedChildren
            , nextPosition
            )

        ( children, nextPosition ) =
            List.foldr renderChild ( [], position ) element.children

        attributes =
            List.map toStyledAttribute element.attributes

        renderedElement =
            Html.Styled.node element.tag attributes children
    in
    ( renderedElement, nextPosition )


renderKeyedElement :
    Dict ComponentId (RenderedComponent c m)
    -> Dict Int ComponentId
    -> Int
    -> KeyedElement x y z c m
    -> ( Html.Styled.Html (Signal c m), Int )
renderKeyedElement components positionsMap position element =
    let
        renderChild ( key, child ) ( renderedChildren, prevPosition ) =
            let
                ( renderedChild, nextPosition ) =
                    render components positionsMap prevPosition child
            in
            ( ( key, renderedChild ) :: renderedChildren
            , nextPosition
            )

        ( children, nextPosition ) =
            List.foldr renderChild ( [], position ) element.children

        attributes =
            List.map toStyledAttribute element.attributes

        renderedElement =
            Html.Styled.Keyed.node element.tag attributes children
    in
    ( renderedElement, nextPosition )


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
    Hidden v w c m s pC pM
    -> ComponentId
    -> { a | freshContainers : pC, namespace : String }
    -> Self c m s pC
getSelf hidden id { namespace, freshContainers } =
    { id = "_" ++ namespace ++ "_" ++ toString id
    , internal =
        InternalStuff
            { get = hidden.get
            , set = hidden.set
            , freshContainers = hidden.spec.children
            , freshParentContainers = freshContainers
            }
    }


wrapSignal : Self c m s pC -> Signal c m -> Signal pC pM
wrapSignal self =
    let
        (InternalStuff { set, freshParentContainers }) =
            self.internal
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
        (InternalStuff { get }) =
            self.internal
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
        (InternalStuff { get, set, freshContainers, freshParentContainers }) =
            self.internal
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
        (InternalStuff { get, set, freshContainers, freshParentContainers }) =
            self.internal
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
    -> ()
    -> Sub (Signal pC pM)
wrapSubscriptions self (RenderedComponent component) () =
    let
        (InternalStuff { set, freshParentContainers }) =
            self.internal
    in
    component.subscriptions ()
        |> Sub.map (toParentSignal set freshParentContainers)


wrapView :
    Self c m s pC
    -> RenderedComponent c m
    -> ()
    -> Html.Styled.Html (Signal pC pM)
wrapView self (RenderedComponent component) () =
    let
        (InternalStuff { set, freshParentContainers }) =
            self.internal
    in
    component.view ()
        |> Html.Styled.map (toParentSignal set freshParentContainers)


wrapSlot :
    Self c m s pC
    -> Slot (Container cC cM cS) c
    -> Slot (Container cC cM cS) pC
wrapSlot self ( getChild, setChild ) =
    let
        (InternalStuff { get, set, freshContainers }) =
            self.internal

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
        (InternalStuff { set, freshContainers, freshParentContainers }) =
            self.internal
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
