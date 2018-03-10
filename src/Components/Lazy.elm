module Components.Lazy exposing (Container, lazy, lazy2, lazy3, lazy4, lazy5)

import Components exposing (Component, Node)
import Components.Internal.BaseComponent as BaseComponent


type alias Container a =
    Components.Container (State a) Msg ()


type State a
    = State a


type Msg
    = Refresh


lazy : (a -> Node m p) -> a -> Component (Container a) m p
lazy func input =
    BaseComponent.make
        { init = \_ -> ( State input, Cmd.none, [] )
        , update = \_ Refresh _ -> ( State input, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ _ -> func input
        , onContextUpdate = Just Refresh
        , shouldRecalculate = \(State prevInput) -> input /= prevInput
        , lazyRender = True
        , parts = ()
        }


lazy2 :
    (a -> b -> Node m p)
    -> a
    -> b
    -> Component (Container ( a, b )) m p
lazy2 func arg1 arg2 =
    lazy (\( a, b ) -> func a b) ( arg1, arg2 )


lazy3 :
    (a -> b -> c -> Node m p)
    -> a
    -> b
    -> c
    -> Component (Container ( a, b, c )) m p
lazy3 func arg1 arg2 arg3 =
    lazy (\( a, b, c ) -> func a b c) ( arg1, arg2, arg3 )


lazy4 :
    (a -> b -> c -> d -> Node m p)
    -> a
    -> b
    -> c
    -> d
    -> Component (Container ( a, b, c, d )) m p
lazy4 func arg1 arg2 arg3 arg4 =
    lazy (\( a, b, c, d ) -> func a b c d) ( arg1, arg2, arg3, arg4 )


lazy5 :
    (a -> b -> c -> d -> e -> Node m p)
    -> a
    -> b
    -> c
    -> d
    -> e
    -> Component (Container ( a, b, c, d, e )) m p
lazy5 func arg1 arg2 arg3 arg4 arg5 =
    lazy (\( a, b, c, d, e ) -> func a b c d e) ( arg1, arg2, arg3, arg4, arg5 )
