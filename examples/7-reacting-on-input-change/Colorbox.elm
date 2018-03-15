module Colorbox exposing (Container, colorbox)

import Components exposing (Component)
import Components.Html exposing (Html, div, text)
import Components.Html.Attributes exposing (css)
import Css


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : String
    , currentTheme : Theme
    , otherThemes : List Theme
    }


type alias Theme =
    ( Css.Color, Css.Color )


type Msg
    = ContextUpdated


type alias Parts =
    ()


colorbox : String -> Component Container m p
colorbox value =
    Components.regularWithOptions
        { init = \_ -> ( init value, Cmd.none, [] )
        , update = \_ msg state -> ( update value msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = ()
        , options = { onContextUpdate = Just ContextUpdated }
        }


init : String -> State
init value =
    { value = value
    , currentTheme = ( Css.hex "ad9784", Css.hex "181e1e" )
    , otherThemes =
        [ ( Css.hex "fc5b70", Css.hex "13206a" )
        , ( Css.hex "34abf2", Css.hex "11198a" )
        , ( Css.hex "400844", Css.hex "eed7c9" )
        , ( Css.hex "b35acd", Css.hex "23070a" )
        ]
    }


update : String -> Msg -> State -> State
update value msg state =
    case msg of
        ContextUpdated ->
            if state.value /= value then
                let
                    ( currentTheme, otherThemes ) =
                        case state.otherThemes of
                            nextTheme :: moreThemes ->
                                ( nextTheme
                                , moreThemes ++ [ state.currentTheme ]
                                )

                            [] ->
                                ( state.currentTheme
                                , state.otherThemes
                                )
                in
                { state
                    | value = value
                    , currentTheme = currentTheme
                    , otherThemes = otherThemes
                }
            else
                state


view : State -> Html Msg Parts
view state =
    let
        ( backgroundColor, textColor ) =
            state.currentTheme
    in
    div
        [ css
            [ Css.display Css.inlineBlock
            , Css.backgroundColor backgroundColor
            , Css.color textColor
            , Css.padding (Css.px 10)
            , Css.empty [ Css.padding Css.zero ]
            ]
        ]
        [ text state.value
        ]
