module Components.RegularComponent
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

import Components exposing (Component, Container, Node, Signal, Slot)
import Components.Internal.BaseComponent as BaseComponent


type alias Spec x y c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node x y c m
    , children : c
    }


type alias SpecWithOptions x y c m s pC pM =
    { init : Self c m s pC -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self c m s pC -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self c m s pC -> s -> Sub m
    , view : Self c m s pC -> s -> Node x y c m
    , children : c
    , options : Options m
    }


type alias Self c m s pC =
    BaseComponent.Self c m s pC


type alias Options m =
    BaseComponent.Options m


regularComponent : Spec x y c m s pC pM -> Component x y (Container c m s) pC pM
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
    SpecWithOptions x y c m s pC pM
    -> Component x y (Container c m s) pC pM
regularComponentWithOptions spec =
    BaseComponent.baseComponentWithOptions
        { spec | view = \self -> spec.view self >> BaseComponent.wrapNode self }


sendToChild : Self c m s pC -> Slot (Container cC cM cS) c -> cM -> Signal pC pM
sendToChild =
    BaseComponent.sendToChild


defaultOptions : Options m
defaultOptions =
    BaseComponent.defaultOptions
