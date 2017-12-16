module Components.Html.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
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
    { init : Self c m pC pM -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m pC pM -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m pC pM -> s -> Sub m
    , view : Self c m pC pM -> s -> Html pC pM
    , children : c
    }


type alias Self c m pC pM =
    { id : String
    , send : m -> Signal c m
    , wrapNode : Html c m -> Html pC pM
    , wrapSignal : Signal c m -> Signal pC pM
    }


type alias Options m =
    MixedComponent.Options m


mixedComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
mixedComponent =
    mixedComponentWithOptions defaultOptions


mixedComponentWithOptions :
    Options m
    -> Spec c m s pC pM
    -> Component (Container c m s) pC pM
mixedComponentWithOptions options spec =
    HtmlComponent <|
        MixedComponent.mixedComponentWithOptions options
            { init = transformSelf >> spec.init
            , update = transformSelf >> spec.update
            , subscriptions = transformSelf >> spec.subscriptions
            , view = \self -> spec.view (transformSelf self) >> unwrapHtml
            , children = spec.children
            }


transformSelf : MixedComponent.Self c m pC pM -> Self c m pC pM
transformSelf self =
    { self | wrapNode = unwrapHtml >> self.wrapNode >> HtmlNode }


unwrapHtml : Html c m -> Node c m
unwrapHtml (HtmlNode node) =
    node


defaultOptions : Options m
defaultOptions =
    MixedComponent.defaultOptions
