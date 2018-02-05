module Components.Svg
    exposing
        ( Attribute
        , Component
        , Svg
        , a
        , altGlyph
        , altGlyphDef
        , altGlyphItem
        , animate
        , animateColor
        , animateMotion
        , animateTransform
        , circle
        , clipPath
        , colorProfile
        , cursor
        , defs
        , desc
        , ellipse
        , feBlend
        , feColorMatrix
        , feComponentTransfer
        , feComposite
        , feConvolveMatrix
        , feDiffuseLighting
        , feDisplacementMap
        , feDistantLight
        , feFlood
        , feFuncA
        , feFuncB
        , feFuncG
        , feFuncR
        , feGaussianBlur
        , feImage
        , feMerge
        , feMergeNode
        , feMorphology
        , feOffset
        , fePointLight
        , feSpecularLighting
        , feSpotLight
        , feTile
        , feTurbulence
        , filter
        , font
        , foreignObject
        , g
        , glyph
        , glyphRef
        , image
        , line
        , linearGradient
        , marker
        , mask
        , metadata
        , mpath
        , node
        , path
        , pattern
        , plainNode
        , polygon
        , polyline
        , radialGradient
        , rect
        , script
        , set
        , stop
        , style
        , svg
        , switch
        , symbol
        , text
        , textPath
        , text_
        , title
        , tref
        , tspan
        , use
        , view
        )

import Components exposing (Container, Signal, Slot, send)
import Components.Html exposing (Html)
import Components.Internal.Core as Core
import Components.Internal.Shared exposing (HtmlItem, SvgItem, svgNamespace)
import VirtualDom


type alias Svg m c =
    Core.Node SvgItem HtmlItem m c


type alias Attribute m c =
    Core.Attribute SvgItem m c


type alias Component container m c =
    Core.Component SvgItem HtmlItem container m c


{-| Create any SVG node. To create a `<rect>` helper function, you would write:

    rect : List (Attribute m c) -> List (Svg m c) -> Svg m c
    rect attributes children =
        node "rect" attributes children

You should always be able to use the helper functions already defined in this
library though!

-}
node : String -> List (Attribute m c) -> List (Svg m c) -> Svg m c
node tag attributes children =
    Core.SimpleElement
        { tag = tag
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| A simple text node, no tags at all.

Warning: not to be confused with `text_` which produces the SVG `<text>` tag!

-}
text : String -> Svg m c
text =
    Core.Text


plainNode : VirtualDom.Node m -> Svg m c
plainNode =
    VirtualDom.map send >> Core.PlainNode


{-| The root `<svg>` node for any SVG scene. This example shows a scene
containing a rounded rectangle:

    import Components.Html exposing (Html)
    import Svg exposing (..)
    import Svg.Attributes exposing (..)

    roundRect : Html m c
    roundRect =
        svg
            [ width "120", height "120", viewBox "0 0 120 120" ]
            [ rect
                [ x "10"
                , y "10"
                , width "100"
                , height "100"
                , rx "15"
                , ry "15"
                ]
                []
            ]

-}
svg : List (Attribute m c) -> List (Svg m c) -> Html m c
svg attributes children =
    Core.Embedding
        { tag = "svg"
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| -}
foreignObject : List (Attribute m c) -> List (Html m c) -> Svg m c
foreignObject attributes children =
    Core.ReversedEmbedding
        { tag = "foreignObject"
        , attributes = svgNamespace :: attributes
        , children = children
        }



-- Animation elements


{-| -}
animate : List (Attribute m c) -> List (Svg m c) -> Svg m c
animate =
    node "animate"


{-| -}
animateColor : List (Attribute m c) -> List (Svg m c) -> Svg m c
animateColor =
    node "animateColor"


{-| -}
animateMotion : List (Attribute m c) -> List (Svg m c) -> Svg m c
animateMotion =
    node "animateMotion"


{-| -}
animateTransform : List (Attribute m c) -> List (Svg m c) -> Svg m c
animateTransform =
    node "animateTransform"


{-| -}
mpath : List (Attribute m c) -> List (Svg m c) -> Svg m c
mpath =
    node "mpath"


{-| -}
set : List (Attribute m c) -> List (Svg m c) -> Svg m c
set =
    node "set"



-- Container elements


{-| The SVG Anchor Element defines a hyperlink.
-}
a : List (Attribute m c) -> List (Svg m c) -> Svg m c
a =
    node "a"


{-| -}
defs : List (Attribute m c) -> List (Svg m c) -> Svg m c
defs =
    node "defs"


{-| -}
g : List (Attribute m c) -> List (Svg m c) -> Svg m c
g =
    node "g"


{-| -}
marker : List (Attribute m c) -> List (Svg m c) -> Svg m c
marker =
    node "marker"


{-| -}
mask : List (Attribute m c) -> List (Svg m c) -> Svg m c
mask =
    node "mask"


{-| -}
pattern : List (Attribute m c) -> List (Svg m c) -> Svg m c
pattern =
    node "pattern"


{-| -}
switch : List (Attribute m c) -> List (Svg m c) -> Svg m c
switch =
    node "switch"


{-| -}
symbol : List (Attribute m c) -> List (Svg m c) -> Svg m c
symbol =
    node "symbol"



-- Descriptive elements


{-| -}
desc : List (Attribute m c) -> List (Svg m c) -> Svg m c
desc =
    node "desc"


{-| -}
metadata : List (Attribute m c) -> List (Svg m c) -> Svg m c
metadata =
    node "metadata"


{-| -}
title : List (Attribute m c) -> List (Svg m c) -> Svg m c
title =
    node "title"



-- Filter primitive elements


{-| -}
feBlend : List (Attribute m c) -> List (Svg m c) -> Svg m c
feBlend =
    node "feBlend"


{-| -}
feColorMatrix : List (Attribute m c) -> List (Svg m c) -> Svg m c
feColorMatrix =
    node "feColorMatrix"


{-| -}
feComponentTransfer : List (Attribute m c) -> List (Svg m c) -> Svg m c
feComponentTransfer =
    node "feComponentTransfer"


{-| -}
feComposite : List (Attribute m c) -> List (Svg m c) -> Svg m c
feComposite =
    node "feComposite"


{-| -}
feConvolveMatrix : List (Attribute m c) -> List (Svg m c) -> Svg m c
feConvolveMatrix =
    node "feConvolveMatrix"


{-| -}
feDiffuseLighting : List (Attribute m c) -> List (Svg m c) -> Svg m c
feDiffuseLighting =
    node "feDiffuseLighting"


{-| -}
feDisplacementMap : List (Attribute m c) -> List (Svg m c) -> Svg m c
feDisplacementMap =
    node "feDisplacementMap"


{-| -}
feFlood : List (Attribute m c) -> List (Svg m c) -> Svg m c
feFlood =
    node "feFlood"


{-| -}
feFuncA : List (Attribute m c) -> List (Svg m c) -> Svg m c
feFuncA =
    node "feFuncA"


{-| -}
feFuncB : List (Attribute m c) -> List (Svg m c) -> Svg m c
feFuncB =
    node "feFuncB"


{-| -}
feFuncG : List (Attribute m c) -> List (Svg m c) -> Svg m c
feFuncG =
    node "feFuncG"


{-| -}
feFuncR : List (Attribute m c) -> List (Svg m c) -> Svg m c
feFuncR =
    node "feFuncR"


{-| -}
feGaussianBlur : List (Attribute m c) -> List (Svg m c) -> Svg m c
feGaussianBlur =
    node "feGaussianBlur"


{-| -}
feImage : List (Attribute m c) -> List (Svg m c) -> Svg m c
feImage =
    node "feImage"


{-| -}
feMerge : List (Attribute m c) -> List (Svg m c) -> Svg m c
feMerge =
    node "feMerge"


{-| -}
feMergeNode : List (Attribute m c) -> List (Svg m c) -> Svg m c
feMergeNode =
    node "feMergeNode"


{-| -}
feMorphology : List (Attribute m c) -> List (Svg m c) -> Svg m c
feMorphology =
    node "feMorphology"


{-| -}
feOffset : List (Attribute m c) -> List (Svg m c) -> Svg m c
feOffset =
    node "feOffset"


{-| -}
feSpecularLighting : List (Attribute m c) -> List (Svg m c) -> Svg m c
feSpecularLighting =
    node "feSpecularLighting"


{-| -}
feTile : List (Attribute m c) -> List (Svg m c) -> Svg m c
feTile =
    node "feTile"


{-| -}
feTurbulence : List (Attribute m c) -> List (Svg m c) -> Svg m c
feTurbulence =
    node "feTurbulence"



-- Font elements


{-| -}
font : List (Attribute m c) -> List (Svg m c) -> Svg m c
font =
    node "font"



-- Gradient elements


{-| -}
linearGradient : List (Attribute m c) -> List (Svg m c) -> Svg m c
linearGradient =
    node "linearGradient"


{-| -}
radialGradient : List (Attribute m c) -> List (Svg m c) -> Svg m c
radialGradient =
    node "radialGradient"


{-| -}
stop : List (Attribute m c) -> List (Svg m c) -> Svg m c
stop =
    node "stop"



-- Graphics elements


{-| The circle element is an SVG basic shape, used to create circles based on
a center point and a radius.

    circle [ cx "60", cy "60", r "50" ]

-}
circle : List (Attribute m c) -> List (Svg m c) -> Svg m c
circle =
    node "circle"


{-| -}
ellipse : List (Attribute m c) -> List (Svg m c) -> Svg m c
ellipse =
    node "ellipse"


{-| -}
image : List (Attribute m c) -> List (Svg m c) -> Svg m c
image =
    node "image"


{-| -}
line : List (Attribute m c) -> List (Svg m c) -> Svg m c
line =
    node "line"


{-| -}
path : List (Attribute m c) -> List (Svg m c) -> Svg m c
path =
    node "path"


{-| -}
polygon : List (Attribute m c) -> List (Svg m c) -> Svg m c
polygon =
    node "polygon"


{-| The polyline element is an SVG basic shape, used to create a series of
straight lines connecting several points. Typically a polyline is used to
create open shapes.

    polyline [ fill "none", stroke "black", points "20,100 40,60 70,80 100,20" ]

-}
polyline : List (Attribute m c) -> List (Svg m c) -> Svg m c
polyline =
    node "polyline"


{-| -}
rect : List (Attribute m c) -> List (Svg m c) -> Svg m c
rect =
    node "rect"


{-| -}
use : List (Attribute m c) -> List (Svg m c) -> Svg m c
use =
    node "use"



-- Light source elements


{-| -}
feDistantLight : List (Attribute m c) -> List (Svg m c) -> Svg m c
feDistantLight =
    node "feDistantLight"


{-| -}
fePointLight : List (Attribute m c) -> List (Svg m c) -> Svg m c
fePointLight =
    node "fePointLight"


{-| -}
feSpotLight : List (Attribute m c) -> List (Svg m c) -> Svg m c
feSpotLight =
    node "feSpotLight"



-- Text content elements


{-| -}
altGlyph : List (Attribute m c) -> List (Svg m c) -> Svg m c
altGlyph =
    node "altGlyph"


{-| -}
altGlyphDef : List (Attribute m c) -> List (Svg m c) -> Svg m c
altGlyphDef =
    node "altGlyphDef"


{-| -}
altGlyphItem : List (Attribute m c) -> List (Svg m c) -> Svg m c
altGlyphItem =
    node "altGlyphItem"


{-| -}
glyph : List (Attribute m c) -> List (Svg m c) -> Svg m c
glyph =
    node "glyph"


{-| -}
glyphRef : List (Attribute m c) -> List (Svg m c) -> Svg m c
glyphRef =
    node "glyphRef"


{-| -}
textPath : List (Attribute m c) -> List (Svg m c) -> Svg m c
textPath =
    node "textPath"


{-| -}
text_ : List (Attribute m c) -> List (Svg m c) -> Svg m c
text_ =
    node "text"


{-| -}
tref : List (Attribute m c) -> List (Svg m c) -> Svg m c
tref =
    node "tref"


{-| -}
tspan : List (Attribute m c) -> List (Svg m c) -> Svg m c
tspan =
    node "tspan"



-- Uncategorized elements


{-| -}
clipPath : List (Attribute m c) -> List (Svg m c) -> Svg m c
clipPath =
    node "clipPath"


{-| -}
colorProfile : List (Attribute m c) -> List (Svg m c) -> Svg m c
colorProfile =
    node "colorProfile"


{-| -}
cursor : List (Attribute m c) -> List (Svg m c) -> Svg m c
cursor =
    node "cursor"


{-| -}
filter : List (Attribute m c) -> List (Svg m c) -> Svg m c
filter =
    node "filter"


{-| -}
script : List (Attribute m c) -> List (Svg m c) -> Svg m c
script =
    node "script"


{-| -}
style : List (Attribute m c) -> List (Svg m c) -> Svg m c
style =
    node "style"


{-| -}
view : List (Attribute m c) -> List (Svg m c) -> Svg m c
view =
    node "view"
