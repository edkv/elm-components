module Components.Internal.Run
    exposing
        ( Msg(NamespaceGenerated)
        , State
        , init
        , subscriptions
        , update
        , view
        , wrapMsg
        )

{-| Implements functions for embedding components into a plain TEA code.

There are two reasons for this to be in a separate module:

  - To make the main module cleaner.
  - To be able to expose some internals to the testing code.

-}

import Components.Internal.Core
    exposing
        ( Cache
        , Component(Component)
        , ComponentId
        , ComponentInterface(ComponentInterface)
        , ComponentLocations
        , Container(EmptyContainer, SignalContainer)
        , Node(ComponentNode)
        , RenderedComponent
        , Signal(LocalMsg, PartMsg)
        )
import Dict
import Html.Styled
import Random.Pcg as Random
import Uuid.Barebones as Uuid
import VirtualDom


type State container outMsg
    = Empty
    | WaitingForNamespace (RenderedComponent outMsg container)
    | Ready (ReadyState container outMsg)


type alias ReadyState container outMsg =
    { component : ComponentInterface outMsg container
    , componentState : container
    , cache : Cache outMsg container
    , componentLocations : ComponentLocations
    , lastComponentId : Int
    , namespace : String
    }


type Msg container outMsg
    = NamespaceGenerated String
    | ComponentMsg (MsgPayload outMsg container)


type alias MsgPayload outMsg container =
    { signal : Signal outMsg container
    , maxPossibleTargetId : Maybe ComponentId
    }


init :
    Component (Container s m p) (Node v w outMsg (Container s m p)) (Container s m p)
    -> ( State (Container s m p) outMsg, Cmd (Msg (Container s m p) outMsg) )
init (Component component) =
    case component ( \x -> x, \x _ -> x ) of
        ComponentNode component ->
            ( WaitingForNamespace component
            , Random.generate NamespaceGenerated Uuid.uuidStringGenerator
            )

        _ ->
            -- If the node isn't a `ComponentNode` for whatever reason
            -- (and such case shouldn't normally occur), just do nothing.
            ( Empty, Cmd.none )


update :
    Msg (Container s m p) outMsg
    -> State (Container s m p) outMsg
    -> ( State (Container s m p) outMsg, Cmd (Msg (Container s m p) outMsg), List outMsg )
update msg state =
    case ( state, msg ) of
        ( WaitingForNamespace component, NamespaceGenerated namespace ) ->
            let
                ( _, change ) =
                    component.touch
                        { states = EmptyContainer
                        , cache = Dict.empty
                        , freshContainers = EmptyContainer
                        , componentLocations = Dict.empty
                        , lastComponentId = 0
                        , namespace = namespace
                        }

                state =
                    { component = change.component
                    , componentState = change.states
                    , cache = change.cache
                    , componentLocations = change.componentLocations
                    , lastComponentId = change.lastComponentId
                    , namespace = namespace
                    }

                cmd =
                    Cmd.map (transformSignal state) change.cmd

                signals =
                    List.map (transformSignal state) change.signals
            in
            doUpdate signals state cmd []
                |> transformUpdateResults

        ( Ready readyState, ComponentMsg componentSignal ) ->
            doUpdate [ componentSignal ] readyState Cmd.none []
                |> transformUpdateResults

        ( _, _ ) ->
            ( state, Cmd.none, [] )


doUpdate :
    List (MsgPayload outMsg (Container s m p))
    -> ReadyState (Container s m p) outMsg
    -> Cmd (MsgPayload outMsg (Container s m p))
    -> List outMsg
    -> ( ReadyState (Container s m p) outMsg, Cmd (MsgPayload outMsg (Container s m p)), List outMsg )
doUpdate signals state cmds outMsgs =
    case signals of
        [] ->
            ( state, cmds, outMsgs )

        payload :: otherSignals ->
            case payload.signal of
                LocalMsg outMsg ->
                    doUpdate otherSignals state cmds (outMsg :: outMsgs)

                PartMsg _ signalContainer ->
                    let
                        (ComponentInterface component) =
                            state.component

                        maxPossibleTargetId =
                            payload.maxPossibleTargetId
                                |> Maybe.withDefault state.lastComponentId

                        change =
                            component.update
                                { states = state.componentState
                                , cache = state.cache
                                , signalContainers = signalContainer
                                , path = []
                                , maxPossibleTargetId = maxPossibleTargetId
                                , freshContainers = EmptyContainer
                                , componentLocations = state.componentLocations
                                , lastComponentId = state.lastComponentId
                                , namespace = state.namespace
                                }

                        cleanupResult =
                            change.cleanup
                                { states = change.states
                                , cache = change.cache
                                , componentLocations = change.componentLocations
                                }

                        updatedState =
                            { state
                                | componentState = cleanupResult.states
                                , component = change.component
                                , cache = cleanupResult.cache
                                , componentLocations = cleanupResult.componentLocations
                                , lastComponentId = change.lastComponentId
                            }

                        cmd =
                            change.cmd
                                |> Cmd.map (transformSignal updatedState)

                        moreSignals =
                            change.signals
                                |> List.map (transformSignal updatedState)
                    in
                    doUpdate
                        (otherSignals ++ moreSignals)
                        updatedState
                        (Cmd.batch [ cmds, cmd ])
                        outMsgs


subscriptions :
    State (Container s m p) outMsg
    -> Sub (Msg (Container s m p) outMsg)
subscriptions state =
    case state of
        Ready readyState ->
            let
                (ComponentInterface component) =
                    readyState.component
            in
            component.subscriptions ()
                |> Sub.map (transformSignal readyState >> ComponentMsg)

        _ ->
            Sub.none


view :
    State (Container s m p) outMsg
    -> VirtualDom.Node (Msg (Container s m p) outMsg)
view state =
    case state of
        Ready readyState ->
            let
                (ComponentInterface component) =
                    readyState.component
            in
            component.view ()
                |> Html.Styled.toUnstyled
                |> VirtualDom.map (transformSignal readyState >> ComponentMsg)

        _ ->
            VirtualDom.text ""


transformSignal :
    ReadyState container outMsg
    -> Signal outMsg container
    -> MsgPayload outMsg container
transformSignal state signal =
    { signal = signal
    , maxPossibleTargetId = Just state.lastComponentId
    }


transformUpdateResults :
    ( ReadyState container outMsg, Cmd (MsgPayload outMsg container), List outMsg )
    -> ( State container outMsg, Cmd (Msg container outMsg), List outMsg )
transformUpdateResults ( state, cmd, outMsgs ) =
    ( Ready state
    , Cmd.map ComponentMsg cmd
    , List.reverse outMsgs
    )


wrapMsg : m -> Msg (Container s m p) outMsg
wrapMsg =
    LocalMsg
        >> SignalContainer
        >> PartMsg (always Nothing)
        >> (\signal -> { signal = signal, maxPossibleTargetId = Nothing })
        >> ComponentMsg
