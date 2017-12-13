module Components.Internal.RegularComponent
    exposing
        ( Options
        , Self
        , Spec
        , defaultOptions
        , regularComponent
        , regularComponentWithOptions
        )

import Components.Internal.Core exposing (Component, Container, Node, Signal)
import Components.Internal.MixedComponent as MixedComponent


type alias Spec c m s pC pM =
    { init : Self c m -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m -> s -> Sub m
    , view : Self c m -> s -> Node c m
    , children : c
    }


type alias Self c m =
    { id : String
    , send : m -> Signal c m
    }


type alias Options m =
    MixedComponent.Options m


regularComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
regularComponent =
    regularComponentWithOptions defaultOptions


regularComponentWithOptions :
    Options m
    -> Spec c m s pC pM
    -> Component (Container c m s) pC pM
regularComponentWithOptions options spec =
    MixedComponent.mixedComponentWithOptions options
        { init = transformSelf >> spec.init
        , update = transformSelf >> spec.update
        , subscriptions = transformSelf >> spec.subscriptions
        , view = \self -> spec.view (transformSelf self) >> self.wrapNode
        , children = spec.children
        }


transformSelf : MixedComponent.Self c m pC pM -> Self c m
transformSelf { id, send } =
    { id = id
    , send = send
    }


defaultOptions : Options m
defaultOptions =
    MixedComponent.defaultOptions
