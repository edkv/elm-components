module Components.Test.Support.Counter exposing (Config, Container, counter)

import Components exposing (send)
import Components.Html as Html exposing (Html)
import Components.Html.Attributes as Attributes
import Components.Html.Events as Events
import Components.RegularComponent as RegularComponent exposing (Self)


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


counter : Config -> Html.Component Container m p
counter config =
    RegularComponent.regularComponent
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
    Html.div [ Attributes.id self.id ]
        [ Html.div [ Attributes.id "value" ]
            [ Html.text (toString state.value)
            ]
        , Html.button
            [ Attributes.id "increment"
            , Events.onClick (send Increment)
            ]
            []
        , Html.button
            [ Attributes.id "decrement"
            , Events.onClick (send Decrement)
            ]
            []
        ]
