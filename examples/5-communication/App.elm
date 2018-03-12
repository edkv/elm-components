module App exposing (Container, app)

import Alert
import Components exposing (Component, Signal, Slot, send, sendToPart, slot, x2)
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (id)
import Components.Html.Events exposing (onClick)
import Counter


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isAlertVisible : Bool
    }


type Msg
    = ShowAlert
    | HideAlert
    | ResetCounter


type alias Parts =
    { alert : Alert.Container
    , counter : Counter.Container
    }


type alias Self p =
    Components.Self State Msg Parts p


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = update
        , subscriptions = \_ _ -> Sub.none
        , view = view
        , parts = x2 Parts
        }


init : State
init =
    { isAlertVisible = False
    }


update : Self p -> Msg -> State -> ( State, Cmd Msg, List (Signal m p) )
update self msg state =
    case msg of
        ShowAlert ->
            ( { state | isAlertVisible = True }
            , Cmd.none
            , []
            )

        HideAlert ->
            ( { state | isAlertVisible = False }
            , Cmd.none
            , []
            )

        ResetCounter ->
            ( state
            , Cmd.none
            , [ sendToPart self counterSlot Counter.reset ]
            )


view : Self p -> State -> Html Msg Parts
view self state =
    div [ id self.id ]
        [ counter
        , alertButton
        , counterResetButton
        , maybeAlert state
        ]


counter : Html Msg Parts
counter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot counterSlot


alertButton : Html Msg Parts
alertButton =
    button [ onClick (send ShowAlert) ]
        [ text "Show alert"
        ]


counterResetButton : Html Msg Parts
counterResetButton =
    button [ onClick (send ResetCounter) ]
        [ text "Reset counter"
        ]


maybeAlert : State -> Html Msg Parts
maybeAlert state =
    if state.isAlertVisible then
        Alert.alert
            { text = "Alert!"
            , onClose = send HideAlert
            }
            |> slot ( .alert, \x y -> { y | alert = x } )
    else
        Html.none


counterSlot : Slot Counter.Container Parts
counterSlot =
    ( .counter, \x y -> { y | counter = x } )
