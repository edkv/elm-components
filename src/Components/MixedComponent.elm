module Components.MixedComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , mixedComponent
        , mixedComponentWithOptions
        , sendToChild
        , wrapAttribute
        , wrapNode
        , wrapSignal
        , wrapSlot
        )

import Components exposing (Attribute, Component, Container, Node, Signal, Slot)
import Components.Internal.BaseComponent as BaseComponent


type alias Spec v w s m c pM pC =
    BaseComponent.Spec v w s m c pM pC


type alias SpecWithOptions v w s m c pM pC =
    BaseComponent.SpecWithOptions v w s m c pM pC


type alias Self s m c pC =
    BaseComponent.Self s m c pC


type alias Options m =
    BaseComponent.Options m


mixedComponent : Spec v w s m c pM pC -> Component v w (Container s m c) pM pC
mixedComponent =
    BaseComponent.baseComponent


mixedComponentWithOptions :
    SpecWithOptions v w s m c pM pC
    -> Component v w (Container s m c) pM pC
mixedComponentWithOptions =
    BaseComponent.baseComponentWithOptions


wrapSignal : Self s m c pC -> Signal m c -> Signal pM pC
wrapSignal =
    BaseComponent.wrapSignal


wrapAttribute : Self s m c pC -> Attribute v m c -> Attribute v pM pC
wrapAttribute =
    BaseComponent.wrapAttribute


wrapNode : Self s m c pC -> Node v w m c -> Node v w pM pC
wrapNode =
    BaseComponent.wrapNode


wrapSlot :
    Self s m c pC
    -> Slot (Container cS cM cC) c
    -> Slot (Container cS cM cC) pC
wrapSlot =
    BaseComponent.wrapSlot


sendToChild : Self s m c pC -> Slot (Container cS cM cC) c -> cM -> Signal pM pC
sendToChild =
    BaseComponent.sendToChild


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
