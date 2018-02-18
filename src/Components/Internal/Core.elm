module Components.Internal.Core
    exposing
        ( Attribute(NullAttribute, PlainAttribute, Styles)
        , Cache
        , Change
        , Component(Component)
        , ComponentId
        , ComponentInterface(ComponentInterface)
        , ComponentLocations
        , ComponentState
        , ComponentStatus(NewOrChanged, Unchanged)
        , Container(EmptyContainer, SignalContainer, StateContainer)
        , Element
        , Identify
        , KeyedElement
        , Node
            ( ComponentNode
            , Embedding
            , KeyedEmbedding
            , KeyedReversedEmbedding
            , KeyedSimpleElement
            , PlainNode
            , ReversedEmbedding
            , SimpleElement
            , Text
            )
        , RenderedComponent
        , Signal(ChildMsg, LocalMsg)
        , Slot
        , StylingStrategy(ClassAttribute, ClassNameProperty)
        , TouchArgs
        , UpdateArgs
        )

import Css
import Dict exposing (Dict)
import Html.Styled
import VirtualDom


type Node v w m p
    = SimpleElement (Element v v w m p)
    | Embedding (Element w w v m p)
    | ReversedEmbedding (Element v w v m p)
    | KeyedSimpleElement (KeyedElement v v w m p)
    | KeyedEmbedding (KeyedElement w w v m p)
    | KeyedReversedEmbedding (KeyedElement v w v m p)
    | Text String
    | PlainNode (VirtualDom.Node (Signal m p))
    | ComponentNode (RenderedComponent m p)


type alias Element x y z m p =
    { tag : String
    , attributes : List (Attribute x m p)
    , children : List (Node y z m p)
    }


type alias KeyedElement x y z m p =
    { tag : String
    , attributes : List (Attribute x m p)
    , children : List ( String, Node y z m p )
    }


type Attribute v m p
    = PlainAttribute (VirtualDom.Property (Signal m p))
    | Styles StylingStrategy (List Css.Style)
    | NullAttribute


type StylingStrategy
    = ClassNameProperty
    | ClassAttribute


type Component v w container m p
    = Component (Slot container p -> Node v w m p)


type alias Slot container p =
    ( p -> container, container -> p -> p )


type Container s m p
    = EmptyContainer
    | StateContainer (ComponentState s m p)
    | SignalContainer (Signal m p)


type alias ComponentState s m p =
    { id : ComponentId
    , localState : s
    , childStates : p
    , cache : Cache m p
    }


type Signal m p
    = LocalMsg m
    | ChildMsg (Identify p) p


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
    , pathToTarget : List ComponentId
    , signalContainers : p
    , freshContainers : p
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias Change m p =
    { component : ComponentInterface m p
    , states : p
    , cache : Cache m p
    , cmd : Cmd (Signal m p)
    , signals : List (Signal m p)
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    }


type alias Cache m p =
    Dict ComponentId (Dict ComponentId (ComponentInterface m p))


type alias ComponentLocations =
    Dict ComponentId ComponentId


type alias ComponentId =
    Int
