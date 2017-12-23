module Components.Html.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        , wrapSlot
        )

import Components exposing (Container, Signal, Slot)
import Components.Html exposing (Attribute, Component, Html)
import Components.Internal.Core exposing (Node)
import Components.Internal.Elements as Elements
import Components.Internal.MixedComponent as MixedComponent
import Components.Internal.Shared
    exposing
        ( HtmlAttribute(HtmlAttribute)
        , HtmlComponent(HtmlComponent)
        , HtmlNode(HtmlNode)
        )


type alias Spec c m s pC pM =
    { init : Self c m s pC pM -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC pM -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC pM -> s -> Sub m
    , view : Self c m s pC pM -> s -> Html pC pM
    , children : c
    }


type alias SpecWithOptions c m s pC pM =
    { init : Self c m s pC pM -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC pM -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC pM -> s -> Sub m
    , view : Self c m s pC pM -> s -> Html pC pM
    , children : c
    , options : Options m
    }


type alias Self c m s pC pM =
    { id : String
    , wrapSignal : Signal c m -> Signal pC pM
    , wrapNode : Html c m -> Html pC pM
    , wrapAttribute : Attribute c m -> Attribute pC pM
    , internal : MixedComponent.InternalData c m s pC
    }


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
            { init = transformSelf >> spec.init
            , update = transformSelf >> spec.update
            , subscriptions = transformSelf >> spec.subscriptions
            , view = \self -> spec.view (transformSelf self) >> unwrapHtml
            , children = spec.children
            , options = spec.options
            }


wrapSlot :
    Self c m s pC pM
    -> Slot (Container cC cM cS) c
    -> Slot (Container cC cM cS) pC
wrapSlot self =
    MixedComponent.wrapSlot (transformSelfBack self)


transformSelf : MixedComponent.Self c m s pC pM -> Self c m s pC pM
transformSelf self =
    { self
        | wrapNode = unwrapHtml >> self.wrapNode >> HtmlNode
        , wrapAttribute = unwrapAttribute >> self.wrapAttribute >> HtmlAttribute
    }


transformSelfBack : Self c m s pC pM -> MixedComponent.Self c m s pC pM
transformSelfBack self =
    { self
        | wrapNode = HtmlNode >> self.wrapNode >> unwrapHtml
        , wrapAttribute = HtmlAttribute >> self.wrapAttribute >> unwrapAttribute
    }


unwrapHtml : Html c m -> Node c m
unwrapHtml (HtmlNode node) =
    node


unwrapAttribute : Attribute c m -> Elements.Attribute c m
unwrapAttribute (HtmlAttribute attr) =
    attr


defaultOptions : Options m
defaultOptions =
    MixedComponent.defaultOptions
