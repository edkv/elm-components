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
