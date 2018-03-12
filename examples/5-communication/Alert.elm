module Alert exposing (Config, Container, alert)

import Animation
import Components exposing (Component, Signal, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Attributes as Attributes exposing (styles)
import Components.Html.Events exposing (onClick)
import Css


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { backgroundAnimation : Animation.State
    }


type Msg
    = AnimateBackground Animation.Msg
    | Closed


type alias Parts =
    ()


type alias Config m p =
    { text : String
    , onClose : Signal m p
    }


alert : Config m p -> Component Container m p
alert config =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ -> update config
        , subscriptions = \_ -> subscriptions
        , view = \_ -> view config
        , parts = ()
        }


init : State
init =
    { backgroundAnimation =
        Animation.style [ Animation.opacity 0 ]
            |> Animation.interrupt
                [ Animation.to [ Animation.opacity 1 ]
                ]
    }


update : Config m p -> Msg -> State -> ( State, Cmd Msg, List (Signal m p) )
update config msg state =
    case msg of
        AnimateBackground animationMsg ->
            let
                updatedAnimation =
                    Animation.update animationMsg state.backgroundAnimation
            in
            ( { state | backgroundAnimation = updatedAnimation }
            , Cmd.none
            , []
            )

        Closed ->
            ( state
            , Cmd.none
            , [ config.onClose ]
            )


subscriptions : State -> Sub Msg
subscriptions state =
    Animation.subscription AnimateBackground [ state.backgroundAnimation ]


view : Config m p -> State -> Html Msg Parts
view config state =
    div [ styles rootStyles ]
        [ background state
        , div [ styles boxStyles ]
            [ div []
                [ text config.text
                ]
            , button [ styles closeButtonStyles, onClick (send Closed) ]
                [ text "Close"
                ]
            ]
        ]


background : State -> Html Msg Parts
background state =
    let
        attributes =
            [ styles backgroundStyles
            , onClick (send Closed)
            ]

        animation =
            state.backgroundAnimation
                |> Animation.render
                |> List.map Attributes.plain
    in
    div (attributes ++ animation) []


rootStyles : List Css.Style
rootStyles =
    [ Css.position Css.fixed
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    ]


boxStyles : List Css.Style
boxStyles =
    [ Css.position Css.absolute
    , Css.top (Css.px 50)
    , Css.left (Css.pct 50)
    , Css.transform (Css.translateX (Css.pct -50))
    , Css.padding (Css.px 15)
    , Css.minWidth (Css.px 80)
    , Css.textAlign Css.center
    , Css.backgroundColor (Css.rgb 255 255 255)
    , Css.boxShadow4 Css.zero (Css.px 7) (Css.px 20) (Css.rgba 0 0 0 0.3)
    ]


closeButtonStyles : List Css.Style
closeButtonStyles =
    [ Css.display Css.inlineBlock
    , Css.marginTop (Css.px 15)
    ]


backgroundStyles : List Css.Style
backgroundStyles =
    [ Css.position Css.absolute
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    , Css.backgroundColor (Css.rgba 0 0 0 0.6)
    ]
