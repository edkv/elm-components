module Counter exposing (Container, counter)

import Components exposing (Component, send, slot, x1)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)
import Components.Lazy as Lazy


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : Int
    }


type Msg
    = Increment
    | Decrement


type alias Parts =
    { content : Lazy.Container State
    }


counter : Component Container m p
counter =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x1 Parts
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
    Lazy.lazy content state
        |> slot ( .content, \x y -> { y | content = x } )


content : State -> Html Msg Parts
content state =
    let
        _ =
            Debug.log "" "Counter has been recalculated"
    in
    div []
        [ button [ onClick (send Decrement) ] [ text "-" ]
        , div [] [ text (toString state.value) ]
        , button [ onClick (send Increment) ] [ text "+" ]
        ]
