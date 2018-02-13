module Components.Internal.Core
    exposing
        ( Attribute(PlainAttribute, Styles)
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


type Node v w m c
    = SimpleElement (Element v v w m c)
    | Embedding (Element w w v m c)
    | ReversedEmbedding (Element v w v m c)
    | KeyedSimpleElement (KeyedElement v v w m c)
    | KeyedEmbedding (KeyedElement w w v m c)
    | KeyedReversedEmbedding (KeyedElement v w v m c)
    | Text String
    | PlainNode (VirtualDom.Node (Signal m c))
    | ComponentNode (RenderedComponent m c)


type alias Element x y z m c =
    { tag : String
    , attributes : List (Attribute x m c)
    , children : List (Node y z m c)
    }


type alias KeyedElement x y z m c =
    { tag : String
    , attributes : List (Attribute x m c)
    , children : List ( String, Node y z m c )
    }


type Attribute v m c
    = PlainAttribute (VirtualDom.Property (Signal m c))
    | Styles StylingStrategy (List Css.Style)


type StylingStrategy
    = ClassNameProperty
    | ClassAttribute


type Component v w container m c
    = Component (Slot container c -> Node v w m c)


type alias Slot container c =
    ( c -> container, container -> c -> c )


type Container s m c
    = EmptyContainer
    | StateContainer (ComponentState s m c)
    | SignalContainer (Signal m c)


type alias ComponentState s m c =
    { id : ComponentId
    , localState : s
    , childStates : c
    , cache : Cache m c
    }


type Signal m c
    = LocalMsg m
    | ChildMsg (Identify c) c


type alias Identify c =
    { states : c } -> Maybe ComponentId


type alias RenderedComponent m c =
    { status : { states : c } -> ComponentStatus
    , touch : TouchArgs m c -> ( ComponentId, Change m c )
    }


type ComponentStatus
    = NewOrChanged
    | Unchanged ComponentId


type ComponentInterface m c
    = ComponentInterface
        { update : UpdateArgs m c -> Change m c
        , subscriptions : () -> Sub (Signal m c)
        , view : () -> Html.Styled.Html (Signal m c)
        }


type alias TouchArgs m c =
    { states : c
    , cache : Cache m c
    , freshContainers : c
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias UpdateArgs m c =
    { states : c
    , cache : Cache m c
    , pathToTarget : List ComponentId
    , signalContainers : c
    , freshContainers : c
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias Change m c =
    { component : ComponentInterface m c
    , states : c
    , cache : Cache m c
    , cmd : Cmd (Signal m c)
    , signals : List (Signal m c)
    , componentLocations : ComponentLocations
    , lastComponentId : ComponentId
    }


type alias Cache m c =
    Dict ComponentId (Dict ComponentId (ComponentInterface m c))


type alias ComponentLocations =
    Dict ComponentId ComponentId


type alias ComponentId =
    Int
