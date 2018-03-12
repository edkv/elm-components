module DialogWithConfirmation exposing (Config, Container, dialog)

import Components
    exposing
        ( Component
        , Signal
        , Slot
        , convertNode
        , convertSignal
        , convertSlot
        , send
        , slot
        , x1
        )
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (hidden)
import Components.Html.Events exposing (onClick)
import Dialog


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { waitingForConfirmation : Bool
    }


type Msg
    = ShowConfirmation
    | HideConfirmation


type alias Parts =
    { dialog : Dialog.Container
    }


type alias Self p =
    Components.Self State Msg Parts p


type alias Config m p =
    { onClose : Signal m p
    }


dialog : Config m p -> List (Html m p) -> Component Container m p
dialog config contents =
    Components.mixed
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = view config contents
        , parts = x1 Parts
        }


init : State
init =
    { waitingForConfirmation = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ShowConfirmation ->
            { state | waitingForConfirmation = True }

        HideConfirmation ->
            { state | waitingForConfirmation = False }


view : Config m p -> List (Html m p) -> Self p -> State -> Html m p
view config contents self state =
    Dialog.dialog
        { onClose = send ShowConfirmation |> convertSignal self
        }
        [ div [ hidden state.waitingForConfirmation ] contents
        , maybeConfirmation config self state
        ]
        |> slot (convertSlot self dialogSlot)


maybeConfirmation : Config m p -> Self p -> State -> Html m p
maybeConfirmation config self state =
    if state.waitingForConfirmation then
        div []
            [ div []
                [ text "Close the dialog?"
                ]
            , button [ onClick (send HideConfirmation) ]
                [ text "No"
                ]
                |> convertNode self
            , button [ onClick config.onClose ]
                [ text "Yes"
                ]
            ]
    else
        Html.none


dialogSlot : Slot Dialog.Container Parts
dialogSlot =
    ( .dialog, \x y -> { y | dialog = x } )
