module Components.Html.RegularComponent
    exposing
        ( Options
        , Self
        , Spec
        , defaultOptions
        , regularComponent
        , regularComponentWithOptions
        )

import Components exposing (Container, Signal)
import Components.Html exposing (Component, Html)
import Components.Internal.Core exposing (Node)
import Components.Internal.RegularComponent as RegularComponent
import Components.Internal.Shared
    exposing
        ( HtmlComponent(HtmlComponent)
        , HtmlNode(HtmlNode)
        )


type alias Spec c m s pC pM =
    { init : Self c m -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m -> s -> Sub m
    , view : Self c m -> s -> Html c m
    , children : c
    }


type alias Self c m =
    RegularComponent.Self c m


type alias Options m =
    RegularComponent.Options m


regularComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
regularComponent =
    regularComponentWithOptions defaultOptions


regularComponentWithOptions :
    Options m
    -> Spec c m s pC pM
    -> Component (Container c m s) pC pM
regularComponentWithOptions options spec =
    HtmlComponent <|
        RegularComponent.regularComponentWithOptions options
            { init = spec.init
            , update = spec.update
            , subscriptions = spec.subscriptions
            , view = \self -> spec.view self >> unwrapHtml
            , children = spec.children
            }


unwrapHtml : Html c m -> Node c m
unwrapHtml (HtmlNode node) =
    node


defaultOptions : Options m
defaultOptions =
    RegularComponent.defaultOptions
