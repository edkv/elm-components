module Components.Internal.Core
    exposing
        ( Attribute(PlainAttribute, Styles)
        , Cache
        , Change
        , Component(Component)
        , ComponentId
        , ComponentState
        , Container(EmptyContainer, SignalContainer, StateContainer)
        , Element
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
        , RenderedComponent(RenderedComponent)
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


type Node v w c m
    = SimpleElement (Element v v w c m)
    | Embedding (Element w w v c m)
    | ReversedEmbedding (Element v w v c m)
    | KeyedSimpleElement (KeyedElement v v w c m)
    | KeyedEmbedding (KeyedElement w w v c m)
    | KeyedReversedEmbedding (KeyedElement v w v c m)
    | Text String
    | PlainNode (VirtualDom.Node (Signal c m))
    | ComponentNode (RenderedComponent c m)


type alias Element x y z c m =
    { tag : String
    , attributes : List (Attribute x c m)
    , children : List (Node y z c m)
    }


type alias KeyedElement x y z c m =
    { tag : String
    , attributes : List (Attribute x c m)
    , children : List ( String, Node y z c m )
    }


type Attribute v c m
    = PlainAttribute (VirtualDom.Property (Signal c m))
    | Styles StylingStrategy (List Css.Style)


type StylingStrategy
    = ClassNameProperty
    | ClassAttribute


type Component v w container c m
    = Component (Slot container c -> Node v w c m)


type alias Slot container c =
    ( c -> container, container -> c -> c )


type Container c m s
    = EmptyContainer
    | StateContainer (ComponentState c m s)
    | SignalContainer (Signal c m)


type alias ComponentState c m s =
    { id : ComponentId
    , localState : s
    , childStates : c
    , cache : Cache c m
    }


type Signal c m
    = LocalMsg m
    | ChildMsg c


type alias Cache c m =
    Dict ComponentId (Dict ComponentId (RenderedComponent c m))


type RenderedComponent c m
    = RenderedComponent
        { identify : { states : c } -> Maybe ComponentId
        , touch : TouchArgs c m -> Change c m
        , update : UpdateArgs c m -> Maybe (Change c m)
        , subscriptions : () -> Sub (Signal c m)
        , view : () -> Html.Styled.Html (Signal c m)
        }


type alias TouchArgs c m =
    { states : c
    , cache : Cache c m
    , freshContainers : c
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias UpdateArgs c m =
    { states : c
    , cache : Cache c m
    , signalContainers : c
    , freshContainers : c
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias Change c m =
    { component : RenderedComponent c m
    , states : c
    , cache : Cache c m
    , cmd : Cmd (Signal c m)
    , signals : List (Signal c m)
    , lastComponentId : ComponentId
    }


type alias ComponentId =
    Int
