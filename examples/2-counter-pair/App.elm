module App exposing (Container, app)

import Components exposing (Component, slot, x2)
import Components.Html exposing (Html, div)
import Counter


type alias Container =
    Components.Container State Msg Parts


type alias State =
    ()


type alias Msg =
    Never


type alias Parts =
    { firstCounter : Counter.Container
    , secondCounter : Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( (), Cmd.none, [] )
        , update = \_ msg _ -> never msg
        , subscriptions = \_ _ -> Sub.none
        , view = \_ _ -> view
        , parts = x2 Parts
        }


view : Html Msg Parts
view =
    div []
        [ firstCounter
        , secondCounter
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
