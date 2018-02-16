module Components.MixedComponent
    exposing
        ( Options
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
        , Container
        , Node
        , Self
        , Signal
        , Slot
        )
import Components.Internal.BaseComponent as BaseComponent


type alias Spec v w s m p pM pP =
    { init : Self s m p pP -> ( s, Cmd m, List (Signal pM pP) )
    , update : Self s m p pP -> m -> s -> ( s, Cmd m, List (Signal pM pP) )
    , subscriptions : Self s m p pP -> s -> Sub m
    , view : Self s m p pP -> s -> Node v w pM pP
    , parts : p
    }


type alias SpecWithOptions v w s m p pM pP =
    { init : Self s m p pP -> ( s, Cmd m, List (Signal pM pP) )
    , update : Self s m p pP -> m -> s -> ( s, Cmd m, List (Signal pM pP) )
    , subscriptions : Self s m p pP -> s -> Sub m
    , view : Self s m p pP -> s -> Node v w pM pP
    , parts : p
    , options : Options m
    }


type alias Options m =
    { onContextUpdate : Maybe m
    }


mixedComponent : Spec v w s m p pM pP -> Component v w (Container s m p) pM pP
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
    SpecWithOptions v w s m p pM pP
    -> Component v w (Container s m p) pM pP
mixedComponentWithOptions spec =
    BaseComponent.baseComponent
        { spec
            | options =
                { onContextUpdate = spec.options.onContextUpdate
                , shouldRecalculate = always True
                , lazyRender = False
                }
        }


convertSignal : Self s m p pP -> Signal m p -> Signal pM pP
convertSignal =
    BaseComponent.convertSignal


convertAttribute : Self s m p pP -> Attribute v m p -> Attribute v pM pP
convertAttribute =
    BaseComponent.convertAttribute


convertNode : Self s m p pP -> Node v w m p -> Node v w pM pP
convertNode =
    BaseComponent.convertNode


convertSlot :
    Self s m p pP
    -> Slot (Container cS cM cP) p
    -> Slot (Container cS cM cP) pP
convertSlot =
    BaseComponent.convertSlot


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
