module App exposing (Container, app)

import Colorbox exposing (colorbox)
import Components exposing (Component, send, slot, x1)
import Components.Html exposing (Html, div, input)
import Components.Html.Attributes exposing (autofocus, value)
import Components.Html.Events exposing (onInput)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : String
    }


type Msg
    = UpdateValue String


type alias Parts =
    { colorbox : Colorbox.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x1 Parts
        }


init : State
init =
    { value = ""
    }


update : Msg -> State -> State
update msg state =
    case msg of
        UpdateValue newValue ->
            { state | value = newValue }


view : State -> Html Msg Parts
view state =
    div []
        [ div []
            [ input
                [ value state.value
                , autofocus True
                , onInput (send << UpdateValue)
                ]
            ]
        , colorbox state.value
            |> slot ( .colorbox, \x y -> { y | colorbox = x } )
        ]
