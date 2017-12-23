module Components.Html.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        , wrapAttribute
        , wrapNode
        , wrapSignal
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
    { spec | view = view spec }
        |> MixedComponent.mixedComponentWithOptions
        |> HtmlComponent


view : SpecWithOptions c m s pC pM -> Self c m s pC -> s -> Node pC pM
view spec self state =
    let
        (HtmlNode node) =
            spec.view self state
    in
    node


wrapSignal : Self c m s pC -> Signal c m -> Signal pC pM
wrapSignal =
    MixedComponent.wrapSignal


wrapAttribute : Self c m s pC -> Attribute c m -> Attribute pC pM
wrapAttribute self (HtmlAttribute attribute) =
    MixedComponent.wrapAttribute self attribute
        |> HtmlAttribute


wrapNode : Self c m s pC -> Html c m -> Html pC pM
wrapNode self (HtmlNode node) =
    MixedComponent.wrapNode self node
        |> HtmlNode


wrapSlot :
    Self c m s pC
    -> Slot (Container cC cM cS) c
    -> Slot (Container cC cM cS) pC
wrapSlot =
    MixedComponent.wrapSlot


defaultOptions : Options m
defaultOptions =
    MixedComponent.defaultOptions
