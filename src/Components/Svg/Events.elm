module Components.Svg.Events
    exposing
        ( Options
        , defaultOptions
        , on
        , onAbort
        , onActivate
        , onBegin
        , onClick
        , onEnd
        , onError
        , onFocusIn
        , onFocusOut
        , onLoad
        , onMouseDown
        , onMouseMove
        , onMouseOut
        , onMouseOver
        , onMouseUp
        , onRepeat
        , onResize
        , onScroll
        , onUnload
        , onWithOptions
        , onZoom
        )

{-|


# Animation event attributes

@docs onBegin, onEnd, onRepeat


# Document event attributes

@docs onAbort, onError, onResize, onScroll, onLoad, onUnload, onZoom


# Graphical event attributes

@docs onActivate, onClick, onFocusIn, onFocusOut, onMouseDown, onMouseMove, onMouseOut, onMouseOver, onMouseUp


# Custom Events

@docs on, onWithOptions

-}

import Components exposing (Signal)
import Components.Internal.Core as Core
import Components.Svg exposing (Attribute)
import Json.Decode as Json
import VirtualDom


{-| Create a custom event listener.

    import Json.Decode as Json

    onClick : Signal m c -> Attribute m c
    onClick signal signal =
        on "click" (Json.succeed signal)

You first specify the name of the event in the same format as with JavaScript’s
`addEventListener`. Next you give a JSON decoder, which lets you pull
information out of the event object. If the decoder succeeds, it will produce
a message and route it to your `update` function.

-}
on : String -> Json.Decoder (Signal m c) -> Attribute m c
on event decoder =
    VirtualDom.on event decoder
        |> Core.PlainAttribute


{-| Same as `on` but you can set a few options.
-}
onWithOptions : String -> Options -> Json.Decoder (Signal m c) -> Attribute m c
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

    defaultOptions signal =
        { stopPropagation signal = False
        , preventDefault signal = False
        }

-}
defaultOptions : Options
defaultOptions =
    VirtualDom.defaultOptions



-- ANIMATION


{-| -}
onBegin : Signal m c -> Attribute m c
onBegin signal =
    on "begin" (Json.succeed signal)


{-| -}
onEnd : Signal m c -> Attribute m c
onEnd signal =
    on "end" (Json.succeed signal)


{-| -}
onRepeat : Signal m c -> Attribute m c
onRepeat signal =
    on "repeat" (Json.succeed signal)



-- DOCUMENT


{-| -}
onAbort : Signal m c -> Attribute m c
onAbort signal =
    on "abort" (Json.succeed signal)


{-| -}
onError : Signal m c -> Attribute m c
onError signal =
    on "error" (Json.succeed signal)


{-| -}
onResize : Signal m c -> Attribute m c
onResize signal =
    on "resize" (Json.succeed signal)


{-| -}
onScroll : Signal m c -> Attribute m c
onScroll signal =
    on "scroll" (Json.succeed signal)


{-| -}
onLoad : Signal m c -> Attribute m c
onLoad signal =
    on "load" (Json.succeed signal)


{-| -}
onUnload : Signal m c -> Attribute m c
onUnload signal =
    on "unload" (Json.succeed signal)


{-| -}
onZoom : Signal m c -> Attribute m c
onZoom signal =
    on "zoom" (Json.succeed signal)



-- GRAPHICAL


{-| -}
onActivate : Signal m c -> Attribute m c
onActivate signal =
    on "activate" (Json.succeed signal)


{-| -}
onClick : Signal m c -> Attribute m c
onClick signal =
    on "click" (Json.succeed signal)


{-| -}
onFocusIn : Signal m c -> Attribute m c
onFocusIn signal =
    on "focusin" (Json.succeed signal)


{-| -}
onFocusOut : Signal m c -> Attribute m c
onFocusOut signal =
    on "focusout" (Json.succeed signal)


{-| -}
onMouseDown : Signal m c -> Attribute m c
onMouseDown signal =
    on "mousedown" (Json.succeed signal)


{-| -}
onMouseMove : Signal m c -> Attribute m c
onMouseMove signal =
    on "mousemove" (Json.succeed signal)


{-| -}
onMouseOut : Signal m c -> Attribute m c
onMouseOut signal =
    on "mouseout" (Json.succeed signal)


{-| -}
onMouseOver : Signal m c -> Attribute m c
onMouseOver signal =
    on "mouseover" (Json.succeed signal)


{-| -}
onMouseUp : Signal m c -> Attribute m c
onMouseUp signal =
    on "mouseup" (Json.succeed signal)
