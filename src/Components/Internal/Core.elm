module Components.Internal.Core
    exposing
        ( Component(Component)
        , ComponentState
        , Container(EmptyContainer, SignalContainer, StateContainer)
        , Node(Node)
        , NodeCall
        , NodeMsg(HandleSignal, Touch)
        , Signal(ChildMsg, LocalMsg)
        , Slot
        )

import Html.Styled


type Node c m
    = Node
        { call : NodeCall c m
        }


type alias NodeCall c m =
    { newStates : c
    , currentStates : c
    , msg : NodeMsg c
    , freshContainers : c
    , lastComponentId : Int
    , namespace : String
    }
    ->
        { newStates : c
        , cmd : Cmd (Signal c m)
        , outSignals : List (Signal c m)
        , sub : Sub (Signal c m)
        , view : Html.Styled.Html (Signal c m)
        , lastComponentId : Int
        }


type NodeMsg c
    = Touch
    | HandleSignal { containers : c, lastComponentId : Int }


type Component container c m
    = Component (Slot container c -> Node c m)


type alias Slot container c =
    ( c -> container, container -> c -> c )


type Container c m s
    = EmptyContainer
    | StateContainer (ComponentState c s)
    | SignalContainer (Signal c m)


type alias ComponentState c s =
    { id : Int
    , localState : s
    , childStates : c
    }


type Signal c m
    = LocalMsg m
    | ChildMsg c
