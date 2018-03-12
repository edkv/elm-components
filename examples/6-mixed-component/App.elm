module App exposing (Container, app)

import Components exposing (Component, send, slot, x2)
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)
import Counter
import DialogWithConfirmation as Dialog


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isDialogVisible : Bool
    }


type Msg
    = ShowDialog
    | HideDialog


type alias Parts =
    { dialog : Dialog.Container
    , counter : Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x2 Parts
        }


init : State
init =
    { isDialogVisible = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ShowDialog ->
            { state | isDialogVisible = True }

        HideDialog ->
            { state | isDialogVisible = False }


view : State -> Html Msg Parts
view state =
    div []
        [ showDialogButton
        , maybeDialog state
        ]


showDialogButton : Html Msg Parts
showDialogButton =
    button [ onClick (send ShowDialog) ]
        [ text "Show dialog"
        ]


maybeDialog : State -> Html Msg Parts
maybeDialog state =
    if state.isDialogVisible then
        Dialog.dialog
            { onClose = send HideDialog
            }
            [ counter
            ]
            |> slot ( .dialog, \x y -> { y | dialog = x } )
    else
        Html.none


counter : Html Msg Parts
counter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot ( .counter, \x y -> { y | counter = x } )
