module Components.Internal.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        , wrapNode
        , wrapSignal
        , wrapSlot
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
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node pC pM
    , children : c
    }


type alias SpecWithOptions c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node pC pM
    , children : c
    , options : Options m
    }


type alias Self c m s pC =
    { id : String
    , send : m -> Signal c m
    , internal : InternalData c m s pC
    }


type alias Options m =
    { onContextUpdate : Maybe m
    }


type InternalData c m s pC
    = InternalData
        { slot : Slot (Container c m s) pC
        , freshContainers : c
        , freshParentContainers : pC
        }


mixedComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
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
    SpecWithOptions c m s pC pM
    -> Component (Container c m s) pC pM
mixedComponentWithOptions spec =
    Component <|
        \slot ->
            Node
                { call = call spec slot
                }


call :
    SpecWithOptions c m s pC pM
    -> Slot (Container c m s) pC
    -> NodeCall pC pM
call spec (( get, set ) as slot) args =
    case args.msg of
        Touch ->
            case get args.currentStates of
                EmptyContainer ->
                    init spec slot args

                StateContainer state ->
                    case spec.options.onContextUpdate of
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


init :
    SpecWithOptions c m s pC pM
    -> Slot (Container c m s) pC
    -> NodeCall pC pM
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
    -> SpecWithOptions c m s pC pM
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
    -> SpecWithOptions c m s pC pM
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
    SpecWithOptions c m s pC pM
    -> Slot (Container c m s) pC
    -> Int
    -> String
    -> pC
    -> Self c m s pC
getSelf spec slot id namespace freshParentContainers =
    { id = "_" ++ namespace ++ "_" ++ toString id
    , send = \msg -> LocalMsgSignal { componentId = id, msg = msg }
    , internal =
        InternalData
            { slot = slot
            , freshContainers = spec.children
            , freshParentContainers = freshParentContainers
            }
    }


wrapSignal : Self c m s pC -> Signal c m -> Signal pC pM
wrapSignal self =
    let
        (InternalData internalData) =
            self.internal

        ( _, set ) =
            internalData.slot
    in
    toParentSignal internalData.freshParentContainers set


wrapNode : Self c m s pC -> Node c m -> Node pC pM
wrapNode self node =
    Node
        { call = callWrappedNode self.internal node
        }


callWrappedNode : InternalData c m s pC -> Node c m -> NodeCall pC pM
callWrappedNode (InternalData internalData) (Node node) args =
    let
        ( get, set ) =
            internalData.slot
    in
    case get args.newStates of
        StateContainer parentState ->
            let
                currentStates =
                    case get args.currentStates of
                        EmptyContainer ->
                            internalData.freshContainers

                        StateContainer { childStates } ->
                            childStates

                        bug ->
                            internalData.freshContainers

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
                        , freshContainers = internalData.freshContainers
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


wrapSlot :
    Self c m s pC
    -> Slot (Container cC cM cS) c
    -> Slot (Container cC cM cS) pC
wrapSlot self ( getChild, setChild ) =
    let
        (InternalData internalData) =
            self.internal

        ( get, set ) =
            internalData.slot

        wrappedGet parentContainers =
            case get parentContainers of
                EmptyContainer ->
                    EmptyContainer

                StateContainer state ->
                    getChild state.childStates

                SignalContainer (LocalMsgSignal _) ->
                    EmptyContainer

                SignalContainer (ChildMsgSignal containers) ->
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
                        newChildStates =
                            setChild childContainer state.childStates

                        newState =
                            { state | childStates = newChildStates }
                    in
                    set (StateContainer newState) parentContainers

                SignalContainer _ ->
                    set (wrapSignal childContainer) parentContainers

        wrapSignal childContainer =
            internalData.freshContainers
                |> setChild childContainer
                |> ChildMsgSignal
                |> SignalContainer
    in
    ( wrappedGet, wrappedSet )


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
