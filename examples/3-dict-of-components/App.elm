module App exposing (Container, app)

import Components exposing (Component, Slot, dictSlot, slot, x2)
import Components.Html exposing (Html, div)
import Counter
import Dict exposing (Dict)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    ()


type alias Msg =
    Never


type alias Parts =
    { firstCounter : Counter.Container
    , secondCounter : Counter.Container
    , counterDict : Dict Int Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( (), Cmd.none, [] )
        , update = \_ msg _ -> never msg
        , subscriptions = \_ _ -> Sub.none
        , view = \_ _ -> view
        , parts = x2 Parts <| Dict.empty
        }


view : Html Msg Parts
view =
    div []
        [ firstCounter
        , secondCounter
        , counterFromDict 0
        , counterFromDict 1
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


counterFromDict : Int -> Html Msg Parts
counterFromDict key =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot (dictSlot counterDictSlot key)


counterDictSlot : Slot (Dict Int Counter.Container) Parts
counterDictSlot =
    ( .counterDict, \x y -> { y | counterDict = x } )
