module Counter exposing (Container, counter)

import Components exposing (Component, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : Int
    }


type Msg
    = Increment
    | Decrement


type alias Parts =
    ()


counter : Component Container m p
counter =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = ()
        }


init : State
init =
    { value = 0
    }


update : Msg -> State -> State
update msg state =
    case msg of
        Increment ->
            { state | value = state.value + 1 }

        Decrement ->
            { state | value = state.value - 1 }


view : State -> Html Msg Parts
view state =
    div []
        [ button [ onClick (send Decrement) ] [ text "-" ]
        , div [] [ text (toString state.value) ]
        , button [ onClick (send Increment) ] [ text "+" ]
        ]
