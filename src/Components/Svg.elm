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


type alias Svg m p =
    Core.Node SvgItem HtmlItem m p


type alias Attribute m p =
    Core.Attribute SvgItem m p


type alias Component container m p =
    Core.Component SvgItem HtmlItem container m p


{-| Create any SVG node. To create a `<rect>` helper function, you would write:

    rect : List (Attribute m p) -> List (Svg m p) -> Svg m p
    rect attributes children =
        node "rect" attributes children

You should always be able to use the helper functions already defined in this
library though!

-}
node : String -> List (Attribute m p) -> List (Svg m p) -> Svg m p
node tag attributes children =
    Core.SimpleElement
        { tag = tag
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| A simple text node, no tags at all.

Warning: not to be confused with `text_` which produces the SVG `<text>` tag!

-}
text : String -> Svg m p
text =
    Core.Text


plainNode : VirtualDom.Node m -> Svg m p
plainNode =
    VirtualDom.map send >> Core.PlainNode


{-| The root `<svg>` node for any SVG scene. This example shows a scene
containing a rounded rectangle:

    import Components.Html exposing (Html)
    import Svg exposing (..)
    import Svg.Attributes exposing (..)

    roundRect : Html m p
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
svg : List (Attribute m p) -> List (Svg m p) -> Html m p
svg attributes children =
    Core.Embedding
        { tag = "svg"
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| -}
foreignObject : List (Attribute m p) -> List (Html m p) -> Svg m p
foreignObject attributes children =
    Core.ReversedEmbedding
        { tag = "foreignObject"
        , attributes = svgNamespace :: attributes
        , children = children
        }



-- Animation elements


{-| -}
animate : List (Attribute m p) -> List (Svg m p) -> Svg m p
animate =
    node "animate"


{-| -}
animateColor : List (Attribute m p) -> List (Svg m p) -> Svg m p
animateColor =
    node "animateColor"


{-| -}
animateMotion : List (Attribute m p) -> List (Svg m p) -> Svg m p
animateMotion =
    node "animateMotion"


{-| -}
animateTransform : List (Attribute m p) -> List (Svg m p) -> Svg m p
animateTransform =
    node "animateTransform"


{-| -}
mpath : List (Attribute m p) -> List (Svg m p) -> Svg m p
mpath =
    node "mpath"


{-| -}
set : List (Attribute m p) -> List (Svg m p) -> Svg m p
set =
    node "set"



-- Container elements


{-| The SVG Anchor Element defines a hyperlink.
-}
a : List (Attribute m p) -> List (Svg m p) -> Svg m p
a =
    node "a"


{-| -}
defs : List (Attribute m p) -> List (Svg m p) -> Svg m p
defs =
    node "defs"


{-| -}
g : List (Attribute m p) -> List (Svg m p) -> Svg m p
g =
    node "g"


{-| -}
marker : List (Attribute m p) -> List (Svg m p) -> Svg m p
marker =
    node "marker"


{-| -}
mask : List (Attribute m p) -> List (Svg m p) -> Svg m p
mask =
    node "mask"


{-| -}
pattern : List (Attribute m p) -> List (Svg m p) -> Svg m p
pattern =
    node "pattern"


{-| -}
switch : List (Attribute m p) -> List (Svg m p) -> Svg m p
switch =
    node "switch"


{-| -}
symbol : List (Attribute m p) -> List (Svg m p) -> Svg m p
symbol =
    node "symbol"



-- Descriptive elements


{-| -}
desc : List (Attribute m p) -> List (Svg m p) -> Svg m p
desc =
    node "desc"


{-| -}
metadata : List (Attribute m p) -> List (Svg m p) -> Svg m p
metadata =
    node "metadata"


{-| -}
title : List (Attribute m p) -> List (Svg m p) -> Svg m p
title =
    node "title"



-- Filter primitive elements


{-| -}
feBlend : List (Attribute m p) -> List (Svg m p) -> Svg m p
feBlend =
    node "feBlend"


{-| -}
feColorMatrix : List (Attribute m p) -> List (Svg m p) -> Svg m p
feColorMatrix =
    node "feColorMatrix"


{-| -}
feComponentTransfer : List (Attribute m p) -> List (Svg m p) -> Svg m p
feComponentTransfer =
    node "feComponentTransfer"


{-| -}
feComposite : List (Attribute m p) -> List (Svg m p) -> Svg m p
feComposite =
    node "feComposite"


{-| -}
feConvolveMatrix : List (Attribute m p) -> List (Svg m p) -> Svg m p
feConvolveMatrix =
    node "feConvolveMatrix"


{-| -}
feDiffuseLighting : List (Attribute m p) -> List (Svg m p) -> Svg m p
feDiffuseLighting =
    node "feDiffuseLighting"


{-| -}
feDisplacementMap : List (Attribute m p) -> List (Svg m p) -> Svg m p
feDisplacementMap =
    node "feDisplacementMap"


{-| -}
feFlood : List (Attribute m p) -> List (Svg m p) -> Svg m p
feFlood =
    node "feFlood"


{-| -}
feFuncA : List (Attribute m p) -> List (Svg m p) -> Svg m p
feFuncA =
    node "feFuncA"


{-| -}
feFuncB : List (Attribute m p) -> List (Svg m p) -> Svg m p
feFuncB =
    node "feFuncB"


{-| -}
feFuncG : List (Attribute m p) -> List (Svg m p) -> Svg m p
feFuncG =
    node "feFuncG"


{-| -}
feFuncR : List (Attribute m p) -> List (Svg m p) -> Svg m p
feFuncR =
    node "feFuncR"


{-| -}
feGaussianBlur : List (Attribute m p) -> List (Svg m p) -> Svg m p
feGaussianBlur =
    node "feGaussianBlur"


{-| -}
feImage : List (Attribute m p) -> List (Svg m p) -> Svg m p
feImage =
    node "feImage"


{-| -}
feMerge : List (Attribute m p) -> List (Svg m p) -> Svg m p
feMerge =
    node "feMerge"


{-| -}
feMergeNode : List (Attribute m p) -> List (Svg m p) -> Svg m p
feMergeNode =
    node "feMergeNode"


{-| -}
feMorphology : List (Attribute m p) -> List (Svg m p) -> Svg m p
feMorphology =
    node "feMorphology"


{-| -}
feOffset : List (Attribute m p) -> List (Svg m p) -> Svg m p
feOffset =
    node "feOffset"


{-| -}
feSpecularLighting : List (Attribute m p) -> List (Svg m p) -> Svg m p
feSpecularLighting =
    node "feSpecularLighting"


{-| -}
feTile : List (Attribute m p) -> List (Svg m p) -> Svg m p
feTile =
    node "feTile"


{-| -}
feTurbulence : List (Attribute m p) -> List (Svg m p) -> Svg m p
feTurbulence =
    node "feTurbulence"



-- Font elements


{-| -}
font : List (Attribute m p) -> List (Svg m p) -> Svg m p
font =
    node "font"



-- Gradient elements


{-| -}
linearGradient : List (Attribute m p) -> List (Svg m p) -> Svg m p
linearGradient =
    node "linearGradient"


{-| -}
radialGradient : List (Attribute m p) -> List (Svg m p) -> Svg m p
radialGradient =
    node "radialGradient"


{-| -}
stop : List (Attribute m p) -> List (Svg m p) -> Svg m p
stop =
    node "stop"



-- Graphics elements


{-| The circle element is an SVG basic shape, used to create circles based on
a center point and a radius.

    circle [ cx "60", cy "60", r "50" ]

-}
circle : List (Attribute m p) -> List (Svg m p) -> Svg m p
circle =
    node "circle"


{-| -}
ellipse : List (Attribute m p) -> List (Svg m p) -> Svg m p
ellipse =
    node "ellipse"


{-| -}
image : List (Attribute m p) -> List (Svg m p) -> Svg m p
image =
    node "image"


{-| -}
line : List (Attribute m p) -> List (Svg m p) -> Svg m p
line =
    node "line"


{-| -}
path : List (Attribute m p) -> List (Svg m p) -> Svg m p
path =
    node "path"


{-| -}
polygon : List (Attribute m p) -> List (Svg m p) -> Svg m p
polygon =
    node "polygon"


{-| The polyline element is an SVG basic shape, used to create a series of
straight lines connecting several points. Typically a polyline is used to
create open shapes.

    polyline [ fill "none", stroke "black", points "20,100 40,60 70,80 100,20" ]

-}
polyline : List (Attribute m p) -> List (Svg m p) -> Svg m p
polyline =
    node "polyline"


{-| -}
rect : List (Attribute m p) -> List (Svg m p) -> Svg m p
rect =
    node "rect"


{-| -}
use : List (Attribute m p) -> List (Svg m p) -> Svg m p
use =
    node "use"



-- Light source elements


{-| -}
feDistantLight : List (Attribute m p) -> List (Svg m p) -> Svg m p
feDistantLight =
    node "feDistantLight"


{-| -}
fePointLight : List (Attribute m p) -> List (Svg m p) -> Svg m p
fePointLight =
    node "fePointLight"


{-| -}
feSpotLight : List (Attribute m p) -> List (Svg m p) -> Svg m p
feSpotLight =
    node "feSpotLight"



-- Text content elements


{-| -}
altGlyph : List (Attribute m p) -> List (Svg m p) -> Svg m p
altGlyph =
    node "altGlyph"


{-| -}
altGlyphDef : List (Attribute m p) -> List (Svg m p) -> Svg m p
altGlyphDef =
    node "altGlyphDef"


{-| -}
altGlyphItem : List (Attribute m p) -> List (Svg m p) -> Svg m p
altGlyphItem =
    node "altGlyphItem"


{-| -}
glyph : List (Attribute m p) -> List (Svg m p) -> Svg m p
glyph =
    node "glyph"


{-| -}
glyphRef : List (Attribute m p) -> List (Svg m p) -> Svg m p
glyphRef =
    node "glyphRef"


{-| -}
textPath : List (Attribute m p) -> List (Svg m p) -> Svg m p
textPath =
    node "textPath"


{-| -}
text_ : List (Attribute m p) -> List (Svg m p) -> Svg m p
text_ =
    node "text"


{-| -}
tref : List (Attribute m p) -> List (Svg m p) -> Svg m p
tref =
    node "tref"


{-| -}
tspan : List (Attribute m p) -> List (Svg m p) -> Svg m p
tspan =
    node "tspan"



-- Uncategorized elements


{-| -}
clipPath : List (Attribute m p) -> List (Svg m p) -> Svg m p
clipPath =
    node "clipPath"


{-| -}
colorProfile : List (Attribute m p) -> List (Svg m p) -> Svg m p
colorProfile =
    node "colorProfile"


{-| -}
cursor : List (Attribute m p) -> List (Svg m p) -> Svg m p
cursor =
    node "cursor"


{-| -}
filter : List (Attribute m p) -> List (Svg m p) -> Svg m p
filter =
    node "filter"


{-| -}
script : List (Attribute m p) -> List (Svg m p) -> Svg m p
script =
    node "script"


{-| -}
style : List (Attribute m p) -> List (Svg m p) -> Svg m p
style =
    node "style"


{-| -}
view : List (Attribute m p) -> List (Svg m p) -> Svg m p
view =
    node "view"
