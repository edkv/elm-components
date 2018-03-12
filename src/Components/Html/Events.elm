module Components.Html.Events
    exposing
        ( Options
        , defaultOptions
        , keyCode
        , on
        , onBlur
        , onCheck
        , onClick
        , onDoubleClick
        , onFocus
        , onInput
        , onMouseDown
        , onMouseEnter
        , onMouseLeave
        , onMouseOut
        , onMouseOver
        , onMouseUp
        , onSubmit
        , onWithOptions
        , targetChecked
        , targetValue
        )

{-| The only difference from the `elm-lang/html` package is that the functions
accept [`Signal`s](Components#Signal) instead of raw messages.


# Mouse Helpers

@docs onClick, onDoubleClick, onMouseDown, onMouseUp, onMouseEnter, onMouseLeave, onMouseOver, onMouseOut


# Form Helpers

@docs onInput, onCheck, onSubmit


# Focus Helpers

@docs onBlur, onFocus


# Custom Event Handlers

@docs on, onWithOptions, Options, defaultOptions


# Custom Decoders

@docs targetValue, targetChecked, keyCode

-}

import Components exposing (Signal)
import Components.Html exposing (Attribute)
import Components.Internal.Core as Core
import Json.Decode as Json
import VirtualDom


-- MOUSE EVENTS


{-| -}
onClick : Signal msg parts -> Attribute msg parts
onClick signal =
    on "click" (Json.succeed signal)


{-| -}
onDoubleClick : Signal msg parts -> Attribute msg parts
onDoubleClick signal =
    on "dblclick" (Json.succeed signal)


{-| -}
onMouseDown : Signal msg parts -> Attribute msg parts
onMouseDown signal =
    on "mousedown" (Json.succeed signal)


{-| -}
onMouseUp : Signal msg parts -> Attribute msg parts
onMouseUp signal =
    on "mouseup" (Json.succeed signal)


{-| -}
onMouseEnter : Signal msg parts -> Attribute msg parts
onMouseEnter signal =
    on "mouseenter" (Json.succeed signal)


{-| -}
onMouseLeave : Signal msg parts -> Attribute msg parts
onMouseLeave signal =
    on "mouseleave" (Json.succeed signal)


{-| -}
onMouseOver : Signal msg parts -> Attribute msg parts
onMouseOver signal =
    on "mouseover" (Json.succeed signal)


{-| -}
onMouseOut : Signal msg parts -> Attribute msg parts
onMouseOut signal =
    on "mouseout" (Json.succeed signal)



-- FORM EVENTS


{-| Capture [input](https://developer.mozilla.org/en-US/docs/Web/Events/input)
events for things like text fields or text areas.

It grabs the **string** value at `event.target.value`, so it will not work if
you need some other type of information. For example, if you want to track
inputs on a range slider, make a custom handler with [`on`](#on).

For more details on how `onInput` works, check out [targetValue](#targetValue).

-}
onInput : (String -> Signal msg parts) -> Attribute msg parts
onInput tagger =
    on "input" (Json.map tagger targetValue)


{-| Capture [change](https://developer.mozilla.org/en-US/docs/Web/Events/change)
events on checkboxes. It will grab the boolean value from `event.target.checked`
on any input event.

Check out [targetChecked](#targetChecked) for more details on how this works.

-}
onCheck : (Bool -> Signal msg parts) -> Attribute msg parts
onCheck tagger =
    on "change" (Json.map tagger targetChecked)


{-| Capture a [submit](https://developer.mozilla.org/en-US/docs/Web/Events/submit)
event with [`preventDefault`](https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault)
in order to prevent the form from changing the page’s location. If you need
different behavior, use `onWithOptions` to create a customized version of
`onSubmit`.
-}
onSubmit : Signal msg parts -> Attribute msg parts
onSubmit signal =
    onWithOptions "submit"
        { defaultOptions | preventDefault = True }
        (Json.succeed signal)



-- FOCUS EVENTS


{-| -}
onBlur : Signal msg parts -> Attribute msg parts
onBlur signal =
    on "blur" (Json.succeed signal)


{-| -}
onFocus : Signal msg parts -> Attribute msg parts
onFocus signal =
    on "focus" (Json.succeed signal)



-- CUSTOM EVENTS


{-| Create a custom event listener. Normally this will not be necessary, but
you have the power! Here is how `onClick` is defined for example:

    import Json.Decode as Json

    onClick : Signal msg parts -> Attribute msg parts
    onClick signal =
        on "click" (Json.succeed signal)

The first argument is the event name in the same format as with JavaScript's
[`addEventListener`][aEL] function.

The second argument is a JSON decoder. Read more about these [here][decoder].
When an event occurs, the decoder tries to turn the event object into an Elm
value. If successful, the value is routed to your `update` function. In the
case of `onClick` we always just succeed with the given `signal`.

If this is confusing, work through the [Elm Architecture Tutorial][tutorial].
It really does help!

[aEL]: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
[decoder]: http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode
[tutorial]: https://github.com/evancz/elm-architecture-tutorial/

-}
on : String -> Json.Decoder (Signal msg parts) -> Attribute msg parts
on event decoder =
    VirtualDom.on event decoder
        |> Core.PlainAttribute


{-| Same as `on` but you can set a few options.
-}
onWithOptions :
    String
    -> Options
    -> Json.Decoder (Signal msg parts)
    -> Attribute msg parts
onWithOptions event decoder options =
    VirtualDom.onWithOptions event decoder options
        |> Core.PlainAttribute


{-| Options for an event listener. If `stopPropagation` is true, it means the
event stops traveling through the DOM so it will not trigger any other event
listeners. If `preventDefault` is true, any built-in browser behavior related
to the event is prevented. For example, this is used with touch events when you
want to treat them as gestures of your own, not as scrolls.
-}
type alias Options =
    VirtualDom.Options


{-| Everything is `False` by default.

    defaultOptions =
        { stopPropagation = False
        , preventDefault = False
        }

-}
defaultOptions : Options
defaultOptions =
    VirtualDom.defaultOptions



-- COMMON DECODERS


{-| A `Json.Decoder` for grabbing `event.target.value`. We use this to define
`onInput` as follows:

    import Json.Decode as Json

    onInput : (String -> Signal msg parts) -> Attribute msg parts
    onInput tagger =
        on "input" (Json.map tagger targetValue)

You probably will never need this, but hopefully it gives some insights into
how to make custom event handlers.

-}
targetValue : Json.Decoder String
targetValue =
    Json.at [ "target", "value" ] Json.string


{-| A `Json.Decoder` for grabbing `event.target.checked`. We use this to define
`onCheck` as follows:

    import Json.Decode as Json

    onCheck : (Bool -> Signal msg parts) -> Attribute msg parts
    onCheck tagger =
        on "input" (Json.map tagger targetChecked)

-}
targetChecked : Json.Decoder Bool
targetChecked =
    Json.at [ "target", "checked" ] Json.bool


{-| A `Json.Decoder` for grabbing `event.keyCode`. This helps you define
keyboard listeners like this:

    import Json.Decode as Json

    onKeyUp : (Int -> Signal msg parts) -> Attribute msg parts
    onKeyUp tagger =
        on "keyup" (Json.map tagger keyCode)

**Note:** It looks like the spec is moving away from `event.keyCode` and
towards `event.key`. Once this is supported in more browsers, we may add
helpers here for `onKeyUp`, `onKeyDown`, `onKeyPress`, etc.

-}
keyCode : Json.Decoder Int
keyCode =
    Json.field "keyCode" Json.int
