module Components.Internal.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        )

import Components.Internal.Core
    exposing
        ( Component(Component)
        , ComponentState
        , Container(EmptyContainer, SignalContainer, StateContainer)
        , Node(Node)
        , NodeCall
        , NodeMsg(HandleSignal, Touch)
        , Signal(ChildMsgSignal, LocalMsgSignal)
        , Slot
        )
import Html.Styled


type alias Spec c m s pC pM =
    { init : Self c m pC pM -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m pC pM -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m pC pM -> s -> Sub m
    , view : Self c m pC pM -> s -> Node pC pM
    , children : c
    }


type alias Self c m pC pM =
    { id : String
    , send : m -> Signal c m
    , wrapNode : Node c m -> Node pC pM
    , wrapSignal : Signal c m -> Signal pC pM
    }


type alias Options m =
    { onContextUpdate : Maybe m
    }


mixedComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
mixedComponent =
    mixedComponentWithOptions defaultOptions


mixedComponentWithOptions :
    Options m
    -> Spec c m s pC pM
    -> Component (Container c m s) pC pM
mixedComponentWithOptions options spec =
    Component <|
        \slot ->
            Node
                { call = call options spec slot
                }


call :
    Options m
    -> Spec c m s pC pM
    -> Slot (Container c m s) pC
    -> NodeCall pC pM
call options spec (( get, set ) as slot) args =
    case args.msg of
        Touch ->
            case get args.currentStates of
                EmptyContainer ->
                    init spec slot args

                StateContainer state ->
                    case options.onContextUpdate of
                        Just msg ->
                            update state msg spec slot args

                        Nothing ->
                            walkThrough state spec slot args

                bug ->
                    skipNode args

        HandleSignal signalContainers ->
            case ( get args.currentStates, get signalContainers ) of
                ( StateContainer state, EmptyContainer ) ->
                    walkThrough state spec slot args

                ( StateContainer state, SignalContainer (LocalMsgSignal signal) ) ->
                    if signal.componentId == state.id then
                        update state signal.msg spec slot args
                    else
                        walkThrough state spec slot args

                ( StateContainer state, SignalContainer (ChildMsgSignal _) ) ->
                    walkThrough state spec slot args

                bug ->
                    skipNode args


init : Spec c m s pC pM -> Slot (Container c m s) pC -> NodeCall pC pM
init spec (( _, set ) as slot) args =
    let
        id =
            args.lastComponentId + 1

        self =
            getSelf spec slot id args.namespace args.freshContainers

        ( localState, nonwrappedLocalCmd, localOutSignals ) =
            spec.init self

        localCmd =
            nonwrappedLocalCmd
                |> Cmd.map (wrapLocalMsg args.freshContainers set id)

        localSub =
            spec.subscriptions self localState
                |> Sub.map (wrapLocalMsg args.freshContainers set id)

        (Node tree) =
            spec.view self localState

        state =
            { id = id
            , localState = localState
            , childStates = spec.children
            }

        treeCallResult =
            tree.call
                { newStates = set (StateContainer state) args.newStates
                , currentStates = args.currentStates
                , msg = Touch
                , freshContainers = args.freshContainers
                , lastComponentId = id
                , namespace = args.namespace
                }
    in
    { newStates = treeCallResult.newStates
    , cmd = Cmd.batch [ localCmd, treeCallResult.cmd ]
    , outSignals = localOutSignals ++ treeCallResult.outSignals
    , sub = Sub.batch [ localSub, treeCallResult.sub ]
    , view = treeCallResult.view
    , lastComponentId = treeCallResult.lastComponentId
    }


update :
    ComponentState c s
    -> m
    -> Spec c m s pC pM
    -> Slot (Container c m s) pC
    -> NodeCall pC pM
update state msg spec (( _, set ) as slot) args =
    let
        self =
            getSelf spec slot state.id args.namespace args.freshContainers

        ( newLocalState, nonwrappedLocalCmd, localOutSignals ) =
            spec.update self msg state.localState

        localCmd =
            nonwrappedLocalCmd
                |> Cmd.map (wrapLocalMsg args.freshContainers set state.id)

        localSub =
            spec.subscriptions self newLocalState
                |> Sub.map (wrapLocalMsg args.freshContainers set state.id)

        (Node tree) =
            spec.view self newLocalState

        newState =
            { state
                | localState = newLocalState
                , childStates = spec.children
            }

        treeCallResult =
            tree.call
                { newStates = set (StateContainer newState) args.newStates
                , currentStates = args.currentStates
                , msg = Touch
                , freshContainers = args.freshContainers
                , lastComponentId = args.lastComponentId
                , namespace = args.namespace
                }
    in
    { newStates = treeCallResult.newStates
    , cmd = Cmd.batch [ localCmd, treeCallResult.cmd ]
    , outSignals = localOutSignals ++ treeCallResult.outSignals
    , sub = Sub.batch [ localSub, treeCallResult.sub ]
    , view = treeCallResult.view
    , lastComponentId = treeCallResult.lastComponentId
    }


walkThrough :
    ComponentState c s
    -> Spec c m s pC pM
    -> Slot (Container c m s) pC
    -> NodeCall pC pM
walkThrough state spec (( _, set ) as slot) args =
    let
        self =
            getSelf spec slot state.id args.namespace args.freshContainers

        localSub =
            spec.subscriptions self state.localState
                |> Sub.map (wrapLocalMsg args.freshContainers set state.id)

        (Node tree) =
            spec.view self state.localState

        newState =
            { state | childStates = spec.children }

        treeCallResult =
            tree.call
                { newStates = set (StateContainer newState) args.newStates
                , currentStates = args.currentStates
                , msg = args.msg
                , freshContainers = args.freshContainers
                , lastComponentId = args.lastComponentId
                , namespace = args.namespace
                }
    in
    { newStates = treeCallResult.newStates
    , cmd = treeCallResult.cmd
    , outSignals = treeCallResult.outSignals
    , sub = Sub.batch [ localSub, treeCallResult.sub ]
    , view = treeCallResult.view
    , lastComponentId = treeCallResult.lastComponentId
    }


getSelf :
    Spec c m s pC pM
    -> Slot (Container c m s) pC
    -> Int
    -> String
    -> pC
    -> Self c m pC pM
getSelf spec (( _, set ) as slot) id namespace freshParentContainers =
    { id = "_" ++ namespace ++ "_" ++ toString id
    , send = \msg -> LocalMsgSignal { componentId = id, msg = msg }
    , wrapNode = wrapNode spec slot
    , wrapSignal = toParentSignal freshParentContainers set
    }


wrapNode :
    Spec c m s pC pM
    -> Slot (Container c m s) pC
    -> Node c m
    -> Node pC pM
wrapNode spec slot node =
    Node
        { call = callWrappedNode spec slot node
        }


callWrappedNode :
    Spec c m s pC pM
    -> Slot (Container c m s) pC
    -> Node c m
    -> NodeCall pC pM
callWrappedNode spec ( get, set ) (Node node) args =
    case get args.newStates of
        StateContainer parentState ->
            let
                currentStates =
                    case get args.currentStates of
                        EmptyContainer ->
                            spec.children

                        StateContainer { childStates } ->
                            childStates

                        bug ->
                            spec.children

                msg =
                    case args.msg of
                        Touch ->
                            Touch

                        HandleSignal signalContainers ->
                            case get signalContainers of
                                EmptyContainer ->
                                    Touch

                                SignalContainer (LocalMsgSignal _) ->
                                    Touch

                                SignalContainer (ChildMsgSignal signal) ->
                                    HandleSignal signal

                                bug ->
                                    Touch

                callResult =
                    node.call
                        { newStates = parentState.childStates
                        , currentStates = currentStates
                        , msg = msg
                        , freshContainers = spec.children
                        , lastComponentId = args.lastComponentId
                        , namespace = args.namespace
                        }

                newParentState =
                    { parentState | childStates = callResult.newStates }

                transformSignal =
                    toParentSignal args.freshContainers set
            in
            { newStates = set (StateContainer newParentState) args.newStates
            , cmd = Cmd.map transformSignal callResult.cmd
            , outSignals = List.map transformSignal callResult.outSignals
            , sub = Sub.map transformSignal callResult.sub
            , view = Html.Styled.map transformSignal callResult.view
            , lastComponentId = callResult.lastComponentId
            }

        bug ->
            skipNode args


skipNode : NodeCall c m
skipNode args =
    { newStates = args.newStates
    , cmd = Cmd.none
    , outSignals = []
    , sub = Sub.none
    , view = Html.Styled.text ""
    , lastComponentId = args.lastComponentId
    }


wrapLocalMsg :
    pC
    -> (Container c m s -> pC -> pC)
    -> Int
    -> m
    -> Signal pC pM
wrapLocalMsg freshParentContainers set componentId msg =
    LocalMsgSignal
        { componentId = componentId
        , msg = msg
        }
        |> toParentSignal freshParentContainers set


toParentSignal :
    pC
    -> (Container c m s -> pC -> pC)
    -> Signal c m
    -> Signal pC pM
toParentSignal freshParentContainers set signal =
    freshParentContainers
        |> set (SignalContainer signal)
        |> ChildMsgSignal


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
