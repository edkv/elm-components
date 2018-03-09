module Components.Test.Support.Counter exposing (Config, Container, counter)

import Components exposing (Component, Self, send)
import Components.Html as Html exposing (Html)
import Components.Html.Attributes as Attr
import Components.Html.Events as Events


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
        , view = view
        , parts = ()
        }


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


view : Self State Msg Parts p -> State -> Html Msg Parts
view self state =
    Html.div [ Attr.id self.id ]
        [ Html.div [ Attr.id "value" ]
            [ Html.text (toString state.value)
            ]
        , Html.button
            [ Attr.id "increment"
            , Events.onClick (send Increment)
            ]
            []
        , Html.button
            [ Attr.id "decrement"
            , Events.onClick (send Decrement)
            ]
            []
        ]
