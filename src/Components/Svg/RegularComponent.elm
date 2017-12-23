module Components.Svg.RegularComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , regularComponent
        , regularComponentWithOptions
        , sendToChild
        )

import Components exposing (Container, Signal, Slot)
import Components.Internal.Core exposing (Node)
import Components.Internal.RegularComponent as RegularComponent
import Components.Internal.Shared
    exposing
        ( SvgComponent(SvgComponent)
        , SvgNode(SvgNode)
        )
import Components.Svg exposing (Component, Svg)


type alias Spec c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Svg c m
    , children : c
    }


type alias SpecWithOptions c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Svg c m
    , children : c
    , options : Options m
    }


type alias Self c m s pC =
    RegularComponent.Self c m s pC


type alias Options m =
    RegularComponent.Options m


regularComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
regularComponent spec =
    regularComponentWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , children = spec.children
        , options = defaultOptions
        }


regularComponentWithOptions :
    SpecWithOptions c m s pC pM
    -> Component (Container c m s) pC pM
regularComponentWithOptions spec =
    { spec | view = view spec }
        |> RegularComponent.regularComponentWithOptions
        |> SvgComponent


view : SpecWithOptions c m s pC pM -> Self c m s pC -> s -> Node c m
view spec self state =
    let
        (SvgNode node) =
            spec.view self state
    in
    node


sendToChild : Self c m s pC -> Slot (Container cC cM cS) c -> cM -> Signal pC pM
sendToChild =
    RegularComponent.sendToChild


defaultOptions : Options m
defaultOptions =
    RegularComponent.defaultOptions
