module Components
    exposing
        ( Attribute
        , Component
        , ComponentInternalStuff
        , Container
        , Msg
        , Node
        , Options
        , Self
        , Signal
        , Slot
        , State
        , convertAttribute
        , convertNode
        , convertSignal
        , convertSlot
        , defaultOptions
        , dictSlot
        , init
        , mixed
        , mixedWithOptions
        , regular
        , regularWithOptions
        , send
        , sendToPart
        , slot
        , subscriptions
        , update
        , view
        , wrapMsg
        , x1
        , x10
        , x11
        , x12
        , x13
        , x14
        , x15
        , x16
        , x17
        , x18
        , x19
        , x2
        , x20
        , x21
        , x22
        , x23
        , x24
        , x25
        , x26
        , x27
        , x28
        , x29
        , x3
        , x30
        , x31
        , x32
        , x33
        , x34
        , x35
        , x36
        , x37
        , x38
        , x39
        , x4
        , x40
        , x41
        , x42
        , x43
        , x44
        , x45
        , x46
        , x47
        , x48
        , x49
        , x5
        , x50
        , x6
        , x7
        , x8
        , x9
        )

{-| A typical component definition looks like this:

    module MyComponent exposing (Container, myComponent)

    import Components exposing (Component)
    ...


    type alias Container =
        Components.Container State Msg Parts


    type alias State =
        { field : Int
        , anotherField : String
        }


    type Msg
        = DoSomething
        | DoSomethingElse


    type alias Parts =
        { subcomponent : MyComponent1.Container
        , anotherSubcomponent : MyComponent2.Container
        }


    myComponent : Component Container m p
    myComponent =
        Components.regular
            { init = init
            , update = update
            , subscriptions = subscriptions
            , view = view
            , parts = Components.x2 Parts
            }

    ...

Be sure to check out the README which contains a detailed guide for how to use
this package.


# Core Types

@docs Node, Component, Container, Signal, Slot, Attribute


# Working With Components

@docs regular, regularWithOptions, mixed, mixedWithOptions, Self, ComponentInternalStuff, Options, defaultOptions, send, slot, dictSlot, sendToPart ,convertNode, convertSignal, convertAttribute, convertSlot


# Running Components

To run a component do the following:

  - Add the [`State`](#State) to the `State`/`Model` of your program.
  - Add the [`Msg`](#Msg) to the `Msg` of your program.
  - Connect a component in the `init`, `update`, `subscriptions` and `view`
    functions of your program with the help of the functions provided below.

Example:

    import MyComponent
    import VirtualDom


    type alias State =
        { componentState : Components.State MyComponent.Container MsgFromComponent
        }


    type Msg
        = ComponentMsg (Components.Msg MyComponent.Container MsgFromComponent)


    type MsgFromComponent
        = SomethingHappened


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
            ( componentState, componentCmd ) =
                MyComponent.myComponent
                    { onSomeEvent = send SomethingHappened
                    }
                    |> Components.init
        in
        ( { componentState = componentState
          }
        , Cmd.map ComponentMsg componentCmd
        )

    ...

You will receive a `List MsgFromComponent` from the [`update`](#update)
function. Alternatively, use `Never` in place of `MsgFromComponent` if your
component doesn't send any messages to the surrounding context.

Use [`wrapMsg`](#wrapMsg) to send messages to your component.

@docs State, Msg, init, update, subscriptions, view, wrapMsg


# Declaring Parts

When you define a component you must explicitly create a `Parts` record
populated with default values because `elm-components` can't do this
automatically. You can do this in one line with the `x1`-`x50` helper functions
listed below.

    type alias Parts =
        { button : Button.Container
        , dialog : Dialog.Container
        }

    myComponent : Component Container m p
    myComponent =
        Components.regular
            { init = init
            , update = update
            , subscriptions = subscriptions
            , view = view
            , parts = Components.x2 Parts
            }

If you have more than 50 `Parts` you can easily compose these functions:

    x51 =
        x50 >> x1

Also, if you have a `Dict` of components you can declare your `Parts` like this:

    type alias Parts =
        { button : Button.Container
        , dialog : Dialog.Container
        , counterDict : Dict Counter.Container
        }

    myComponent : Component Container m p
    myComponent =
        Components.regular
            { ...
            , parts = Components.x2 Parts <| Dict.empty
            }

@docs x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41, x42, x43, x44, x45, x46, x47, x48, x49, x50

-}

import Components.Internal.BaseComponent as BaseComponent
import Components.Internal.Core as Core
import Components.Internal.Run as Run
import Components.Internal.Shared exposing (toConsumerSignal)
import Dict exposing (Dict)
import VirtualDom


-- CORE TYPES


{-| Views are built with nodes. A node can be either an element or a component.
It can emit messages of the type `msg` and contain components which are
described by the type `parts`.
-}
type alias Node msg parts =
    Core.Node msg parts


{-| Represents a component.

You can define components with the help of functions like [`regular`](#regular):

    button : Component Container msg parts
    button =
        Components.regular
            { init = ...
            , ...
            }

The `msg` and `parts` type variables mean that it can be converted into a
`Node msg parts` and therefore embedded inside a view of another component which
has a `Msg` of type `msg` and `Parts` of type `parts`. It can be done by passing
a `Component` into the [`slot`](#slot) function and giving it a [`Slot`](#Slot).

-}
type alias Component container msg parts =
    Core.Component container msg parts


{-| Each component should define a `Container` type:

    type alias Container =
        Components.Container State Msg Parts

It can be then used by consumers to register that component in their `Parts`:

    type alias Parts =
        { button : Button.Container
        , dialog : Dialog.Container
        , ...
        }

Internally, a `Container` is used to group together a component's state and
states of all its `Parts`, or to carry a message to a component or one of its
`Parts`.

-}
type alias Container state msg parts =
    Core.Container state msg parts


{-| Represents a message that has been [`sent`](#send) either to a component or
to one of its `Parts`.

**Note:** it has nothing to do with the `Signal` type which Elm had in earlier
versions.

`Signal`s are used in views and for communication between components. One of the
reason for this type to be exposed is to provide a way to [convert messages
between types of different components](#convertSignal).

-}
type alias Signal msg parts =
    Core.Signal msg parts


{-| A `Slot` is just a pair of functions that define a strategy for reading and
writing a component's [`Container`](#Container) from/to the `Parts` type of its
consumer:

    type alias Parts =
        { button : Button.Container
        , ...
        }


    buttonSlot : Slot Button.Container Parts
    buttonSlot =
        ( .button, \x y -> { y | button = x } )

You need to specify a `Slot` when you want to [embed a component in another
component](#slot) or [send a message to it](#sendToPart).

-}
type alias Slot container parts =
    Core.Slot container parts


{-| Represents a DOM attribute/property. May emit `Signal msg parts` if it is
an [event handler](Html-Events).
-}
type alias Attribute msg parts =
    Core.Attribute msg parts



-- WORKING WITH COMPONENTS


{-| Contains some useful information about your component (currently only an
`id` field) and some internal stuff that is used by functions like
[`convertNode`](#convertNode).

An `id` is a string of form `_06f8786c-fd3f-4057-ada2-9561883241db_9`. You can
use it for things like HTML `id` attributes or CSS classes. It consists of an
UUID and a sequential number. The UUID is the same for all components in the
same tree.

-}
type alias Self state msg parts consumerParts =
    { id : String
    , internal : ComponentInternalStuff state msg parts consumerParts
    }


{-| Some internal stuff you don't have access to. It is stored inside of
[`Self`](#Self) and is used in functions like [`sendToPart`](#sendToPart) or
[`convertNode`](#convertNode) which receive `Self` as an argument.
-}
type alias ComponentInternalStuff state msg parts consumerParts =
    Core.ComponentInternalStuff state msg parts consumerParts


{-| The options you can provide when you define components.

Currently this is only the `onContextUpdate` field. It allows you to specify a
message that you want your component to receive each time its consumer is
updated. In this way, you can check whether the input parameters of your
component has changed. This might be useful when you can't synchronously
calculate your view from the value of a parameter and want, for example, to
perform an HTTP request or a call to a port when it changes, or when you need to
know both its previous and its current values.

-}
type alias Options msg =
    { onContextUpdate : Maybe msg
    }


{-| Defines a regular component. If you need the ability to accept view blocks
from a consumer and embed them inside your `view`, use the [`mixed`](#mixed)
function instead.

The `init` and `update` functions can transmit signals to a consumer (which the
component need to accept as arguments) or [to `Parts`](#sendToPart).

Read the [Declaring Parts](#declaring-parts) section to see how to specify
`parts`.

-}
regular :
    { init :
        Self state msg parts consumerParts
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , update :
        Self state msg parts consumerParts
        -> msg
        -> state
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , subscriptions :
        Self state msg parts consumerParts
        -> state
        -> Sub msg
    , view :
        Self state msg parts consumerParts
        -> state
        -> Node msg parts
    , parts : parts
    }
    -> Component (Container state msg parts) consumerMsg consumerParts
regular spec =
    regularWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , parts = spec.parts
        , options = defaultOptions
        }


{-| Same as [`regular`](#regular) but with [`Options`](#Options).
-}
regularWithOptions :
    { init :
        Self state msg parts consumerParts
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , update :
        Self state msg parts consumerParts
        -> msg
        -> state
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , subscriptions :
        Self state msg parts consumerParts
        -> state
        -> Sub msg
    , view :
        Self state msg parts consumerParts
        -> state
        -> Node msg parts
    , parts : parts
    , options : Options msg
    }
    -> Component (Container state msg parts) consumerMsg consumerParts
regularWithOptions spec =
    mixedWithOptions
        { spec | view = \self state -> convertNode self (spec.view self state) }


{-| Same as [`regular`](#regular) but its `view` returns
`Node consumerMsg consumerParts`. This gives you an ability to accept view
blocks from a consumer and embed it inside the `view` function.

See also [`convertNode`](#convertNode), [`convertSignal`](#convertSignal),
[`convertAttribute`](#convertAttribute) and [`convertSlot`](#convertSlot)
functions that are designed to help you compose differently typed views
together.

-}
mixed :
    { init :
        Self state msg parts consumerParts
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , update :
        Self state msg parts consumerParts
        -> msg
        -> state
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , subscriptions :
        Self state msg parts consumerParts
        -> state
        -> Sub msg
    , view :
        Self state msg parts consumerParts
        -> state
        -> Node consumerMsg consumerParts
    , parts : parts
    }
    -> Component (Container state msg parts) consumerMsg consumerParts
mixed spec =
    mixedWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , parts = spec.parts
        , options = defaultOptions
        }


{-| Same as [`mixed`](#mixed) but with [`Options`](#Options).
-}
mixedWithOptions :
    { init :
        Self state msg parts consumerParts
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , update :
        Self state msg parts consumerParts
        -> msg
        -> state
        -> ( state, Cmd msg, List (Signal consumerMsg consumerParts) )
    , subscriptions :
        Self state msg parts consumerParts
        -> state
        -> Sub msg
    , view :
        Self state msg parts consumerParts
        -> state
        -> Node consumerMsg consumerParts
    , parts : parts
    , options : Options msg
    }
    -> Component (Container state msg parts) consumerMsg consumerParts
mixedWithOptions spec =
    BaseComponent.make
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , onContextUpdate = spec.options.onContextUpdate
        , shouldRecalculate = always True
        , lazyRender = False
        , parts = spec.parts
        }


{-|

    defaultOptions =
        { onContextUpdate = Nothing
        }

-}
defaultOptions : Options msg
defaultOptions =
    { onContextUpdate = Nothing
    }


{-| Turns a message to a `Signal`.

Use this in your views:

    button [ onClick (send DoSomething) ]
        [ text "Do something"
        ]

-}
send : msg -> Signal msg parts
send =
    Core.LocalMsg


{-| Allows you to send messages to the `Parts` of your component.

Return the result from the `init` or `update` function:

    update self msg state =
        case msg of
            ResetCounter ->
                ( state
                , Cmd.none
                , [ sendToPart self counterSlot Counter.reset ]
                )

-}
sendToPart :
    Self state msg parts consumerParts
    -> Slot (Container partState partMsg partParts) parts
    -> partMsg
    -> Signal consumerMsg consumerParts
sendToPart self partSlot partMsg =
    let
        (Core.ComponentInternalStuff internal) =
            self.internal
    in
    partMsg
        |> Core.LocalMsg
        |> toConsumerSignal partSlot internal.freshContainers
        |> toConsumerSignal internal.slot internal.freshConsumerContainers


{-| Converts a `Component` to a `Node` allowing you to embed it in the view of
another component:

    type alias Parts =
        { button : Button.Container
        }

    button : Html Msg Parts
    button =
        Button.button
            { label = "Do something"
            , onClick = send DoSomething
            }
            |> slot ( .button, \x y -> { y | button = x } )

**Don't use it with a particular `Slot` more than one time! This is not
currently handled and the result is unpredictable!**

-}
slot :
    Slot (Container state msg parts) consumerParts
    -> Component (Container state msg parts) consumerMsg consumerParts
    -> Node consumerMsg consumerParts
slot slot_ (Core.Component component) =
    Core.ComponentNode (component slot_)


{-| Given a `Slot` for a `Dict` of components and a key, produce a `Slot` for a
specific component that is identified by that key. Then you can use it to
[render that component](#slot) or to [send a message to it](#sendToPart):

    type alias Parts =
        { counterDict : Dict Counter.Container
        }

    counterFromDict : Int -> Html Msg Parts
    counterFromDict key =
        Counter.counter
            |> slot (dictSlot counterDictSlot key)

    counterDictSlot : Slot (Dict Int Counter.Container) Parts
    counterDictSlot =
        ( .counterDict, \x y -> { y | counterDict = x } )

-}
dictSlot :
    Slot (Dict comparable (Container state msg parts)) consumerParts
    -> comparable
    -> Slot (Container state msg parts) consumerParts
dictSlot ( getDict, setDict ) key =
    let
        get =
            getDict
                >> Dict.get key
                >> Maybe.withDefault Core.EmptyContainer

        set container parts =
            setDict
                (Dict.insert key container (getDict parts))
                parts
    in
    ( get, set )


{-| Convert a `Node` to consumer's types. Useful when working with
[`mixed`](#mixed) components:

    view : List (Html m p) -> Self State Msg Parts p -> State -> Html m p
    view contents self state =
        div []
            [ div [] contents
            , button |> convertNode self
            , ...
            ]

    button : Html Msg Parts
    button =
        Html.button [ onClick (send DoSomething) ]
            [ text "Do something"
            ]

-}
convertNode :
    Self state msg parts consumerParts
    -> Node msg parts
    -> Node consumerMsg consumerParts
convertNode =
    BaseComponent.convertNode


{-| Convert a `Signal` to consumer's types.

This is useful when you're working with a [`mixed`](#mixed) component and want
to send a message to it from a [`Node`](#Node) that is parametrized on types of
a consumer:

    view : List (Html m p) -> Self State Msg Parts p -> State -> Html m p
    view contents self state =
        div [ onClick (send DoSomething |> convertSignal self) ]
            [ div [] contents
            , ...
            ]

-}
convertSignal :
    Self state msg parts consumerParts
    -> Signal msg parts
    -> Signal consumerMsg consumerParts
convertSignal =
    BaseComponent.convertSignal


{-| Works the same way as [`convertSignal`](#convertSignal) but for an
`Attribute`.
-}
convertAttribute :
    Self state msg parts consumerParts
    -> Attribute msg parts
    -> Attribute consumerMsg consumerParts
convertAttribute =
    BaseComponent.convertAttribute


{-| Given a `Slot` for a component that is registered in your `Parts`, convert
it in a such way that will make everything to behave like if it's registered in
the `Parts` of a consumer.

This is useful when you're working with a [`mixed`](#mixed) component and want
to accept a view block from a consumer and pass it further to one of your
`Parts`:

    type alias Parts =
        { dialog : Dialog.Container
        }

    view : List (Html m p) -> Self State Msg Parts p -> State -> Html m p
    view contents self state =
        Dialog.dialog
            { onClose = send Closed |> convertSignal self
            }
            contents
            |> slot (convertSlot self dialogSlot)

    dialogSlot : Slot Dialog.Container Parts
    dialogSlot =
        ( .dialog, \x y -> { y | dialog = x } )

-}
convertSlot :
    Self state msg parts consumerParts
    -> Slot (Container partState partMsg partParts) parts
    -> Slot (Container partState partMsg partParts) consumerParts
convertSlot =
    BaseComponent.convertSlot



-- RUNNING COMPONENTS


{-| Add this to the `State`/`Model` of you program as shown in the example
above.
-}
type alias State container outMsg =
    Run.State container outMsg


{-| Add this to the `Msg` of you program as shown in the example above.
-}
type alias Msg container outMsg =
    Run.Msg container outMsg


{-| Use this to init a component.

Notice how `Container state msg parts` is used twice in the type of the first
argument. It need to be like that to satifsy the type checker. If you're curious
why: the second time it's used in place of the `parts` type variable of the
[`Component`](#Component) type which simply means that the consumer (your
program) is not going to have any other `Parts` (it can run as much components
as it need, but they all will be completely independent from each other). In
other words, it's the same if your program defined a `Parts` type like this (of
course you don't need to define it at all):

    type alias Parts =
        MyComponent.Container

And the `init` function uses a `Slot` for it that can be defined like this:

    identitySlot : Slot (Container state msg parts) (Container state msg parts)
    identitySlot =
        ( \x -> x, \x _ -> x )

You don't need to understand anything like that to use this function though. It
should just accept any of your components.

-}
init :
    Component (Container state msg parts) outMsg (Container state msg parts)
    -> ( State (Container state msg parts) outMsg, Cmd (Msg (Container state msg parts) outMsg) )
init =
    Run.init


{-| Use this to connect a component in the `update` function of your program.
-}
update :
    Msg (Container state msg parts) outMsg
    -> State (Container state msg parts) outMsg
    -> ( State (Container state msg parts) outMsg, Cmd (Msg (Container state msg parts) outMsg), List outMsg )
update =
    Run.update


{-| Use this to connect a component in the `subscriptions` function of your
program.
-}
subscriptions :
    State (Container state msg parts) outMsg
    -> Sub (Msg (Container state msg parts) outMsg)
subscriptions =
    Run.subscriptions


{-| Use this to render a component.
-}
view :
    State (Container state msg parts) outMsg
    -> VirtualDom.Node (Msg (Container state msg parts) outMsg)
view =
    Run.view


{-| Allows you to send a message to a component from your program:

    update msg state =
        case msg of
            LocationChanged newLocation ->
                ( newAppState, appCmd, messagesFromApp ) =
                    Components.update
                        (Components.wrapMsg App.UpdateLocation)
                        state.appState

                ...

-}
wrapMsg : msg -> Msg (Container state msg parts) outMsg
wrapMsg =
    Run.wrapMsg



-- DECLARING PARTS


{-| -}
x1 : (Container s m p -> parts) -> parts
x1 fn =
    fn Core.EmptyContainer


{-| -}
x2 : (Container s1 m1 p1 -> Container s2 m2 p2 -> parts) -> parts
x2 =
    x1 >> x1


{-| -}
x3 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> parts
    )
    -> parts
x3 =
    x2 >> x1


{-| -}
x4 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> parts
    )
    -> parts
x4 =
    x3 >> x1


{-| -}
x5 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> parts
    )
    -> parts
x5 =
    x4 >> x1


{-| -}
x6 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> parts
    )
    -> parts
x6 =
    x5 >> x1


{-| -}
x7 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> parts
    )
    -> parts
x7 =
    x6 >> x1


{-| -}
x8 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> parts
    )
    -> parts
x8 =
    x7 >> x1


{-| -}
x9 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> parts
    )
    -> parts
x9 =
    x8 >> x1


{-| -}
x10 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> parts
    )
    -> parts
x10 =
    x9 >> x1


{-| -}
x11 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> parts
    )
    -> parts
x11 =
    x10 >> x1


{-| -}
x12 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> parts
    )
    -> parts
x12 =
    x11 >> x1


{-| -}
x13 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> parts
    )
    -> parts
x13 =
    x12 >> x1


{-| -}
x14 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> parts
    )
    -> parts
x14 =
    x13 >> x1


{-| -}
x15 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> parts
    )
    -> parts
x15 =
    x14 >> x1


{-| -}
x16 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> parts
    )
    -> parts
x16 =
    x15 >> x1


{-| -}
x17 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> parts
    )
    -> parts
x17 =
    x16 >> x1


{-| -}
x18 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> parts
    )
    -> parts
x18 =
    x17 >> x1


{-| -}
x19 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> parts
    )
    -> parts
x19 =
    x18 >> x1


{-| -}
x20 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> parts
    )
    -> parts
x20 =
    x19 >> x1


{-| -}
x21 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> parts
    )
    -> parts
x21 =
    x20 >> x1


{-| -}
x22 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> parts
    )
    -> parts
x22 =
    x21 >> x1


{-| -}
x23 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> parts
    )
    -> parts
x23 =
    x22 >> x1


{-| -}
x24 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> parts
    )
    -> parts
x24 =
    x23 >> x1


{-| -}
x25 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> parts
    )
    -> parts
x25 =
    x24 >> x1


{-| -}
x26 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> parts
    )
    -> parts
x26 =
    x25 >> x1


{-| -}
x27 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> parts
    )
    -> parts
x27 =
    x26 >> x1


{-| -}
x28 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> parts
    )
    -> parts
x28 =
    x27 >> x1


{-| -}
x29 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> parts
    )
    -> parts
x29 =
    x28 >> x1


{-| -}
x30 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> parts
    )
    -> parts
x30 =
    x29 >> x1


{-| -}
x31 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> parts
    )
    -> parts
x31 =
    x30 >> x1


{-| -}
x32 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> parts
    )
    -> parts
x32 =
    x31 >> x1


{-| -}
x33 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> parts
    )
    -> parts
x33 =
    x32 >> x1


{-| -}
x34 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> parts
    )
    -> parts
x34 =
    x33 >> x1


{-| -}
x35 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> parts
    )
    -> parts
x35 =
    x34 >> x1


{-| -}
x36 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> parts
    )
    -> parts
x36 =
    x35 >> x1


{-| -}
x37 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> parts
    )
    -> parts
x37 =
    x36 >> x1


{-| -}
x38 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> parts
    )
    -> parts
x38 =
    x37 >> x1


{-| -}
x39 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> parts
    )
    -> parts
x39 =
    x38 >> x1


{-| -}
x40 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> parts
    )
    -> parts
x40 =
    x39 >> x1


{-| -}
x41 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> parts
    )
    -> parts
x41 =
    x40 >> x1


{-| -}
x42 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> parts
    )
    -> parts
x42 =
    x41 >> x1


{-| -}
x43 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> parts
    )
    -> parts
x43 =
    x42 >> x1


{-| -}
x44 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> parts
    )
    -> parts
x44 =
    x43 >> x1


{-| -}
x45 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> parts
    )
    -> parts
x45 =
    x44 >> x1


{-| -}
x46 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> parts
    )
    -> parts
x46 =
    x45 >> x1


{-| -}
x47 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> parts
    )
    -> parts
x47 =
    x46 >> x1


{-| -}
x48 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> Container s48 m48 p48
     -> parts
    )
    -> parts
x48 =
    x47 >> x1


{-| -}
x49 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> Container s48 m48 p48
     -> Container s49 m49 p49
     -> parts
    )
    -> parts
x49 =
    x48 >> x1


{-| -}
x50 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> Container s48 m48 p48
     -> Container s49 m49 p49
     -> Container s50 m50 p50
     -> parts
    )
    -> parts
x50 =
    x49 >> x1
