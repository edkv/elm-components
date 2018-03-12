module Main exposing (main)

import Components
import Counter
import VirtualDom


type alias State =
    { counterState : Components.State Counter.Container Never
    }


type Msg
    = CounterMsg (Components.Msg Counter.Container Never)


main : Program Never State Msg
main =
    VirtualDom.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( State, Cmd Msg )
init =
    let
        ( counterState, counterCmd ) =
            Components.init Counter.counter
    in
    ( { counterState = counterState
      }
    , Cmd.map CounterMsg counterCmd
    )


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        CounterMsg counterMsg ->
            let
                ( newCounterState, counterCmd, _ ) =
                    Components.update counterMsg state.counterState
            in
            ( { state | counterState = newCounterState }
            , Cmd.map CounterMsg counterCmd
            )


subscriptions : State -> Sub Msg
subscriptions state =
    Components.subscriptions state.counterState
        |> Sub.map CounterMsg


view : State -> VirtualDom.Node Msg
view state =
    Components.view state.counterState
        |> VirtualDom.map CounterMsg
