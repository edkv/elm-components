module Components.Html.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        , wrapNode
        , wrapSignal
        )

import Components exposing (Container, Signal)
import Components.Html exposing (Component, Html)
import Components.Internal.Core exposing (Node)
import Components.Internal.MixedComponent as MixedComponent
import Components.Internal.Shared
    exposing
        ( HtmlComponent(HtmlComponent)
        , HtmlNode(HtmlNode)
        )


type alias Spec c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Html pC pM
    , children : c
    }


type alias SpecWithOptions c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Html pC pM
    , children : c
    , options : Options m
    }


type alias Self c m s pC =
    MixedComponent.Self c m s pC


type alias Options m =
    MixedComponent.Options m


mixedComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
mixedComponent spec =
    mixedComponentWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , children = spec.children
        , options = defaultOptions
        }


mixedComponentWithOptions :
    SpecWithOptions c m s pC pM
    -> Component (Container c m s) pC pM
mixedComponentWithOptions spec =
    HtmlComponent <|
        MixedComponent.mixedComponentWithOptions
            { init = spec.init
            , update = spec.update
            , subscriptions = spec.subscriptions
            , view = \self state -> spec.view self state |> unwrapHtml
            , children = spec.children
            , options = spec.options
            }


wrapNode : Self c m s pC -> Html c m -> Html pC pM
wrapNode self (HtmlNode node) =
    MixedComponent.wrapNode self node
        |> HtmlNode


wrapSignal : Self c m s pC -> Signal c m -> Signal pC pM
wrapSignal =
    MixedComponent.wrapSignal


unwrapHtml : Html c m -> Node c m
unwrapHtml (HtmlNode node) =
    node


defaultOptions : Options m
defaultOptions =
    MixedComponent.defaultOptions
