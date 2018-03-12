module Main exposing (main)

import App
import Components
import VirtualDom


type alias State =
    { appState : Components.State App.Container Never
    }


type Msg
    = AppMsg (Components.Msg App.Container Never)


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
        ( appState, appCmd ) =
            Components.init App.app
    in
    ( { appState = appState
      }
    , Cmd.map AppMsg appCmd
    )


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        AppMsg appMsg ->
            let
                ( newAppState, appCmd, _ ) =
                    Components.update appMsg state.appState
            in
            ( { state | appState = newAppState }
            , Cmd.map AppMsg appCmd
            )


subscriptions : State -> Sub Msg
subscriptions state =
    Components.subscriptions state.appState
        |> Sub.map AppMsg


view : State -> VirtualDom.Node Msg
view state =
    Components.view state.appState
        |> VirtualDom.map AppMsg
