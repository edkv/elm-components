module Components.Internal.Core
    exposing
        ( Attribute(PlainAttribute, Styles)
        , Cache
        , Change
        , Component(Component)
        , ComponentId
        , ComponentState
        , Container(EmptyContainer, SignalContainer, StateContainer)
        , NewComponent(Changed, Same)
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
        , SubscriptionsArgs
        , TouchArgs
        , UpdateArgs
        , ViewArgs
        )

import Css
import Dict exposing (Dict)
import Html.Styled
import VirtualDom


type Node x y c m
    = SimpleElement
        { tag : String
        , attributes : List (Attribute x c m)
        , children : List (Node x y c m)
        }
    | Embedding
        { tag : String
        , attributes : List (Attribute y c m)
        , children : List (Node y x c m)
        }
    | ReversedEmbedding
        { tag : String
        , attributes : List (Attribute x c m)
        , children : List (Node y x c m)
        }
    | KeyedSimpleElement
        { tag : String
        , attributes : List (Attribute x c m)
        , children : List ( String, Node x y c m )
        }
    | KeyedEmbedding
        { tag : String
        , attributes : List (Attribute y c m)
        , children : List ( String, Node y x c m )
        }
    | KeyedReversedEmbedding
        { tag : String
        , attributes : List (Attribute x c m)
        , children : List ( String, Node y x c m )
        }
    | Text String
    | PlainNode (VirtualDom.Node (Signal c m))
    | ComponentNode (RenderedComponent c m)


type Attribute x c m
    = PlainAttribute (VirtualDom.Property (Signal c m))
    | Styles StylingStrategy (List Css.Style)


type StylingStrategy
    = ClassNameProperty
    | ClassAttribute


type Component x y container c m
    = Component (Slot container c -> Node x y c m)


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
        { getId : { states : c } -> Maybe ComponentId
        , touch : TouchArgs c m -> Maybe (Change c m)
        , update : UpdateArgs c m -> Maybe (Change c m)
        , subscriptions : SubscriptionsArgs c m -> Sub (Signal c m)
        , view : ViewArgs c m -> Html.Styled.Html (Signal c m)
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
    , signal : c
    , freshContainers : c
    , lastComponentId : ComponentId
    , namespace : String
    }


type alias Change c m =
    { component : NewComponent c m
    , states : c
    , cache : Cache c m
    , cmd : Cmd (Signal c m)
    , signals : List (Signal c m)
    , lastComponentId : ComponentId
    }


type NewComponent c m
    = Same
    | Changed (RenderedComponent c m)


type alias SubscriptionsArgs c m =
    { states : c
    , cache : Cache c m
    , freshContainers : c
    }


type alias ViewArgs c m =
    { states : c
    , cache : Cache c m
    }


type alias ComponentId =
    Int
