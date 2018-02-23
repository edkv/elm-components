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

import Components
    exposing
        ( Component
        , ComponentInternalStuff
        , Container
        , Node
        , Self
        , Signal
        , Slot
        )
import Components.MixedComponent as MixedComponent


type alias Spec v w s m p oM oP =
    { init : Self s m p oP -> ( s, Cmd m, List (Signal oM oP) )
    , update : Self s m p oP -> m -> s -> ( s, Cmd m, List (Signal oM oP) )
    , subscriptions : Self s m p oP -> s -> Sub m
    , view : Self s m p oP -> s -> Node v w m p
    , parts : p
    }


type alias SpecWithOptions v w s m p oM oP =
    { init : Self s m p oP -> ( s, Cmd m, List (Signal oM oP) )
    , update : Self s m p oP -> m -> s -> ( s, Cmd m, List (Signal oM oP) )
    , subscriptions : Self s m p oP -> s -> Sub m
    , view : Self s m p oP -> s -> Node v w m p
    , parts : p
    , options : Options m
    }


type alias Options m =
    { onContextUpdate : Maybe m
    }


type alias Self s m p oP =
    { id : String
    , internal : ComponentInternalStuff s m p oP
    }


regularComponent : Spec v w s m p oM oP -> Component v w (Container s m p) oM oP
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
    SpecWithOptions v w s m p oM oP
    -> Component v w (Container s m p) oM oP
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
