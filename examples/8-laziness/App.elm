module App exposing (Container, app)

import Components exposing (Component, send, slot, x1)
import Components.Html exposing (Html, div, input, text)
import Components.Html.Events exposing (onInput)
import Counter exposing (counter)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : String
    }


type Msg
    = UpdateValue String


type alias Parts =
    { counter : Counter.Container
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
    let
        _ =
            Debug.log "" "App has been recalculated"
    in
    div []
        [ counter |> slot ( .counter, \x y -> { y | counter = x } )
        , input [ onInput (send << UpdateValue) ]
        , div [] [ text state.value ]
        ]
