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


type alias Spec v w s m c pM pC =
    { init : Self s m c pC -> ( s, Cmd m, List (Signal pM pC) )
    , update : Self s m c pC -> m -> s -> ( s, Cmd m, List (Signal pM pC) )
    , subscriptions : Self s m c pC -> s -> Sub m
    , view : Self s m c pC -> s -> Node v w m c
    , children : c
    }


type alias SpecWithOptions v w s m c pM pC =
    { init : Self s m c pC -> ( s, Cmd m, List (Signal pM pC) )
    , update : Self s m c pC -> m -> s -> ( s, Cmd m, List (Signal pM pC) )
    , subscriptions : Self s m c pC -> s -> Sub m
    , view : Self s m c pC -> s -> Node v w m c
    , children : c
    , options : Options m
    }


type alias Self s m c pC =
    BaseComponent.Self s m c pC


type alias Options m =
    BaseComponent.Options m


regularComponent : Spec v w s m c pM pC -> Component v w (Container s m c) pM pC
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
    SpecWithOptions v w s m c pM pC
    -> Component v w (Container s m c) pM pC
regularComponentWithOptions spec =
    BaseComponent.baseComponentWithOptions
        { spec | view = \self -> spec.view self >> BaseComponent.wrapNode self }


sendToChild : Self s m c pC -> Slot (Container cS cM cC) c -> cM -> Signal pM pC
sendToChild =
    BaseComponent.sendToChild


defaultOptions : Options m
defaultOptions =
    BaseComponent.defaultOptions
