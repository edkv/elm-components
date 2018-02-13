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
        , sendToChild
        )

import Components exposing (Attribute, Component, Container, Node, Signal, Slot)
import Components.Internal.BaseComponent as BaseComponent


type alias Spec v w s m c pM pC =
    { init : Self s m c pC -> ( s, Cmd m, List (Signal pM pC) )
    , update : Self s m c pC -> m -> s -> ( s, Cmd m, List (Signal pM pC) )
    , subscriptions : Self s m c pC -> s -> Sub m
    , view : Self s m c pC -> s -> Node v w pM pC
    , children : c
    }


type alias SpecWithOptions v w s m c pM pC =
    { init : Self s m c pC -> ( s, Cmd m, List (Signal pM pC) )
    , update : Self s m c pC -> m -> s -> ( s, Cmd m, List (Signal pM pC) )
    , subscriptions : Self s m c pC -> s -> Sub m
    , view : Self s m c pC -> s -> Node v w pM pC
    , children : c
    , options : Options m
    }


type alias Self s m c pC =
    { id : String
    , internal : BaseComponent.InternalStuff s m c pC
    }


type alias Options m =
    { onContextUpdate : Maybe m
    }


mixedComponent : Spec v w s m c pM pC -> Component v w (Container s m c) pM pC
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
    SpecWithOptions v w s m c pM pC
    -> Component v w (Container s m c) pM pC
mixedComponentWithOptions spec =
    BaseComponent.baseComponent
        { spec
            | options =
                { onContextUpdate = spec.options.onContextUpdate
                , shouldRecalculate = always True
                , lazyRender = False
                }
        }


convertSignal : Self s m c pC -> Signal m c -> Signal pM pC
convertSignal =
    BaseComponent.convertSignal


convertAttribute : Self s m c pC -> Attribute v m c -> Attribute v pM pC
convertAttribute =
    BaseComponent.convertAttribute


convertNode : Self s m c pC -> Node v w m c -> Node v w pM pC
convertNode =
    BaseComponent.convertNode


convertSlot :
    Self s m c pC
    -> Slot (Container cS cM cC) c
    -> Slot (Container cS cM cC) pC
convertSlot =
    BaseComponent.convertSlot


sendToChild : Self s m c pC -> Slot (Container cS cM cC) c -> cM -> Signal pM pC
sendToChild =
    BaseComponent.sendToChild


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
