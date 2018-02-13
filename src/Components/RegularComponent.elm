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
import Components.MixedComponent as MixedComponent


type alias Spec v w s m p pM pP =
    { init : Self s m p pP -> ( s, Cmd m, List (Signal pM pP) )
    , update : Self s m p pP -> m -> s -> ( s, Cmd m, List (Signal pM pP) )
    , subscriptions : Self s m p pP -> s -> Sub m
    , view : Self s m p pP -> s -> Node v w m p
    , parts : p
    }


type alias SpecWithOptions v w s m p pM pP =
    { init : Self s m p pP -> ( s, Cmd m, List (Signal pM pP) )
    , update : Self s m p pP -> m -> s -> ( s, Cmd m, List (Signal pM pP) )
    , subscriptions : Self s m p pP -> s -> Sub m
    , view : Self s m p pP -> s -> Node v w m p
    , parts : p
    , options : Options m
    }


type alias Self s m p pP =
    { id : String
    , internal : BaseComponent.InternalStuff s m p pP
    }


type alias Options m =
    { onContextUpdate : Maybe m
    }


regularComponent : Spec v w s m p pM pP -> Component v w (Container s m p) pM pP
regularComponent spec =
    regularComponentWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , parts = spec.parts
        , options = defaultOptions
        }


regularComponentWithOptions :
    SpecWithOptions v w s m p pM pP
    -> Component v w (Container s m p) pM pP
regularComponentWithOptions spec =
    MixedComponent.mixedComponentWithOptions
        { spec
            | view =
                \self state ->
                    MixedComponent.convertNode self (spec.view self state)
        }


sendToChild : Self s m p pP -> Slot (Container cS cM cP) p -> cM -> Signal pM pP
sendToChild =
    MixedComponent.sendToChild


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
