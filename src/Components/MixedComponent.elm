module Components.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , convertAttribute
        , convertNode
        , convertSignal
        , convertSlot
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        )

import Components
    exposing
        ( Attribute
        , Component
        , ComponentInternalStuff
        , Container
        , Node
        , Signal
        , Slot
        )
import Components.Internal.BaseComponent as BaseComponent


type alias Spec v w s m p oM oP =
    { init : Self s m p oP -> ( s, Cmd m, List (Signal oM oP) )
    , update : Self s m p oP -> m -> s -> ( s, Cmd m, List (Signal oM oP) )
    , subscriptions : Self s m p oP -> s -> Sub m
    , view : Self s m p oP -> s -> Node v w oM oP
    , parts : p
    }


type alias SpecWithOptions v w s m p oM oP =
    { init : Self s m p oP -> ( s, Cmd m, List (Signal oM oP) )
    , update : Self s m p oP -> m -> s -> ( s, Cmd m, List (Signal oM oP) )
    , subscriptions : Self s m p oP -> s -> Sub m
    , view : Self s m p oP -> s -> Node v w oM oP
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


mixedComponent : Spec v w s m p oM oP -> Component v w (Container s m p) oM oP
mixedComponent spec =
    mixedComponentWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , parts = spec.parts
        , options = defaultOptions
        }


mixedComponentWithOptions :
    SpecWithOptions v w s m p oM oP
    -> Component v w (Container s m p) oM oP
mixedComponentWithOptions spec =
    BaseComponent.baseComponent
        { spec
            | options =
                { onContextUpdate = spec.options.onContextUpdate
                , shouldRecalculate = always True
                , lazyRender = False
                }
        }


convertSignal : Self s m p oP -> Signal m p -> Signal oM oP
convertSignal =
    BaseComponent.convertSignal


convertAttribute : Self s m p oP -> Attribute v m p -> Attribute v oM oP
convertAttribute =
    BaseComponent.convertAttribute


convertNode : Self s m p oP -> Node v w m p -> Node v w oM oP
convertNode =
    BaseComponent.convertNode


convertSlot :
    Self s m p oP
    -> Slot (Container pS pM pP) p
    -> Slot (Container pS pM pP) oP
convertSlot =
    BaseComponent.convertSlot


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
