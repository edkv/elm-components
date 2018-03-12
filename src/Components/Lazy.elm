module Components.Lazy exposing (Container, lazy, lazy2, lazy3, lazy4, lazy5)

{-| The `lazy` functions allow you to skip recalculation of view parts by
checking whether the values they depend on have changed since the last update.

Internally it is implemented as a special kind of
[`Component`](Components#Component) so you need to use it like any other
component:

    import Components exposing (Component, send, slot, x1)
    import Components.Html exposing (Html, button, div, text)
    import Components.Html.Events exposing (onClick)
    import Components.Lazy as Lazy

    type alias Container =
        Components.Container State Msg Parts

    type alias State =
        Int

    type Msg
        = Increment

    type alias Parts =
        { content : Lazy.Container State
        }

    counter : Component Container m p
    counter =
        Components.regular
            { init = \_ -> ( 0, Cmd.none, [] )
            , update = \_ Increment state -> ( state + 1, Cmd.none, [] )
            , subscriptions = \_ _ -> Sub.none
            , view = \_ -> view
            , parts = x1 Parts
            }

    view : State -> Html Msg Parts
    view state =
        Lazy.lazy content state
            |> slot ( .content, \x y -> { y | content = x } )

    content : State -> Html Msg Parts
    content state =
        div []
            [ text (toString state.value)
            , button [ onClick (send Increment) ] [ text "+" ]
            ]

There are some issues/limitations of laziness that you should be aware of:

  - Things that you pass to `lazy` are compared
    [_by value_](http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#==).
    This means that you should be careful when you use laziness with large data
    structures. Also, this means that you can't use it with values that contain
    functions. This includes `Signal`s and `Node`s.
  - Don't use laziness around components directly for now because you can run
    into this bug: <https://github.com/elm-lang/virtual-dom/issues/73>. Wrapping
    them in a `div` should help.
  - Don't change the function you pass to `lazy` dynamically. Consider the
    following:

```
type alias Parts =
    { ...
    , form : Lazy.Container State
    }

view state =
    case state.route of
        RegistrationRoute ->
            Lazy.lazy registrationForm state
                |> slot ( .form, \x y -> { y | form = x } )

        LoginRoute ->
            Lazy.lazy loginForm state
                |> slot ( .form, \x y -> { y | form = x } )

        ...
```

elm-components can't compare functions by reference so it won't be able to
detect the change. Use different slots instead:

    type alias Parts =
        { ...
        , registrationForm : Lazy.Container State
        , loginForm : Lazy.Container State
        }

    view state =
        case state.route of
            RegistrationRoute ->
                Lazy.lazy registrationForm state
                    |> slot ( .registrationForm, \x y -> { y | registrationForm = x } )

            LoginRoute ->
                Lazy.lazy loginForm state
                    |> slot ( .loginForm, \x y -> { y | loginForm = x } )

            ...

  - Don't pass anonymous functions to `lazy` since it's very easy to introduce
    bugs with them for the same reason as above. The `VirtualDom` package is
    able to compare those functions by references so it disables laziness in
    such cases and saves you from silly mistakes. `elm-components` can't do
    this.
  - Currently lazy blocks are cached on the level of the component inside which
    they are rendered (not where they are registered in the `Parts` type). This
    means that if you change the place where they are rendered during the update
    (for example, if you pass it to some `Layout` [`mixed`](Components#mixed)
    component and then move it to `AnotherLayout`), it will be invalidated and
    recalculated.
  - Using `lazy` on a node will prepend a `style` element to its children if you
    [style](Components-Html-Attributes#styles)
    it with
    [`elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest)
    This can break your markup.

@docs Container, lazy, lazy2, lazy3, lazy4, lazy5

-}

import Components exposing (Component, Node)
import Components.Internal.BaseComponent as BaseComponent


{-| Add it to the `Parts` type of your component.

The `a` type variable is the type of the argument that the function you pass
to `lazy` receive. If you use [`lazyN`](#lazy2) functions, group the types of
the arguments in a tuple:

    type alias Parts =
        { lazyBlock : Components.Lazy.Container ( Int, String )
        }

-}
type alias Container a =
    Components.Container (State a) Msg ()


type State a
    = State a


type Msg
    = Refresh


{-| Call it with a function that receives an argument and returns a `Node` to
avoid recalculation of that `Node` on updates unless the argument is changed.
-}
lazy : (a -> Node msg parts) -> a -> Component (Container a) msg parts
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


{-| Same as [`lazy`](#lazy) but for two arguments.
-}
lazy2 :
    (a -> b -> Node msg parts)
    -> a
    -> b
    -> Component (Container ( a, b )) msg parts
lazy2 func arg1 arg2 =
    lazy (\( a, b ) -> func a b) ( arg1, arg2 )


{-| Same as [`lazy`](#lazy) but for three arguments.
-}
lazy3 :
    (a -> b -> c -> Node msg parts)
    -> a
    -> b
    -> c
    -> Component (Container ( a, b, c )) msg parts
lazy3 func arg1 arg2 arg3 =
    lazy (\( a, b, c ) -> func a b c) ( arg1, arg2, arg3 )


{-| Same as [`lazy`](#lazy) but for four arguments.
-}
lazy4 :
    (a -> b -> c -> d -> Node msg parts)
    -> a
    -> b
    -> c
    -> d
    -> Component (Container ( a, b, c, d )) msg parts
lazy4 func arg1 arg2 arg3 arg4 =
    lazy (\( a, b, c, d ) -> func a b c d) ( arg1, arg2, arg3, arg4 )


{-| Same as [`lazy`](#lazy) but for five arguments.
-}
lazy5 :
    (a -> b -> c -> d -> e -> Node msg parts)
    -> a
    -> b
    -> c
    -> d
    -> e
    -> Component (Container ( a, b, c, d, e )) msg parts
lazy5 func arg1 arg2 arg3 arg4 arg5 =
    lazy (\( a, b, c, d, e ) -> func a b c d e) ( arg1, arg2, arg3, arg4, arg5 )
