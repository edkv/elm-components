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

{-| The only difference from the `elm-lang/html` package is that the functions
accept [`Signal`s](Components#Signal) instead of raw messages.


# Animation event attributes

@docs onBegin, onEnd, onRepeat


# Document event attributes

@docs onAbort, onError, onResize, onScroll, onLoad, onUnload, onZoom


# Graphical event attributes

@docs onActivate, onClick, onFocusIn, onFocusOut, onMouseDown, onMouseMove, onMouseOut, onMouseOver, onMouseUp


# Custom Events

@docs on, onWithOptions, Options, defaultOptions

-}

import Components exposing (Signal)
import Components.Internal.Core as Core
import Components.Svg exposing (Attribute)
import Json.Decode as Json
import VirtualDom


{-| Create a custom event listener.

    import Json.Decode as Json

    onClick : Signal msg parts -> Attribute msg parts
    onClick signal signal =
        on "click" (Json.succeed signal)

You first specify the name of the event in the same format as with JavaScript’s
`addEventListener`. Next you give a JSON decoder, which lets you pull
information out of the event object. If the decoder succeeds, it will produce
a message and route it to your `update` function.

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



-- ANIMATION


{-| -}
onBegin : Signal msg parts -> Attribute msg parts
onBegin signal =
    on "begin" (Json.succeed signal)


{-| -}
onEnd : Signal msg parts -> Attribute msg parts
onEnd signal =
    on "end" (Json.succeed signal)


{-| -}
onRepeat : Signal msg parts -> Attribute msg parts
onRepeat signal =
    on "repeat" (Json.succeed signal)



-- DOCUMENT


{-| -}
onAbort : Signal msg parts -> Attribute msg parts
onAbort signal =
    on "abort" (Json.succeed signal)


{-| -}
onError : Signal msg parts -> Attribute msg parts
onError signal =
    on "error" (Json.succeed signal)


{-| -}
onResize : Signal msg parts -> Attribute msg parts
onResize signal =
    on "resize" (Json.succeed signal)


{-| -}
onScroll : Signal msg parts -> Attribute msg parts
onScroll signal =
    on "scroll" (Json.succeed signal)


{-| -}
onLoad : Signal msg parts -> Attribute msg parts
onLoad signal =
    on "load" (Json.succeed signal)


{-| -}
onUnload : Signal msg parts -> Attribute msg parts
onUnload signal =
    on "unload" (Json.succeed signal)


{-| -}
onZoom : Signal msg parts -> Attribute msg parts
onZoom signal =
    on "zoom" (Json.succeed signal)



-- GRAPHICAL


{-| -}
onActivate : Signal msg parts -> Attribute msg parts
onActivate signal =
    on "activate" (Json.succeed signal)


{-| -}
onClick : Signal msg parts -> Attribute msg parts
onClick signal =
    on "click" (Json.succeed signal)


{-| -}
onFocusIn : Signal msg parts -> Attribute msg parts
onFocusIn signal =
    on "focusin" (Json.succeed signal)


{-| -}
onFocusOut : Signal msg parts -> Attribute msg parts
onFocusOut signal =
    on "focusout" (Json.succeed signal)


{-| -}
onMouseDown : Signal msg parts -> Attribute msg parts
onMouseDown signal =
    on "mousedown" (Json.succeed signal)


{-| -}
onMouseMove : Signal msg parts -> Attribute msg parts
onMouseMove signal =
    on "mousemove" (Json.succeed signal)


{-| -}
onMouseOut : Signal msg parts -> Attribute msg parts
onMouseOut signal =
    on "mouseout" (Json.succeed signal)


{-| -}
onMouseOver : Signal msg parts -> Attribute msg parts
onMouseOver signal =
    on "mouseover" (Json.succeed signal)


{-| -}
onMouseUp : Signal msg parts -> Attribute msg parts
onMouseUp signal =
    on "mouseup" (Json.succeed signal)
