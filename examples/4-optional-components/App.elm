module App exposing (Container, app)

import Components exposing (Component, send, slot, x3)
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)
import Counter


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isThirdCounterVisible : Bool
    }


type Msg
    = ToggleThirdCounter


type alias Parts =
    { firstCounter : Counter.Container
    , secondCounter : Counter.Container
    , thirdCounter : Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x3 Parts
        }


init : State
init =
    { isThirdCounterVisible = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ToggleThirdCounter ->
            { state | isThirdCounterVisible = not state.isThirdCounterVisible }


view : State -> Html Msg Parts
view state =
    div []
        [ firstCounter
        , secondCounter
        , maybeThirdCounter state
        , toggleButton
        ]


firstCounter : Html Msg Parts
firstCounter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot ( .firstCounter, \x y -> { y | firstCounter = x } )


secondCounter : Html Msg Parts
secondCounter =
    Counter.counter
        { initialValue = 100
        , step = 10
        }
        |> slot ( .secondCounter, \x y -> { y | secondCounter = x } )


maybeThirdCounter : State -> Html Msg Parts
maybeThirdCounter state =
    if state.isThirdCounterVisible then
        Counter.counter
            { initialValue = 0
            , step = 1
            }
            |> slot ( .thirdCounter, \x y -> { y | thirdCounter = x } )
    else
        Html.none


toggleButton : Html Msg Parts
toggleButton =
    button [ onClick (send ToggleThirdCounter) ]
        [ text "Toggle third counter"
        ]
