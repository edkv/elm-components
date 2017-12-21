module Components.Svg.MixedComponent
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
import Components.Internal.Core exposing (Node)
import Components.Internal.MixedComponent as MixedComponent
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
    , view : Self c m s pC -> s -> Svg pC pM
    , children : c
    }


type alias SpecWithOptions c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Svg pC pM
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
    SvgComponent <|
        MixedComponent.mixedComponentWithOptions
            { init = spec.init
            , update = spec.update
            , subscriptions = spec.subscriptions
            , view = \self state -> spec.view self state |> unwrapSvg
            , children = spec.children
            , options = spec.options
            }


wrapNode : Self c m s pC -> Svg c m -> Svg pC pM
wrapNode self (SvgNode node) =
    MixedComponent.wrapNode self node
        |> SvgNode


wrapSignal : Self c m s pC -> Signal c m -> Signal pC pM
wrapSignal =
    MixedComponent.wrapSignal


unwrapSvg : Svg c m -> Node c m
unwrapSvg (SvgNode node) =
    node


defaultOptions : Options m
defaultOptions =
    MixedComponent.defaultOptions
