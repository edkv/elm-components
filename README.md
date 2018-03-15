# Components in Elm

This package provides an abstraction over TEA (The Elm Architecture) that lets 
you define your UI as a tree of self-contained components.


## Table of Contents

1. [Features](#features)
2. [WARNING](#warning)
3. [Motivation](#motivation)
   - [When you need this library](#when-you-need-this-library)
   - [Components are objects](#components-are-objects)
4. [Diving in](#diving-in)
   - [Defining a component](#defining-a-component)
   - [Embedding components in your app](#embedding-components-in-your-app)
   - [Composition](#composition)
   - [Optional parts](#optional-parts)
   - [Signals and messages](#signals-and-messages)
   - [Communication](#communication)
   - [Passing view blocks to parts](#passing-view-blocks-to-parts)
   - [Listening for updates in surrounding context](#listening-for-updates-in-surrounding-context)
   - [Laziness](#laziness)
5. [What about performance?](#what-about-performance)
6. [Future plans](#future-plans)


## Features

- Each component has its own local state and behaviour.
- Child components are mounted in the `view`. Their `init`, `update` and 
`subscriptions` functions are managed automatically.
- Components are configured through view and the configuration can be accessed
in any of its functions.
- Components are automatically initialized and destroyed when they are added to
the tree or removed from it.
- Flexibility: easily embed view blocks inside child components etc.
- Communication between components.
- Ability to react to changes in component's input parameters.
- Support for
[`rtfeldman/elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest)
(use locally scoped dynamic styles like with
[`Html.Styled`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Html-Styled)).
- Each component has a globally unique ID which you can use for your needs.
- Easy integration with plain TEA code.


## WARNING

- The [official Elm guide says](https://guide.elm-lang.org/reuse/) that you
should build your UI with reusable view functions as much as possible and not to
think in terms of components. See the [Motivation](#motivation) section for the
explanation for when to choose this library over community recommendations.
- `elm-components` puts functions in both the `Model` and the `Msg` of your
application for performance reasons. It will certainly break the import/export
feature of the Elm debugger. It *might* be possible to implement a "debug mode"
in the future, but I can't guarantee it, so if import/export is critical for
your workflow, don't use this package. This also means that you [can't compare
your `Model` for
equality](http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#==),
but only outside components since inside them you don't have access to parts of
the `Model` that contain functions.
- Regardless of anything else, **if you are a beginner, don't use this
package**. It does a lot of magic behind the scenes and will surely hurt you in
the process of mastering Elm and functional programming. Instead, focus on
learning the language and try to build things without `elm-components`.


## Motivation

The general recommendation for working with Elm is to avoid organizing your
UI in a nested manner and instead to scale your `update` and `view` functions
independently. There really aren't many reasons for your view code to be grouped
together with your logic unless you have some "dynamic" (such that requires some
state/behaviour) UI piece which *also* needs to be reusable. Once the need for
such reusable things emerges, some technique for dealing with them is required.

Basically, there are two such techniques:

- The pattern demonstrated in Evan Czaplicki's
[`elm-sortable-table`](https://github.com/evancz/elm-sortable-table) package.
Essentially, it's about building your component around a function which has the
signature like `(State -> msg) -> State -> Html msg`. The first argument is the
thing that is often called `toMsg` and what you do is you send a new state to
the parent on an event directly from your view: `onClick (toMsg newState)`.
The parent is then responsible for replacing the old state of your component
with the new one in its own state. One of the limitations of this approach is 
that it's only suitable for components that don't do any side effects.
- Another option is two give your component its own `State` and `Msg` as well
as `init`/`update`/`view`(/`subscriptions`) functions. This is also sometimes
called "triplets".

I also recommend Richard Feldman's [Scaling Elm
Apps](https://www.youtube.com/watch?v=DoA4Txr4GUs) talk if you haven't seen it.

The important thing about these recommendations is that they imply that
components are not that often needed — most of the time you should be able to
reuse your UI with just view functions and only sometimes you'll need to reach
for one of the patterns listed above. And that's OK! If it's true for the thing
you're building, you probably don't need this package. `elm-components` is quite
a complex thing and it may be better for you to stick to the defaults and write
some extra boilerplate code than depend on it. But what if it's not true?

### When you need this library

Suppose you're working on a project and you need to design a button with the
following requirements:

- The button must have an animation when you click on it and it's complex
enough so that it's not possible to implement it with CSS. You'll need something
like [`mdgriffith/elm-style-animation`](https://github.com/mdgriffith/elm-style-animation).
- At least buttons don't need to do side effects, right? Well, in Chrome, when
you click on a button, it remains focused until you click on something else.
You need to fix this small visual flow. The most straightforward way to achieve
this is to use the
[`Dom.blur`](http://package.elm-lang.org/packages/elm-lang/dom/1.1.1/Dom#blur) 
function every time the button is clicked, so now it's going to produce a `Cmd`
on update (in reality don't forget about keyboard users though).

This means the following:

- The button should have its own `State` and `Msg` types.
- You should explicitly `init` and `update` it every time you use it manually
replacing the state and mapping the `Cmd`.
- You should not forget to call its `subscriptions` function — the compiler
won't help you with this!
- Remember that you need to launch the animation and send the blur command when
the button is clicked, but you also need to notify the component's consumer
about the click. It's impossible to send two messages from the view
simultaneously, so you need a workaround, maybe an OutMsg or something similar.
Perhaps you'll need to split the config of your button into two parts requiring
a message for `onClick` to be passed to `update` and other options to `view`.
All this will make the button's API harder to use and your code more complicated
and error-prone.

Now imagine that you have not only a button but also lots of other small complex
components that you need to compose in a similar way, and they are *everywhere*
in your app. Your codebase will become really hard to work with. And this is
when you can benefit from a more heavy solution like `elm-components`.

### Components are objects

One of the arguments against components you may hear is that components are
objects and because Elm is a functional language it's a bad idea to design your
app around objects. First of all, I agree that components are objects. They sure
are. Components encapsulate state and communicate via messages — this is
essentially object-oriented programming. But OOP is not necessarily bad! It is
certainly overused, but it does have use cases, and one of such use cases is UI
programming. It might not be the best possible way for doing UI in theory, but
it works.

But isn't Elm a functional language? Well, FP is not the opposite of OOP really
(it's rather the opposite of imperative programming) and there is nothing wrong
with these paradigms to be combined if needed. `elm-components` is not the only
existing component-based UI library for a functional language after all — for
example, see
[ReasonReact](https://reasonml.github.io/reason-react/) and
[purescript-halogen](https://github.com/slamdata/purescript-halogen) from which
it gets some inspiration. Another example might be Erlang/Elixir processes,
which are also very similar to objects — they can hold state and communicate
between each other via messages. Also, in my opinion, if you use patterns like
the approach of `elm-sortable-table` or triplets, you are already doing OOP,
just in a less obvious way.


## Diving In

This section will guide you step-by-step through the features of this library.
You can find examples shown here in the `examples` folder of the repository.

### Defining a component

Here is an example of a simple [counter](http://elm-lang.org/examples/buttons)
component:

```elm
module Counter exposing (Container, counter)

import Components exposing (Component, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : Int
    }


type Msg
    = Increment
    | Decrement


type alias Parts =
    ()


counter : Component Container m p
counter =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = ()
        }


init : State
init =
    { value = 0
    }


update : Msg -> State -> State
update msg state =
    case msg of
        Increment ->
            { state | value = state.value + 1 }

        Decrement ->
            { state | value = state.value - 1 }


view : State -> Html Msg Parts
view state =
    div []
        [ button [ onClick (send Decrement) ] [ text "-" ]
        , div [] [ text (toString state.value) ]
        , button [ onClick (send Increment) ] [ text "+" ]
        ]
```

As you can see, the structure of components is very similar to the one that an
Elm program has, with a few differences. Let's explore what's going on here.

```elm
type alias Container =
    Components.Container State Msg Parts
```

Each component should define and expose a `Container` type which is needed for
its consumers to use that component. The type `Parts` is used to register child
components. It's not called `Children` because a part is not necessary a child,
meaning that it can be passed to other components and therefore rendered in
another place (and also because it's shorter). Our `Counter` doesn't have any
parts so it's just an alias for the unit type.

```elm
counter : Component Container m p
```

This can be read as the following: a counter is a component which defines a
container of type `Container` and can be embedded in any other component that
has a `Msg` of type `m` and parts of type `p`.

```elm
Components.regular
    { init = \_ -> ( init, Cmd.none, [] )
    , update = \_ msg state -> ( update msg state, Cmd.none, [] )
    , subscriptions = \_ _ -> Sub.none
    , view = \_ -> view
    , parts = ()
    }
```

Our counter is a `regular` component which just means that it can't render view
blocks passed to it from its parent. You can also see that each of the functions
that we pass to `regular` receives an extra argument. It's called `Self`, but
let's ignore it for now. Additionally, `init` and `update` functions return a
three-element tuple. The third element is a list of messages sent to other
components. We also need to explicitly declare parts here — you'll see how it's
done once we have some.

```elm
view : State -> Html Msg Parts
```

`elm-components` exposes its own `Html` and `Svg` modules. Unlike the one from
the official package, the `Html` type has two type variables. Here we say that
our component's view is `Html` that can produce messages of type `Msg` and
contain components which are described by the type `Parts`.

```elm
onClick (send Decrement)
```

Notice that you also need to `send` a message. You'll see why it's necessary
later.

### Embedding components in your app

The `Components` module exposes functions that you can use to embed any
component in any part of your app. Here is how you can play with our `Counter`:

```elm
module Main exposing (main)

import Components
import Counter
import VirtualDom


type alias State =
    { counterState : Components.State Counter.Container Never
    }


type Msg
    = CounterMsg (Components.Msg Counter.Container Never)


main : Program Never State Msg
main =
    VirtualDom.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( State, Cmd Msg )
init =
    let
        ( counterState, counterCmd ) =
            Components.init Counter.counter
    in
    ( { counterState = counterState
      }
    , Cmd.map CounterMsg counterCmd
    )


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        CounterMsg counterMsg ->
            let
                ( newCounterState, counterCmd, _ ) =
                    Components.update counterMsg state.counterState
            in
            ( { state | counterState = newCounterState }
            , Cmd.map CounterMsg counterCmd
            )


subscriptions : State -> Sub Msg
subscriptions state =
    Components.subscriptions state.counterState
        |> Sub.map CounterMsg


view : State -> VirtualDom.Node Msg
view state =
    Components.view state.counterState
        |> VirtualDom.map CounterMsg
```

This all should look very familiar to you. The `Never` in the definitions of
`counterState` and `CounterMsg` means that the component doesn't send any
messages to its surrounding context. If it does, they are returned from the
`Components.update` function. You can see how we ignore them here:

```elm
-- The third element is a `List Never`.
( newCounterState, counterCmd, _ ) =
    Components.update counterMsg state.counterState
```

You need the `elm-lang/virtual-dom` package to run the example above (or you can
use `elm-lang/html` instead). `elm-components` intentionally doesn't expose its
own `program` function. `VirtualDom.program` is going to live in 
[`elm-lang/browser`](https://github.com/elm-lang/browser) in 0.19 and
`elm-components` shouldn't depend on it or make any assumptions about how and in
which environment you use it. 

It's also possible to use views built with the official packages inside
components with the help of the
[`Html.plain`](http://package.elm-lang.org/packages/edkv/elm-components/latest/Components-Html#plain)
function. Given all that, you can easily embed components in any part of your
project, or you can do it the other way around. For example, if you decide to
rewrite your app with `elm-components`, it can be done from top to bottom.
First, convert your top-level module to be a component. Then convert your pages.
While you're doing it, the rest of your app should just continue to work without
modifications.

### Composition

Let's take a look at something more interesting now: composing multiple
components together. While we are at it, let's also learn how to pass
configuration to components and how to style them. We'll begin with an updated
example of our `Counter`:

```elm
module Counter exposing (Config, Container, counter)

import Components exposing (Component, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (css)
import Components.Html.Events exposing (onClick)
import Css exposing (padding, px)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : Int
    }


type Msg
    = Increment
    | Decrement


type alias Parts =
    ()


type alias Config =
    { initialValue : Int
    , step : Int
    }


counter : Config -> Component Container m p
counter config =
    Components.regular
        { init = \_ -> ( init config, Cmd.none, [] )
        , update = \_ msg state -> ( update config msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = ()
        }


init : Config -> State
init config =
    { value = config.initialValue
    }


update : Config -> Msg -> State -> State
update config msg state =
    case msg of
        Increment ->
            { state | value = state.value + config.step }

        Decrement ->
            { state | value = state.value - config.step }


view : State -> Html Msg Parts
view state =
    div [ css [ padding (px 10) ] ]
        [ button [ onClick (send Decrement) ] [ text "-" ]
        , div [] [ text (toString state.value) ]
        , button [ onClick (send Increment) ] [ text "+" ]
        ]
```

As you can see, there is nothing special about configuration. The `Config`
record is passed to the `counter` function and then down to `init` and
`update`. As for the styling, it's done via the 
[`rtfeldman/elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest)
package, so you need to install it to run the example. See its documentation
for more info. 

And now the composition. Here is an example of a component that renders two
counters:

```elm
module App exposing (Container, app)

import Components exposing (Component, slot, x2)
import Components.Html exposing (Html, div)
import Counter


type alias Container =
    Components.Container State Msg Parts


type alias State =
    ()


type alias Msg =
    Never


type alias Parts =
    { firstCounter : Counter.Container
    , secondCounter : Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( (), Cmd.none, [] )
        , update = \_ msg _ -> never msg
        , subscriptions = \_ _ -> Sub.none
        , view = \_ _ -> view
        , parts = x2 Parts
        }


view : Html Msg Parts
view =
    div []
        [ firstCounter
        , secondCounter
        ]


firstCounter : Html Msg Parts
firstCounter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot ( .firstCounter, \x y -> { y | firstCounter = x } )


secondCounter : Html Msg Parts
secondCounter =
    Counter.counter
        { initialValue = 100
        , step = 10
        }
        |> slot ( .secondCounter, \x y -> { y | secondCounter = x } )
```

We first need to add our counters to the `Parts` type:

```elm
type alias Parts =
    { firstCounter : Counter.Container
    , secondCounter : Counter.Container
    }
```

You may be disappointed that this isn't handled automatically, but there are a
couple of reasons for it to be done this way:
- It's not possible to do it implicitly due to the Elm's type system.
- You'll need a way to refer to your parts somehow if you want to send any
messages to them, so it's useful.
- It's necessary to give some kind of ids to the components you render anyway.
Imagine that you have a list of components. If you change their order,
`elm-components` needs a way to map each component to its state on view
recalculation. This is similar to why you're using `Html.Keyed` around stateful
DOM elements to prevent the Virtual DOM algorithm from messing them up.

The library also needs a constructed `Parts` record populated with some default
values. There is no way for it to be created automatically, so we need to do it
manually:

```elm
, parts = x2 Parts
```

`elm-components` provides `x1`-`x50` helpers for this purpose where
the number is how many parts your component has. If you ever need more you can
combine them (as an example, `x50 >> x1` will give you an equivalent of `x51`). 

Finally, we can render our parts by converting them to `Html` with the help of
the `slot` function by giving it a tuple of functions that define a strategy for
reading and writing a part from/to our `Parts`:

```elm
Counter.counter
    { initialValue = 0
    , step = 1
    }
    |> slot ( .firstCounter, \x y -> { y | firstCounter = x } )
```

This looks a bit ugly but it's necessary. Let's hope that someday we'll get a
special syntax for that thing in Elm (or maybe a macro system) so that it'll
look something like `&firstCounter`. For now, you can extract it into a separate
function if you prefer (there is a
[`Slot`](http://package.elm-lang.org/packages/edkv/elm-components/latest/Components#Slot)
alias for that tuple), but it actually looks okay once you are accustomed to it.
Also, be sure to write it properly (not like 
`( .firstCounter, \x y -> { y | secondCounter = x } )`) and don't ever render
the same part more than one time, or you'll break your UI! Maybe the latter can
be made to be safer in the future.

The coolest thing is that adding or removing parts doesn't require any changes
to the `State`, `Msg`, `init`/`update`/`subscriptions` and API of our component.
Also, it's completely valid for our `App` to have its own behaviour, but for now
it has an empty state and doesn't produce any messages.

It's also possible to have a `Dict` of components:

```elm
module App exposing (Container, app)

import Components exposing (Component, Slot, dictSlot, slot, x2)
import Components.Html exposing (Html, div)
import Counter
import Dict exposing (Dict)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    ()


type alias Msg =
    Never


type alias Parts =
    { firstCounter : Counter.Container
    , secondCounter : Counter.Container
    , counterDict : Dict Int Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( (), Cmd.none, [] )
        , update = \_ msg _ -> never msg
        , subscriptions = \_ _ -> Sub.none
        , view = \_ _ -> view
        , parts = x2 Parts <| Dict.empty
        }


view : Html Msg Parts
view =
    div []
        [ firstCounter
        , secondCounter
        , counterFromDict 0
        , counterFromDict 1
        ]


firstCounter : Html Msg Parts
firstCounter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot ( .firstCounter, \x y -> { y | firstCounter = x } )


secondCounter : Html Msg Parts
secondCounter =
    Counter.counter
        { initialValue = 100
        , step = 10
        }
        |> slot ( .secondCounter, \x y -> { y | secondCounter = x } )


counterFromDict : Int -> Html Msg Parts
counterFromDict key =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot (dictSlot counterDictSlot key)


counterDictSlot : Slot (Dict Int Counter.Container) Parts
counterDictSlot =
    ( .counterDict, \x y -> { y | counterDict = x } )
```

### Optional parts

Suppose you need to add a component that should be displayed only under certain
conditions. It's easy:

```elm
module App exposing (Container, app)

import Components exposing (Component, send, slot, x3)
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)
import Counter


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isThirdCounterVisible : Bool
    }


type Msg
    = ToggleThirdCounter


type alias Parts =
    { firstCounter : Counter.Container
    , secondCounter : Counter.Container
    , thirdCounter : Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x3 Parts
        }


init : State
init =
    { isThirdCounterVisible = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ToggleThirdCounter ->
            { state | isThirdCounterVisible = not state.isThirdCounterVisible }


view : State -> Html Msg Parts
view state =
    div []
        [ firstCounter
        , secondCounter
        , maybeThirdCounter state
        , toggleButton
        ]


firstCounter : Html Msg Parts
firstCounter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot ( .firstCounter, \x y -> { y | firstCounter = x } )


secondCounter : Html Msg Parts
secondCounter =
    Counter.counter
        { initialValue = 100
        , step = 10
        }
        |> slot ( .secondCounter, \x y -> { y | secondCounter = x } )


maybeThirdCounter : State -> Html Msg Parts
maybeThirdCounter state =
    if state.isThirdCounterVisible then
        Counter.counter
            { initialValue = 0
            , step = 1
            }
            |> slot ( .thirdCounter, \x y -> { y | thirdCounter = x } )
    else
        Html.none


toggleButton : Html Msg Parts
toggleButton =
    button [ onClick (send ToggleThirdCounter) ]
        [ text "Toggle third counter"
        ]
```

The third counter is automatically reseted when you re-add it to the tree which
makes your code more declarative. But what if you want to just hide it instead
of destroying? The rules are simple — if a component is not in the tree, it
doesn't exist. If you want it to be hidden, use CSS (or a 
[`hidden`](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/hidden)
attribute).

### Signals and messages

`elm-components` has a thing called `Signal`. It has nothing to do with the
concept of `Signal` that Elm had before 0.17. I'm sorry for reintroducing that
term, and if someone thinks that it's harmful and has an idea for a better name,
I'm open to renaming it!

Basically, a `Signal` represents a message that has been "sent" either to a
component or to one of its `Parts`. Remember how we do things like
`send Increment` in views? The function `send` has the following signature:

```elm
send : msg -> Signal msg parts
```

Signals are used in views and for communication between components. This is what
your return as a third element of a tuple from your `init` and `update`
functions.  The reason they exist is simple — to provide a way to convert
messages from types of one component to types of another one and therefore lift
them up the component tree. It should all become clear once you see examples in
the following sections.

### Communication

There are two types of communication:
- Sending messages to component's ancestors.
- Sending messages to component's parts. This should rarely be needed because
just passing data to parts directly from the view should be enough most of the
time, but it can be useful sometimes.

The following demonstrates a reusable alert dialog component with animated
background which sends a message to its consumer when it's closed. It uses the
[`mdgriffith/elm-style-animation`](https://github.com/mdgriffith/elm-style-animation)
package for animation.

```elm
module Alert exposing (Config, Container, alert)

import Animation
import Components exposing (Component, Signal, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Attributes as Attributes exposing (css)
import Components.Html.Events exposing (onClick)
import Css


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { backgroundAnimation : Animation.State
    }


type Msg
    = AnimateBackground Animation.Msg
    | Closed


type alias Parts =
    ()


type alias Config m p =
    { text : String
    , onClose : Signal m p
    }


alert : Config m p -> Component Container m p
alert config =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ -> update config
        , subscriptions = \_ -> subscriptions
        , view = \_ -> view config
        , parts = ()
        }


init : State
init =
    { backgroundAnimation =
        Animation.style [ Animation.opacity 0 ]
            |> Animation.interrupt
                [ Animation.to [ Animation.opacity 1 ]
                ]
    }


update : Config m p -> Msg -> State -> ( State, Cmd Msg, List (Signal m p) )
update config msg state =
    case msg of
        AnimateBackground animationMsg ->
            let
                updatedAnimation =
                    Animation.update animationMsg state.backgroundAnimation
            in
            ( { state | backgroundAnimation = updatedAnimation }
            , Cmd.none
            , []
            )

        Closed ->
            ( state
            , Cmd.none
            , [ config.onClose ]
            )


subscriptions : State -> Sub Msg
subscriptions state =
    Animation.subscription AnimateBackground [ state.backgroundAnimation ]


view : Config m p -> State -> Html Msg Parts
view config state =
    div [ css rootStyles ]
        [ background state
        , div [ css boxStyles ]
            [ div []
                [ text config.text
                ]
            , button [ css closeButtonStyles, onClick (send Closed) ]
                [ text "Close"
                ]
            ]
        ]


background : State -> Html Msg Parts
background state =
    let
        attributes =
            [ css backgroundStyles
            , onClick (send Closed)
            ]

        animation =
            state.backgroundAnimation
                |> Animation.render
                |> List.map Attributes.plain
    in
    div (attributes ++ animation) []


rootStyles : List Css.Style
rootStyles =
    [ Css.position Css.fixed
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    ]


boxStyles : List Css.Style
boxStyles =
    [ Css.position Css.absolute
    , Css.top (Css.px 50)
    , Css.left (Css.pct 50)
    , Css.transform (Css.translateX (Css.pct -50))
    , Css.padding (Css.px 15)
    , Css.minWidth (Css.px 80)
    , Css.textAlign Css.center
    , Css.backgroundColor (Css.rgb 255 255 255)
    , Css.boxShadow4 Css.zero (Css.px 7) (Css.px 20) (Css.rgba 0 0 0 0.3)
    ]


closeButtonStyles : List Css.Style
closeButtonStyles =
    [ Css.display Css.inlineBlock
    , Css.marginTop (Css.px 15)
    ]


backgroundStyles : List Css.Style
backgroundStyles =
    [ Css.position Css.absolute
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    , Css.backgroundColor (Css.rgba 0 0 0 0.6)
    ]
```

The key part here is that it receives a `Signal` from its consumer:

```elm
type alias Config m p =
    { text : String
    , onClose : Signal m p
    }
```

Which it then returns from its `update` function to notify the consumer about
the close event:

```elm
Closed ->
    ( state
    , Cmd.none
    , [ config.onClose ]
    )
```

And here is how to use it:

```elm
module App exposing (Container, app)

import Alert
import Components exposing (Component, send, slot, x1)
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isAlertVisible : Bool
    }


type Msg
    = ShowAlert
    | HideAlert


type alias Parts =
    { alert : Alert.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x1 Parts
        }


init : State
init =
    { isAlertVisible = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ShowAlert ->
            { state | isAlertVisible = True }

        HideAlert ->
            { state | isAlertVisible = False }


view : State -> Html Msg Parts
view state =
    div []
        [ alertButton
        , maybeAlert state
        ]


alertButton : Html Msg Parts
alertButton =
    button [ onClick (send ShowAlert) ]
        [ text "Show alert"
        ]


maybeAlert : State -> Html Msg Parts
maybeAlert state =
    if state.isAlertVisible then
        Alert.alert
            { text = "Alert!"
            , onClose = send HideAlert
            }
            |> slot ( .alert, \x y -> { y | alert = x } )
    else
        Html.none
```

Now let's look at communication with parts. We are going to enhance our
`Counter` to support reset functionality:

```elm
module Counter exposing (Config, Container, Msg, counter, reset)

import Components exposing (Component, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (css)
import Components.Html.Events exposing (onClick)
import Css exposing (padding, px)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : Int
    }


type Msg
    = Increment
    | Decrement
    | Reset


type alias Parts =
    ()


type alias Config =
    { initialValue : Int
    , step : Int
    }


counter : Config -> Component Container m p
counter config =
    Components.regular
        { init = \_ -> ( init config, Cmd.none, [] )
        , update = \_ msg state -> ( update config msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = ()
        }


reset : Msg
reset =
    Reset


init : Config -> State
init config =
    { value = config.initialValue
    }


update : Config -> Msg -> State -> State
update config msg state =
    case msg of
        Increment ->
            { state | value = state.value + config.step }

        Decrement ->
            { state | value = state.value - config.step }

        Reset ->
            { state | value = config.initialValue }


view : State -> Html Msg Parts
view state =
    div [ css [ padding (px 10) ] ]
        [ button [ onClick (send Decrement) ] [ text "-" ]
        , div [] [ text (toString state.value) ]
        , button [ onClick (send Increment) ] [ text "+" ]
        ]
```

We are adding the `Reset` message and exposing it to users of our module:

```elm
type Msg
    = Increment
    | Decrement
    | Reset
```
```elm
Reset ->
    { state | value = config.initialValue }
```
```elm
reset : Msg
reset =
    Reset
```

Also, it's finally time to learn what the `Self` is. Remember that extra
argument that your component's functions receive? It's a data structure that has
two purposes:
- It provides some useful information about your component. For now, it's just
an `id` field which is a string of the form
`_06f8786c-fd3f-4057-ada2-9561883241db_9`. You can use it for things like HTML
`id` attributes or CSS classes. It consists of an UUID and a sequential number.
The UUID is the same for all components in the same tree.
- It holds some internal data which is used by some functions of the library,
like `sendToPart` in the example below.

Let's add the `Counter` to our `App`:

```elm
module App exposing (Container, app)

import Alert
import Components exposing (Component, Signal, Slot, send, sendToPart, slot, x2)
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (id)
import Components.Html.Events exposing (onClick)
import Counter


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isAlertVisible : Bool
    }


type Msg
    = ShowAlert
    | HideAlert
    | ResetCounter


type alias Parts =
    { alert : Alert.Container
    , counter : Counter.Container
    }


type alias Self p =
    Components.Self State Msg Parts p


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = update
        , subscriptions = \_ _ -> Sub.none
        , view = view
        , parts = x2 Parts
        }


init : State
init =
    { isAlertVisible = False
    }


update : Self p -> Msg -> State -> ( State, Cmd Msg, List (Signal m p) )
update self msg state =
    case msg of
        ShowAlert ->
            ( { state | isAlertVisible = True }
            , Cmd.none
            , []
            )

        HideAlert ->
            ( { state | isAlertVisible = False }
            , Cmd.none
            , []
            )

        ResetCounter ->
            ( state
            , Cmd.none
            , [ sendToPart self counterSlot Counter.reset ]
            )


view : Self p -> State -> Html Msg Parts
view self state =
    div [ id self.id ]
        [ counter
        , alertButton
        , counterResetButton
        , maybeAlert state
        ]


counter : Html Msg Parts
counter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot counterSlot


alertButton : Html Msg Parts
alertButton =
    button [ onClick (send ShowAlert) ]
        [ text "Show alert"
        ]


counterResetButton : Html Msg Parts
counterResetButton =
    button [ onClick (send ResetCounter) ]
        [ text "Reset counter"
        ]


maybeAlert : State -> Html Msg Parts
maybeAlert state =
    if state.isAlertVisible then
        Alert.alert
            { text = "Alert!"
            , onClose = send HideAlert
            }
            |> slot ( .alert, \x y -> { y | alert = x } )
    else
        Html.none


counterSlot : Slot Counter.Container Parts
counterSlot =
    ( .counter, \x y -> { y | counter = x } )
```

We first need to import some extra stuff:

```elm
import Components exposing (Component, Signal, Slot, send, sendToPart, slot, x2)
```

Then to add a message to reset the counter:

```elm
type Msg
    = ShowAlert
    | HideAlert
    | ResetCounter
```

We are also making an alias for the `Self` type to make it shorter:

```elm
type alias Self p =
    Components.Self State Msg Parts p
```

Finally, we need to handle our new message:

```elm
ResetCounter ->
    ( state
    , Cmd.none
    , [ sendToPart self counterSlot Counter.reset ]
    )
```

Given the `counterSlot` and the `self`, the `sendToPart` function now has all
necessary data to transform `Counter.Msg` into `Signal m p` which we then return
from our `update` function.

Notice that we've also rendered the `id` of our `App`. Check it out with your
inspector!

A few more things:
- It's important to understand that communication between components happens in
a single frame. This means that the view won't be re-rendered until all
communication is completed.
- You can also "send" messages to your components from your plain TEA code. Use
the
[`Components.wrapMsg`](http://package.elm-lang.org/packages/edkv/elm-components/latest/Components#wrapMsg)
function (for example, `Components.wrapMsg Counter.reset`) and then feed the
result into `Components.update`.
- `elm-components` gives you a powerful mechanism for inter-component
communication, but when combined with the local state feature, it's also easy to
abuse it. Don't forget about the "Single source of truth" principle! Avoid state
synchronization between components — move such state to a common ancestor and
pass down as config instead.

### Passing view blocks to parts

Let's say you need to build a `Dialog` component that must accept some arbitrary
`Html` from its consumer and render it inside itself. `elm-components` provides
a `Components.mixed` function for that purpose. A `mixed` component differs from
the `regular` one only in that its view returns `Html m p` instead of
`Html Msg Parts`, meaning that the view is parametrized on types of its
consumer. So you can just accept some `Html m p` as a parameter and then return
it from the view. There are also a couple of simple functions that let you
easily combine views of different types:
- `convertNode` which converts `Html Msg Parts` to
`Html consumerMsg consumerParts`.
- `convertSignal` which converts `Signal Msg Parts` to
`Signal consumerMsg consumerParts`.

Our `Dialog` is also going to have the following features to demonstrate the
usage of the functions listed above:
- A button to hide/show its contents.
- The dialog's background will be darkened when you move mouse over its contents.

```elm
module Dialog exposing (Config, Container, dialog)

import Components exposing (Component, Signal, convertNode, convertSignal, send)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (css)
import Components.Html.Events exposing (onClick, onMouseOut, onMouseOver)
import Css


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isShowingContents : Bool
    , isBackgroundDark : Bool
    }


type Msg
    = ToggleContents
    | DarkenBackground
    | LightenBackground


type alias Parts =
    ()


type alias Self p =
    Components.Self State Msg Parts p


type alias Config m p =
    { onClose : Signal m p
    }


dialog : Config m p -> List (Html m p) -> Component Container m p
dialog config contents =
    Components.mixed
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = view config contents
        , parts = ()
        }


init : State
init =
    { isShowingContents = True
    , isBackgroundDark = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ToggleContents ->
            { state | isShowingContents = not state.isShowingContents }

        DarkenBackground ->
            { state | isBackgroundDark = True }

        LightenBackground ->
            { state | isBackgroundDark = False }


view : Config m p -> List (Html m p) -> Self p -> State -> Html m p
view config contents self state =
    div [ css rootStyles ]
        [ background config state
        , box config contents self state
        ]


background : Config m p -> State -> Html m p
background config state =
    div
        [ css (backgroundStyles state)
        , onClick config.onClose
        ]
        []


box : Config m p -> List (Html m p) -> Self p -> State -> Html m p
box config contents self state =
    div
        [ css boxStyles
        , onMouseOver (send DarkenBackground |> convertSignal self)
        , onMouseOut (send LightenBackground |> convertSignal self)
        ]
        [ maybeContents contents state
        , buttons config self
        ]


maybeContents : List (Html m p) -> State -> Html m p
maybeContents contents state =
    div [] <|
        if state.isShowingContents then
            contents
        else
            []


buttons : Config m p -> Self p -> Html m p
buttons config self =
    div [ css buttonsWrapperStyles ]
        [ toggleButton self
        , closeButton config
        ]


toggleButton : Self p -> Html m p
toggleButton self =
    button [ onClick (send ToggleContents) ]
        [ text "Toggle contents"
        ]
        |> convertNode self


closeButton : Config m p -> Html m p
closeButton config =
    button [ onClick config.onClose ]
        [ text "Close"
        ]


rootStyles : List Css.Style
rootStyles =
    [ Css.position Css.fixed
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    ]


boxStyles : List Css.Style
boxStyles =
    [ Css.position Css.absolute
    , Css.top (Css.px 50)
    , Css.left (Css.pct 50)
    , Css.transform (Css.translateX (Css.pct -50))
    , Css.padding (Css.px 15)
    , Css.minWidth (Css.px 80)
    , Css.textAlign Css.center
    , Css.backgroundColor (Css.rgb 255 255 255)
    , Css.boxShadow4 Css.zero (Css.px 7) (Css.px 20) (Css.rgba 0 0 0 0.3)
    ]


buttonsWrapperStyles : List Css.Style
buttonsWrapperStyles =
    [ Css.display Css.inlineBlock
    , Css.marginTop (Css.px 15)
    ]


backgroundStyles : State -> List Css.Style
backgroundStyles state =
    let
        opacity =
            if state.isBackgroundDark then
                0.6
            else
                0.4
    in
    [ Css.position Css.absolute
    , Css.top Css.zero
    , Css.left Css.zero
    , Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    , Css.backgroundColor (Css.rgb 0 0 0)
    , Css.opacity (Css.num opacity)
    , Css.property "transition" "opacity 400ms"
    ]
```

Notice how we can easily embed local view blocks by converting them to
`Html m p`:

```elm
button [ onClick (send ToggleContents) ]
    [ text "Toggle contents"
    ]
    |> convertNode self
```

In fact, the `regular` component is implemented on top of a `mixed` one by
simply applying the `convertNode` function to its entire view.

It's also easy to send messages to our component from `Html m p` with the help
of the `convertSignal` function:

```elm
div
    [ css boxStyles
    , onMouseOver (send DarkenBackground |> convertSignal self)
    , onMouseOut (send LightenBackground |> convertSignal self)
    ]
    [ maybeContents contents state
    , buttons config self
    ]
```

You can finally see the real reason why the `Signal` type exists at all. If we
were passing around messages instead, it wouldn't be possible to achieve things
like this since there is no way to convert `Msg` to `m` (consumer's `Msg`).

The last interesting bit here is that we can deliver signals to the consumer
directly from the view instead of returning them from the `update` function:

```elm
closeButton : Config m p -> Html m p
closeButton config =
    button [ onClick config.onClose ]
        [ text "Close"
        ]
```

Now let's render our `Dialog` with a `Counter` inside it:

```elm
module App exposing (Container, app)

import Components exposing (Component, send, slot, x2)
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)
import Counter
import Dialog


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { isDialogVisible : Bool
    }


type Msg
    = ShowDialog
    | HideDialog


type alias Parts =
    { dialog : Dialog.Container
    , counter : Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x2 Parts
        }


init : State
init =
    { isDialogVisible = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ShowDialog ->
            { state | isDialogVisible = True }

        HideDialog ->
            { state | isDialogVisible = False }


view : State -> Html Msg Parts
view state =
    div []
        [ showDialogButton
        , maybeDialog state
        ]


showDialogButton : Html Msg Parts
showDialogButton =
    button [ onClick (send ShowDialog) ]
        [ text "Show dialog"
        ]


maybeDialog : State -> Html Msg Parts
maybeDialog state =
    if state.isDialogVisible then
        Dialog.dialog
            { onClose = send HideDialog
            }
            [ counter
            ]
            |> slot ( .dialog, \x y -> { y | dialog = x } )
    else
        Html.none


counter : Html Msg Parts
counter =
    Counter.counter
        { initialValue = 0
        , step = 1
        }
        |> slot ( .counter, \x y -> { y | counter = x } )
```

There is one more case we haven't talked about: what if you need a component to
accept some `Html` from its consumer and pass it further down the tree to one of
its parts? Let's try to build a `DialogWithConfirmation` component on top of our
`Dialog` and see if it works:

```elm
module DialogWithConfirmation exposing (Config, Container, dialog)

import Components
    exposing
        ( Component
        , Signal
        , convertNode
        , convertSignal
        , send
        , slot
        , x1
        )
import Components.Html as Html exposing (Html, button, div, text)
import Components.Html.Attributes exposing (hidden)
import Components.Html.Events exposing (onClick)
import Dialog


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { waitingForConfirmation : Bool
    }


type Msg
    = ShowConfirmation
    | HideConfirmation


type alias Parts =
    { dialog : Dialog.Container
    }


type alias Self p =
    Components.Self State Msg Parts p


type alias Config m p =
    { onClose : Signal m p
    }


dialog : Config m p -> List (Html m p) -> Component Container m p
dialog config contents =
    Components.mixed
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = view config contents
        , parts = x1 Parts
        }


init : State
init =
    { waitingForConfirmation = False
    }


update : Msg -> State -> State
update msg state =
    case msg of
        ShowConfirmation ->
            { state | waitingForConfirmation = True }

        HideConfirmation ->
            { state | waitingForConfirmation = False }


view : Config m p -> List (Html m p) -> Self p -> State -> Html m p
view config contents self state =
    Dialog.dialog
        { onClose = send ShowConfirmation |> convertSignal self
        }
        [ div [ hidden state.waitingForConfirmation ] contents
        , maybeConfirmation config self state
        ]
        |> slot ( .dialog, \x y -> { y | dialog = x } )


maybeConfirmation : Config m p -> Self p -> State -> Html m p
maybeConfirmation config self state =
    if state.waitingForConfirmation then
        div []
            [ div []
                [ text "Close the dialog?"
                ]
            , button [ onClick (send HideConfirmation) ]
                [ text "No"
                ]
                |> convertNode self
            , button [ onClick config.onClose ]
                [ text "Yes"
                ]
            ]
    else
        Html.none
```

Now if you try to compile it, you'll get a hard-to-understand error from your
compiler. The reason is that when you pass `contents`
(which is `List (Html m p)`) to the `Dialog.dialog` function, the `Dialog` is
now itself expected to be converted to `Html m p`. But when you use your `slot`
function with the `.dialog` slot of your local `Parts`, you're trying to convert
it to `Html Msg Parts` instead! Fear not, it's still possible to achieve what we
want. There is one more function called `convertSlot` which exists for this
particular case:

```elm
import Components
    exposing
        ( ...
        , Slot
        , convertSlot
        )

...

view : Config m p -> List (Html m p) -> Self p -> State -> Html m p
view config contents self state =
    Dialog.dialog
        { onClose = send ShowConfirmation |> convertSignal self
        }
        [ div [ hidden state.waitingForConfirmation ] contents
        , maybeConfirmation config self state
        ]
        |> slot (convertSlot self dialogSlot)


dialogSlot : Slot Dialog.Container Parts
dialogSlot =
    ( .dialog, \x y -> { y | dialog = x } )
```

What it does is it converts `Slot Dialog.Container Parts` into
`Slot Dialog.Container p` making the `Dialog` to behave like if it was
registered in consumer's `Parts`, though it's really registered in `Parts` of
`DialogWithConfirmation`. 

It all might sound a bit overwhelming, but it's not that hard once you develop
some intuition! 

### Listening for updates in surrounding context

`elm-components` gives you a way to receive a message each time input parameters
of a component *may* have changed. This can be useful when you can't
synchronously calculate your view from the value of a parameter and want, for
example, to perform an HTTP request or a call to a port when it changes, or when
you need to know both its previous and its current values.

The following example demonstrates a `Colorbox` component which displays a
string of text passed to it as an argument and sequentially changes its color
theme from the list of available themes whenever the string is updated:

```elm
module Colorbox exposing (Container, colorbox)

import Components exposing (Component)
import Components.Html exposing (Html, div, text)
import Components.Html.Attributes exposing (css)
import Css


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : String
    , currentTheme : Theme
    , otherThemes : List Theme
    }


type alias Theme =
    ( Css.Color, Css.Color )


type Msg
    = ContextUpdated


type alias Parts =
    ()


colorbox : String -> Component Container m p
colorbox value =
    Components.regularWithOptions
        { init = \_ -> ( init value, Cmd.none, [] )
        , update = \_ msg state -> ( update value msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = ()
        , options = { onContextUpdate = Just ContextUpdated }
        }


init : String -> State
init value =
    { value = value
    , currentTheme = ( Css.hex "ad9784", Css.hex "181e1e" )
    , otherThemes =
        [ ( Css.hex "fc5b70", Css.hex "13206a" )
        , ( Css.hex "34abf2", Css.hex "11198a" )
        , ( Css.hex "400844", Css.hex "eed7c9" )
        , ( Css.hex "b35acd", Css.hex "23070a" )
        ]
    }


update : String -> Msg -> State -> State
update value msg state =
    case msg of
        ContextUpdated ->
            if state.value /= value then
                let
                    ( currentTheme, otherThemes ) =
                        case state.otherThemes of
                            nextTheme :: moreThemes ->
                                ( nextTheme
                                , moreThemes ++ [ state.currentTheme ]
                                )

                            [] ->
                                ( state.currentTheme
                                , state.otherThemes
                                )
                in
                { state
                    | value = value
                    , currentTheme = currentTheme
                    , otherThemes = otherThemes
                }
            else
                state


view : State -> Html Msg Parts
view state =
    let
        ( backgroundColor, textColor ) =
            state.currentTheme
    in
    div
        [ css
            [ Css.display Css.inlineBlock
            , Css.backgroundColor backgroundColor
            , Css.color textColor
            , Css.padding (Css.px 10)
            , Css.empty [ Css.padding Css.zero ]
            ]
        ]
        [ text state.value
        ]
```

```elm
module App exposing (Container, app)

import Colorbox exposing (colorbox)
import Components exposing (Component, send, slot, x1)
import Components.Html exposing (Html, div, input)
import Components.Html.Attributes exposing (autofocus, value)
import Components.Html.Events exposing (onInput)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : String
    }


type Msg
    = UpdateValue String


type alias Parts =
    { colorbox : Colorbox.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x1 Parts
        }


init : State
init =
    { value = ""
    }


update : Msg -> State -> State
update msg state =
    case msg of
        UpdateValue newValue ->
            { state | value = newValue }


view : State -> Html Msg Parts
view state =
    div []
        [ div []
            [ input
                [ value state.value
                , autofocus True
                , onInput (send << UpdateValue)
                ]
            ]
        , colorbox state.value
            |> slot ( .colorbox, \x y -> { y | colorbox = x } )
        ]
```

To listen for changes in surrounding context, we need to use the
`regularWithOptions` function and pass it a message which we want to receive:

```elm
Components.regularWithOptions
    { ... 
    , options = { onContextUpdate = Just ContextUpdated }
    }
```

We will receive the `ContextUpdated` message each time the consumer's view is
recalculated, but there is no any guarantee that anything has changed at all.
We need to store the `value` in the `State` and check whether it has changed
manually: 

```elm
init value =
    { value = value
    ...


update value msg state =
    case msg of
      ContextUpdated ->
          if state.value /= value then
              let
                  ...
              in
              { state
                  | value = value
                  , ...
              }
```

By doing this we are breaking the "Single source of truth" principle, but
sometimes it's the lesser of two evils.

But in general, using `onContextUpdate` makes your code more error-prone and
harder to follow, so I recommend to avoid this feature unless there is no better
way to achieve what you want.

### Laziness

Laziness works a bit differently in `elm-components`. Let's look at the example
first:

```elm
module Counter exposing (Container, counter)

import Components exposing (Component, send, slot, x1)
import Components.Html exposing (Html, button, div, text)
import Components.Html.Events exposing (onClick)
import Components.Lazy as Lazy


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : Int
    }


type Msg
    = Increment
    | Decrement


type alias Parts =
    { content : Lazy.Container State
    }


counter : Component Container m p
counter =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x1 Parts
        }


init : State
init =
    { value = 0
    }


update : Msg -> State -> State
update msg state =
    case msg of
        Increment ->
            { state | value = state.value + 1 }

        Decrement ->
            { state | value = state.value - 1 }


view : State -> Html Msg Parts
view state =
    Lazy.lazy content state
        |> slot ( .content, \x y -> { y | content = x } )


content : State -> Html Msg Parts
content state =
    let
        _ =
            Debug.log "" "Counter has been recalculated"
    in
    div []
        [ button [ onClick (send Decrement) ] [ text "-" ]
        , div [] [ text (toString state.value) ]
        , button [ onClick (send Increment) ] [ text "+" ]
        ]
```

As you can see, you need to register lazy blocks inside your `Parts` just like
components (`Lazy` is just a special kind of a component actually). The reason
for this is that `elm-components` implements its own mechanism for laziness to
decide when your `Html` should be recalculated and then delegates the work to
`VirtualDom.lazy` for the diffing part. `VirtualDom` can cheat and store some
state in JS bypassing Elm's type system and making the API more simple, but
`elm-components` doesn't have such luxury, so it requires your code to be more
verbose.

The other important difference is that the data that you pass to `lazy` is
compared by value because there is no other way to do it. This means that you
should be more careful when you use it with large data structures, and it won't
work with values that contain functions. There is one advantage though. When
using `elm-lang/html`, laziness doesn't work if you calculate values on the fly:

```elm
-- ( a, b ) === ( a, b ) is always false
Html.Lazy.lazy fn ( a, b )
```

Since `elm-components` compares by value, it will still work as expected. An
ideal solution might be to add some sort of shallow equality function to Elm
which would compare tuples, records and simple union types by value, but things
like `List`s and `Dict`s (recursive union types?) by reference.

You can experiment with the following code and see in your console when the
`App` or the `Counter` is recalculated:

```elm
module App exposing (Container, app)

import Components exposing (Component, send, slot, x1)
import Components.Html exposing (Html, div, input, text)
import Components.Html.Events exposing (onInput)
import Counter exposing (counter)


type alias Container =
    Components.Container State Msg Parts


type alias State =
    { value : String
    }


type Msg
    = UpdateValue String


type alias Parts =
    { counter : Counter.Container
    }


app : Component Container m p
app =
    Components.regular
        { init = \_ -> ( init, Cmd.none, [] )
        , update = \_ msg state -> ( update msg state, Cmd.none, [] )
        , subscriptions = \_ _ -> Sub.none
        , view = \_ -> view
        , parts = x1 Parts
        }


init : State
init =
    { value = ""
    }


update : Msg -> State -> State
update msg state =
    case msg of
        UpdateValue newValue ->
            { state | value = newValue }


view : State -> Html Msg Parts
view state =
    let
        _ =
            Debug.log "" "App has been recalculated"
    in
    div []
        [ counter |> slot ( .counter, \x y -> { y | counter = x } )
        , input [ onInput (send << UpdateValue) ]
        , div [] [ text state.value ]
        ]
```

If you do this, you can see that when you change the counter, the `App`'s view
is not executed even though we don't use laziness there. `elm-components` is
actually smart enough to not recalculate everything even without laziness. See
the next section for more details.

There are some more issues/limitations of laziness that you should be aware of:
- As being said, you can't use it with values that contain functions. This
includes `Signal`s and `Html`.
- Don't use laziness around components directly for now because you can run into
this bug: https://github.com/elm-lang/virtual-dom/issues/73. Wrapping them in a
`div` should help.
- Don't change the function you pass to `lazy` dynamically. Consider the
following:

```elm
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

`elm-components` can't compare functions by reference so it won't be able to
detect the change. Use different slots instead:

```elm
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
```
- Don't pass anonymous functions to `lazy` since it's very easy to introduce
bugs with them for the same reason as above. Again, the `VirtualDom` package is
able to compare those functions by references so it disables laziness in such
cases and saves you from silly mistakes. `elm-components` can't do this.
- Currently lazy blocks are cached on the level of the component inside which
they are rendered (not where they are registered in the `Parts` type). This
means that if you change the place where they are rendered during the update
(for example, if you pass it to some `Layout` mixed component and then move it
to `AnotherLayout`), it will be invalidated and recalculated.
- Since `elm-components` uses 
[`Html.Styled`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Html-Styled)
under the hood, using `lazy` on a node will prepend a `style` element to its
children if you style it with `elm-css` which can break your markup.


## What About Performance?

This library might not be the best choice for animation-heavy apps (yet?), but
it should be possible to achieve good performance for the most of use cases.
I've spent quite a lot of time optimizing it, and there is still room for
further optimizations. I don't have any benchmarks, so I'm going to explain how
it works under the hood a bit so that you can see what to expect.

Imagine a tree of components:

![Component tree](https://raw.githubusercontent.com/edkv/elm-components/master/images/component-tree.svg?sanitize=true)

Once initialized, all components are cached in a bunch of `Dict`s by their IDs.
Now let's say an event occurs inside the component (8). Here's what happens:

1. `elm-components` maintains a `Dict ComponentId ParentId` of component
locations so, once a message is received, it's able to quickly find a path to
the target component. In our case, the message will be routed to the component
(3) and then to the component (8).
2. The `update` function of the component (8) will be executed and its view
will be recalculated. This is important: your views are executed inside `update`
of your program because `elm-components` needs to collect all rendered
components, whereas libraries like `elm-lang/html` can do it entirely inside
`requestAnimationFrame`. It should be okay for regular user interactions but
it's harmful for animations. There is still a way to achieve good performance
for animations though: more on this later.
3. Now `elm-components` needs to recalculate other components that may be
affected by the change to the state of the component (8). Since the state can
only be passed down the tree, the part of the tree above the component (8) can't
be affected by that change, so it can be leaved untouched entirely. On the other
hand, descendants of the component (8) will be invalidated, their
`onContextUpdate` messages will be processed (if they register one) and their
views will be recalculated *unless* they are located inside `lazy` blocks whose
inputs haven't changed (also, new components that were added to the tree will be
initialized). Let's imagine that laziness is used around component (12):

![Component tree update](https://raw.githubusercontent.com/edkv/elm-components/master/images/component-tree-update.svg?sanitize=true)

4. All updated state, commands and signals will be lifted up to the top-level
component. At this point some cleanup will be made destroying data associated
with components that were removed from the tree. Next, all collected signals
will be processed the same way as described above potentially accumulating more
signals among the way. The process will be repeated until there are no more
signals. This means that some unnecessary view calculations will be made (only
the last version of the view after this process will be rendered), but again,
this shouldn't be critical except in the case of animations.
5. The update will be finally completed. The Elm runtime will now execute the
`subscriptions` function of your program where subscriptions of all components
will be collected (this is a matter of folding over cached components and doing
`Sub.batch`).
6. Finally, the `view` function of your program will be executed and your UI
will be rendered (possibly not immediately due to `requestAnimationFrame` from
what your animations will benefit). At this point views of all your components
will be already built and cached, so there is no need to execute them again.
Here things like calculating hashes of your styles, converting your component
tree into `VirtualDom.Node` and diffing will happen. It's important to know that
this process will be done for the entire tree except for places where you
explicitly use laziness. It's theoretically possible to apply `VirtualDom.lazy`
automatically for parts of the tree above the updated component like it's done
for `Html` rebuilds, but `elm-components` doesn't do this, mainly because this
may introduce `style` nodes in random places and break your markup (since it
actually uses `Html.Styled.lazy` instead of `VirtualDom.lazy` directly).

As you can see, by using laziness and relying on the ability of `elm-components`
to skip parts of the tree, you should be able to minimize what is re-rendered
quite effectively. In an ideal world, it would be possible to determine the most
minimal path of what should be re-rendered, but of course you won't be able to
use laziness everywhere because of its limitations.

So what about animations? As been explained, nothing above the updated component
is recalculated. This gives you a way for optimizing animations — extract them
into separate components so that only a very small portion of view is
recalculated every time the animation is updated. This should work great for
isolated animations like effects inside buttons or a loading spinner, but of
course you won't be able to use this technique for any kind of animation
(imagine a page transition effect). You might still be able to use pure CSS for
such animations though! It all depends on your requirements.


## Future Plans

- There are only a few basic tests for now. The first thing that needs to be
done before any further big changes is writing more.
- The underlying implementation of the library is quite complex. Maybe some work
can be done to simplify things, potentially making more performance
optimizations at the same time.
- It should be examined whether it's possible to implement a "debug mode"
recovering the import/export functionality of the debugger in the development
environment. This may require changes to the debugger itself though.
- It should be possible to make `elm-components` independent of what kind of UI
it renders. This will allow to move the current `Html`/`Svg` implementation
into a separate package and to experiment with alternative abstractions
(for example, I have an idea of implementing a more type-safe `Html`/`Svg`
package that would prevent you from mistakenly rendering invalid markup), or to
integrate `elm-components` with libraries like
[mdgriffith/style-elements](http://package.elm-lang.org/packages/mdgriffith/style-elements/latest).
- Executing views of components inside the `update` is a controversial decision
and this is something I would like to change in the future, although I'm not yet
sure how to avoid it.
