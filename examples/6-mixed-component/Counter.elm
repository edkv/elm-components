module Counter exposing (Config, Container, Msg, counter, reset)

import Components exposing (Component, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (styles)
import Components.Html.Events exposing (onClick)
import Css exposing (padding, px)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : Int
    }


type Msg
    = Increment
    | Decrement
    | Reset


type alias Parts =
    ()


type alias Config =
    { initialValue : Int
    , step : Int
    }


counter : Config -> Component Container m p
counter config =
    Components.regular
        { init = \_ -> ( init config, Cmd.none, [] )
        , update = \_ msg state -> ( update config msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = ()
        }


reset : Msg
reset =
    Reset


init : Config -> State
init config =
    { value = config.initialValue
    }


update : Config -> Msg -> State -> State
update config msg state =
    case msg of
        Increment ->
            { state | value = state.value + config.step }

        Decrement ->
            { state | value = state.value - config.step }

        Reset ->
            { state | value = config.initialValue }


view : State -> Html Msg Parts
view state =
    div [ styles [ padding (px 10) ] ]
        [ button [ onClick (send Decrement) ] [ text "-" ]
        , div [] [ text (toString state.value) ]
        , button [ onClick (send Increment) ] [ text "+" ]
        ]
