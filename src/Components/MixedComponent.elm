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


type alias Spec v w c m s pC pM =
    BaseComponent.Spec v w c m s pC pM


type alias SpecWithOptions v w c m s pC pM =
    BaseComponent.SpecWithOptions v w c m s pC pM


type alias Self c m s pC =
    BaseComponent.Self c m s pC


type alias Options m =
    BaseComponent.Options m


mixedComponent : Spec v w c m s pC pM -> Component v w (Container c m s) pC pM
mixedComponent =
    BaseComponent.baseComponent


mixedComponentWithOptions :
    SpecWithOptions v w c m s pC pM
    -> Component v w (Container c m s) pC pM
mixedComponentWithOptions =
    BaseComponent.baseComponentWithOptions


wrapSignal : Self c m s pC -> Signal c m -> Signal pC pM
wrapSignal =
    BaseComponent.wrapSignal


wrapAttribute : Self c m s pC -> Attribute v c m -> Attribute v pC pM
wrapAttribute =
    BaseComponent.wrapAttribute


wrapNode : Self c m s pC -> Node v w c m -> Node v w pC pM
wrapNode =
    BaseComponent.wrapNode


wrapSlot :
    Self c m s pC
    -> Slot (Container cC cM cS) c
    -> Slot (Container cC cM cS) pC
wrapSlot =
    BaseComponent.wrapSlot


sendToChild : Self c m s pC -> Slot (Container cC cM cS) c -> cM -> Signal pC pM
sendToChild =
    BaseComponent.sendToChild


defaultOptions : Options m
defaultOptions =
    { onContextUpdate = Nothing
    }
