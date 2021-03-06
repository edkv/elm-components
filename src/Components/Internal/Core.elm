module Components.Internal.Core
    exposing
        ( Attribute(NullAttribute, PlainAttribute, Styles)
        , Cache
        , Change
        , Component(Component)
        , ComponentId
        , ComponentInterface(ComponentInterface)
        , ComponentInternalStuff(ComponentInternalStuff)
        , ComponentLocations
        , ComponentState
        , ComponentStatus(NewOrChanged, Unchanged)
        , Container(EmptyContainer, SignalContainer, StateContainer)
        , DestroyArgs
        , Identify
        , Node(ComponentNode, Element, KeyedElement, PlainNode, Text)
        , RenderedComponent
        , Signal(LocalMsg, PartMsg)
        , Slot
        , StylingStrategy(ClassAttribute, ClassNameProperty)
        , TouchArgs
        , UpdateArgs
        )

import Css
import Dict exposing (Dict)
import Html.Styled
import VirtualDom


type Node m p
    = Element String (List (Attribute m p)) (List (Node m p))
    | KeyedElement String (List (Attribute m p)) (List ( String, Node m p ))
    | Text String
    | PlainNode (VirtualDom.Node (Signal m p))
    | ComponentNode (RenderedComponent m p)


type Attribute m p
    = PlainAttribute (VirtualDom.Property (Signal m p))
    | Styles StylingStrategy (List Css.Style)
    | NullAttribute


type StylingStrategy
    = ClassNameProperty
    | ClassAttribute


type Component container m p
    = Component (Slot container p -> RenderedComponent m p)


type alias Slot container p =
    ( p -> container, container -> p -> p )


type Container s m p
    = EmptyContainer
    | StateContainer (ComponentState s m p)
    | SignalContainer (Signal m p)


type alias ComponentState s m p =
    { id : ComponentId
    , localState : s
    , partStates : p
    , cache : Cache m p
    }


type Signal m p
    = LocalMsg m
    | PartMsg (Identify p) p


type alias Identify p =
    { states : p } -> Maybe ComponentId


type alias RenderedComponent m p =
    { status : { states : p } -> ComponentStatus
    , touch : TouchArgs m p -> ( ComponentId, Change m p )
    }


type ComponentStatus
    = NewOrChanged
    | Unchanged ComponentId


type ComponentInterface m p
    = ComponentInterface
        { update : UpdateArgs m p -> Change m p
        , destroy : DestroyArgs m p -> DestroyArgs m p
        , subscriptions : () -> Sub (Signal m p)
        , view : () -> Html.Styled.Html (Signal m p)
        }


type alias TouchArgs m p =
    { states : p
    , cache : Cache m p
    , freshContainers : p
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias UpdateArgs m p =
    { states : p
    , cache : Cache m p
    , signalContainers : p
    , path : List ComponentId
    , maxPossibleTargetId : ComponentId
    , freshContainers : p
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias DestroyArgs m p =
    { states : p
    , cache : Cache m p
    , componentLocations : ComponentLocations
    }


type alias Change m p =
    { component : ComponentInterface m p
    , states : p
    , cache : Cache m p
    , cmd : Cmd (Signal m p)
    , signals : List (Signal m p)
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    , cleanup : DestroyArgs m p -> DestroyArgs m p
    }


type alias Cache m p =
    Dict ComponentId (Dict ComponentId (ComponentInterface m p))


type alias ComponentLocations =
    Dict ComponentId ComponentId


type alias ComponentId =
    Int


type ComponentInternalStuff s m p cP
    = ComponentInternalStuff
        { slot : Slot (Container s m p) cP
        , freshContainers : p
        , freshConsumerContainers : cP
        }
