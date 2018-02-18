module Components.RegularComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , regularComponent
        , regularComponentWithOptions
        )

import Components exposing (Component, Container, Node, Self, Signal, Slot)
import Components.Internal.Shared exposing (ComponentInternalStuff)
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


type alias Options m =
    { onContextUpdate : Maybe m
    }


type alias Self s m p pP =
    { id : String
    , internal : ComponentInternalStuff s m p pP
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


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
