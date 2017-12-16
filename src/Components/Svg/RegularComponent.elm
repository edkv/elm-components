module Components.Svg.RegularComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , regularComponent
        , regularComponentWithOptions
        )

import Components exposing (Container, Signal)
import Components.Internal.Core exposing (Node)
import Components.Internal.RegularComponent as RegularComponent
import Components.Internal.Shared
    exposing
        ( SvgComponent(SvgComponent)
        , SvgNode(SvgNode)
        )
import Components.Svg exposing (Component, Svg)


type alias Spec c m s pC pM =
    { init : Self c m -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m -> s -> Sub m
    , view : Self c m -> s -> Svg c m
    , children : c
    }


type alias SpecWithOptions c m s pC pM =
    { init : Self c m -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m -> s -> Sub m
    , view : Self c m -> s -> Svg c m
    , children : c
    , options : Options m
    }


type alias Self c m =
    RegularComponent.Self c m


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
    SvgComponent <|
        RegularComponent.regularComponentWithOptions
            { init = spec.init
            , update = spec.update
            , subscriptions = spec.subscriptions
            , view = \self -> spec.view self >> unwrapSvg
            , children = spec.children
            , options = spec.options
            }


unwrapSvg : Svg c m -> Node c m
unwrapSvg (SvgNode node) =
    node


defaultOptions : Options m
defaultOptions =
    RegularComponent.defaultOptions
