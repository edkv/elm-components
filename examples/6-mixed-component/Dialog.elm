module Dialog exposing (Config, Container, dialog)

import Components exposing (Component, Signal, convertNode, convertSignal, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (styles)
import Components.Html.Events exposing (onClick, onMouseOut, onMouseOver)
import Css


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isShowingContents : Bool
    , isBackgroundDark : Bool
    }


type Msg
    = ToggleContents
    | DarkenBackground
    | LightenBackground


type alias Parts =
    ()


type alias Self p =
    Components.Self State Msg Parts p


type alias Config m p =
    { onClose : Signal m p
    }


dialog : Config m p -> List (Html m p) -> Component Container m p
dialog config contents =
    Components.mixed
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = view config contents
        , parts = ()
        }


init : State
init =
    { isShowingContents = True
    , isBackgroundDark = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ToggleContents ->
            { state | isShowingContents = not state.isShowingContents }

        DarkenBackground ->
            { state | isBackgroundDark = True }

        LightenBackground ->
            { state | isBackgroundDark = False }


view : Config m p -> List (Html m p) -> Self p -> State -> Html m p
view config contents self state =
    div [ styles rootStyles ]
        [ background config state
        , box config contents self state
        ]


background : Config m p -> State -> Html m p
background config state =
    div
        [ styles (backgroundStyles state)
        , onClick config.onClose
        ]
        []


box : Config m p -> List (Html m p) -> Self p -> State -> Html m p
box config contents self state =
    div
        [ styles boxStyles
        , onMouseOver (send DarkenBackground |> convertSignal self)
        , onMouseOut (send LightenBackground |> convertSignal self)
        ]
        [ maybeContents contents state
        , buttons config self
        ]


maybeContents : List (Html m p) -> State -> Html m p
maybeContents contents state =
    div [] <|
        if state.isShowingContents then
            contents
        else
            []


buttons : Config m p -> Self p -> Html m p
buttons config self =
    div [ styles buttonsWrapperStyles ]
        [ toggleButton self
        , closeButton config
        ]


toggleButton : Self p -> Html m p
toggleButton self =
    button [ onClick (send ToggleContents) ]
        [ text "Toggle contents"
        ]
        |> convertNode self


closeButton : Config m p -> Html m p
closeButton config =
    button [ onClick config.onClose ]
        [ text "Close"
        ]


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


buttonsWrapperStyles : List Css.Style
buttonsWrapperStyles =
    [ Css.display Css.inlineBlock
    , Css.marginTop (Css.px 15)
    ]


backgroundStyles : State -> List Css.Style
backgroundStyles state =
    let
        opacity =
            if state.isBackgroundDark then
                0.6
            else
                0.4
    in
    [ Css.position Css.absolute
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    , Css.backgroundColor (Css.rgb 0 0 0)
    , Css.opacity (Css.num opacity)
    , Css.property "transition" "opacity 400ms"
    ]
