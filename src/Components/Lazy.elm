module Components.Lazy exposing (Container, lazy, lazy2, lazy3, lazy4, lazy5)

import Components exposing (Component, Node)
import Components.Internal.BaseComponent as BaseComponent


type alias Container a =
    Components.Container (State a) Msg ()


type State a
    = State a


type Msg
    = UpdateInput


lazy : (a -> Node v w m p) -> a -> Component v w (Container a) m p
lazy func input =
    BaseComponent.baseComponent
        { init = \_ -> ( State input, Cmd.none, [] )
        , update = \_ UpdateInput _ -> ( State input, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ _ -> func input
        , onContextUpdate = Just UpdateInput
        , shouldRecalculate = \(State prevInput) -> input /= prevInput
        , lazyRender = True
        , parts = ()
        }


lazy2 :
    (a -> b -> Node v w m p)
    -> a
    -> b
    -> Component v w (Container ( a, b )) m p
lazy2 func arg1 arg2 =
    lazy (\( a, b ) -> func a b) ( arg1, arg2 )


lazy3 :
    (a -> b -> c -> Node v w m p)
    -> a
    -> b
    -> c
    -> Component v w (Container ( a, b, c )) m p
lazy3 func arg1 arg2 arg3 =
    lazy (\( a, b, c ) -> func a b c) ( arg1, arg2, arg3 )


lazy4 :
    (a -> b -> c -> d -> Node v w m p)
    -> a
    -> b
    -> c
    -> d
    -> Component v w (Container ( a, b, c, d )) m p
lazy4 func arg1 arg2 arg3 arg4 =
    lazy (\( a, b, c, d ) -> func a b c d) ( arg1, arg2, arg3, arg4 )


lazy5 :
    (a -> b -> c -> d -> e -> Node v w m p)
    -> a
    -> b
    -> c
    -> d
    -> e
    -> Component v w (Container ( a, b, c, d, e )) m p
lazy5 func arg1 arg2 arg3 arg4 arg5 =
    lazy (\( a, b, c, d, e ) -> func a b c d e) ( arg1, arg2, arg3, arg4, arg5 )
