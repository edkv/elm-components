module Components.Lazy exposing (Container, lazy, lazy2, lazy3, lazy4, lazy5)

import Components exposing (Component, Node)
import Components.Internal.BaseComponent as BaseComponent


type alias Container a =
    Components.Container (State a) Msg ()


type State a
    = State a


type Msg
    = UpdateInput


lazy : (a -> Node v w m c) -> a -> Component v w (Container a) m c
lazy func input =
    BaseComponent.baseComponent
        { init = \_ -> ( State input, Cmd.none, [] )
        , update = \_ UpdateInput _ -> ( State input, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ _ -> func input
        , children = ()
        , options =
            { onContextUpdate = Just UpdateInput
            , shouldRecalculate = \(State prevInput) -> input /= prevInput
            , lazyRender = True
            }
        }


lazy2 :
    (a -> b -> Node v w m c)
    -> a
    -> b
    -> Component v w (Container ( a, b )) m c
lazy2 func arg1 arg2 =
    lazy (\( a, b ) -> func a b) ( arg1, arg2 )


lazy3 :
    (a -> b -> d -> Node v w m c)
    -> a
    -> b
    -> d
    -> Component v w (Container ( a, b, d )) m c
lazy3 func arg1 arg2 arg3 =
    lazy (\( a, b, d ) -> func a b d) ( arg1, arg2, arg3 )


lazy4 :
    (a -> b -> d -> e -> Node v w m c)
    -> a
    -> b
    -> d
    -> e
    -> Component v w (Container ( a, b, d, e )) m c
lazy4 func arg1 arg2 arg3 arg4 =
    lazy (\( a, b, d, e ) -> func a b d e) ( arg1, arg2, arg3, arg4 )


lazy5 :
    (a -> b -> d -> e -> f -> Node v w m c)
    -> a
    -> b
    -> d
    -> e
    -> f
    -> Component v w (Container ( a, b, d, e, f )) m c
lazy5 func arg1 arg2 arg3 arg4 arg5 =
    lazy (\( a, b, d, e, f ) -> func a b d e f) ( arg1, arg2, arg3, arg4, arg5 )
