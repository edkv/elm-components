module Components.Svg
    exposing
        ( Attribute
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
        , none
        , path
        , pattern
        , plain
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

{-| Build SVG views, just like with the `elm-lang/svg` package.

Differences from `elm-lang/svg`:

  - New functions: [`none`](#none) and [`plain`](#plain).
  - No [`map`](http://package.elm-lang.org/packages/elm-lang/svg/latest/Svg#map).
  - It supports [adding dynamic styles](Components-Svg-Attributes#styles)
    via the
    [`elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest)
    package.


# SVG Nodes

@docs Svg, Attribute, node, text, none, plain


# HTML Embedding

@docs svg, foreignObject


# Graphics elements

@docs circle, ellipse, image, line, path, polygon, polyline, rect, use


# Animation elements

@docs animate, animateColor, animateMotion, animateTransform, mpath, set


# Descriptive elements

@docs desc, metadata, title


# Containers

@docs a, defs, g, marker, mask, pattern, switch, symbol


# Text

@docs altGlyph, altGlyphDef, altGlyphItem, glyph, glyphRef, textPath, text_, tref, tspan


# Fonts

@docs font


# Gradients

@docs linearGradient, radialGradient, stop


# Filters

@docs feBlend, feColorMatrix, feComponentTransfer, feComposite, feConvolveMatrix, feDiffuseLighting, feDisplacementMap, feFlood, feFuncA, feFuncB, feFuncG, feFuncR, feGaussianBlur, feImage, feMerge, feMergeNode, feMorphology, feOffset, feSpecularLighting, feTile, feTurbulence


# Light source elements

@docs feDistantLight, fePointLight, feSpotLight


# Miscellaneous

@docs clipPath, colorProfile, cursor, filter, script, style, view

-}

import Components
import Components.Html exposing (Html)
import Components.Internal.Core as Core
import Components.Internal.Shared exposing (svgNamespace)
import VirtualDom


{-| -}
type alias Svg msg parts =
    Components.Node msg parts


{-| -}
type alias Attribute msg parts =
    Core.Attribute msg parts


{-| Create any SVG node. To create a `<rect>` helper function, you would write:

    rect : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
    rect attributes children =
        node "rect" attributes children

You should always be able to use the helper functions already defined in this
library though!

-}
node :
    String
    -> List (Attribute msg parts)
    -> List (Svg msg parts)
    -> Svg msg parts
node tag attributes children =
    Core.Element tag (svgNamespace :: attributes) children


{-| A simple text node, no tags at all.

Warning: not to be confused with `text_` which produces the SVG `<text>` tag!

-}
text : String -> Svg msg parts
text =
    Core.Text


{-| Same as `text ""`.
-}
none : Svg msg parts
none =
    text ""


{-| Embed a node that was created with another package like `elm-lang/svg`.
-}
plain : VirtualDom.Node msg -> Svg msg parts
plain =
    VirtualDom.map Core.LocalMsg
        >> Core.PlainNode


{-| The root `<svg>` node for any SVG scene. This example shows a scene
containing a rounded rectangle:

    import Components.Html exposing (Html)
    import Components.Svg exposing (..)
    import Components.Svg.Attributes exposing (..)

    roundRect : Html msg parts
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
svg : List (Attribute msg parts) -> List (Svg msg parts) -> Html msg parts
svg =
    node "svg"


{-| -}
foreignObject : List (Attribute msg parts) -> List (Html msg parts) -> Svg msg parts
foreignObject =
    node "foreignObject"



-- Animation elements


{-| -}
animate : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
animate =
    node "animate"


{-| -}
animateColor : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
animateColor =
    node "animateColor"


{-| -}
animateMotion : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
animateMotion =
    node "animateMotion"


{-| -}
animateTransform : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
animateTransform =
    node "animateTransform"


{-| -}
mpath : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
mpath =
    node "mpath"


{-| -}
set : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
set =
    node "set"



-- Container elements


{-| The SVG Anchor Element defines a hyperlink.
-}
a : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
a =
    node "a"


{-| -}
defs : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
defs =
    node "defs"


{-| -}
g : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
g =
    node "g"


{-| -}
marker : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
marker =
    node "marker"


{-| -}
mask : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
mask =
    node "mask"


{-| -}
pattern : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
pattern =
    node "pattern"


{-| -}
switch : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
switch =
    node "switch"


{-| -}
symbol : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
symbol =
    node "symbol"



-- Descriptive elements


{-| -}
desc : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
desc =
    node "desc"


{-| -}
metadata : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
metadata =
    node "metadata"


{-| -}
title : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
title =
    node "title"



-- Filter primitive elements


{-| -}
feBlend : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feBlend =
    node "feBlend"


{-| -}
feColorMatrix : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feColorMatrix =
    node "feColorMatrix"


{-| -}
feComponentTransfer : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feComponentTransfer =
    node "feComponentTransfer"


{-| -}
feComposite : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feComposite =
    node "feComposite"


{-| -}
feConvolveMatrix : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feConvolveMatrix =
    node "feConvolveMatrix"


{-| -}
feDiffuseLighting : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feDiffuseLighting =
    node "feDiffuseLighting"


{-| -}
feDisplacementMap : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feDisplacementMap =
    node "feDisplacementMap"


{-| -}
feFlood : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feFlood =
    node "feFlood"


{-| -}
feFuncA : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feFuncA =
    node "feFuncA"


{-| -}
feFuncB : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feFuncB =
    node "feFuncB"


{-| -}
feFuncG : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feFuncG =
    node "feFuncG"


{-| -}
feFuncR : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feFuncR =
    node "feFuncR"


{-| -}
feGaussianBlur : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feGaussianBlur =
    node "feGaussianBlur"


{-| -}
feImage : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feImage =
    node "feImage"


{-| -}
feMerge : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feMerge =
    node "feMerge"


{-| -}
feMergeNode : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feMergeNode =
    node "feMergeNode"


{-| -}
feMorphology : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feMorphology =
    node "feMorphology"


{-| -}
feOffset : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feOffset =
    node "feOffset"


{-| -}
feSpecularLighting : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feSpecularLighting =
    node "feSpecularLighting"


{-| -}
feTile : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feTile =
    node "feTile"


{-| -}
feTurbulence : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feTurbulence =
    node "feTurbulence"



-- Font elements


{-| -}
font : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
font =
    node "font"



-- Gradient elements


{-| -}
linearGradient : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
linearGradient =
    node "linearGradient"


{-| -}
radialGradient : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
radialGradient =
    node "radialGradient"


{-| -}
stop : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
stop =
    node "stop"



-- Graphics elements


{-| The circle element is an SVG basic shape, used to create circles based on
a center point and a radius.

    circle [ cx "60", cy "60", r "50" ]

-}
circle : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
circle =
    node "circle"


{-| -}
ellipse : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
ellipse =
    node "ellipse"


{-| -}
image : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
image =
    node "image"


{-| -}
line : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
line =
    node "line"


{-| -}
path : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
path =
    node "path"


{-| -}
polygon : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
polygon =
    node "polygon"


{-| The polyline element is an SVG basic shape, used to create a series of
straight lines connecting several points. Typically a polyline is used to
create open shapes.

    polyline [ fill "none", stroke "black", points "20,100 40,60 70,80 100,20" ]

-}
polyline : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
polyline =
    node "polyline"


{-| -}
rect : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
rect =
    node "rect"


{-| -}
use : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
use =
    node "use"



-- Light source elements


{-| -}
feDistantLight : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feDistantLight =
    node "feDistantLight"


{-| -}
fePointLight : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
fePointLight =
    node "fePointLight"


{-| -}
feSpotLight : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
feSpotLight =
    node "feSpotLight"



-- Text content elements


{-| -}
altGlyph : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
altGlyph =
    node "altGlyph"


{-| -}
altGlyphDef : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
altGlyphDef =
    node "altGlyphDef"


{-| -}
altGlyphItem : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
altGlyphItem =
    node "altGlyphItem"


{-| -}
glyph : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
glyph =
    node "glyph"


{-| -}
glyphRef : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
glyphRef =
    node "glyphRef"


{-| -}
textPath : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
textPath =
    node "textPath"


{-| -}
text_ : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
text_ =
    node "text"


{-| -}
tref : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
tref =
    node "tref"


{-| -}
tspan : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
tspan =
    node "tspan"



-- Uncategorized elements


{-| -}
clipPath : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
clipPath =
    node "clipPath"


{-| -}
colorProfile : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
colorProfile =
    node "colorProfile"


{-| -}
cursor : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
cursor =
    node "cursor"


{-| -}
filter : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
filter =
    node "filter"


{-| -}
script : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
script =
    node "script"


{-| -}
style : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
style =
    node "style"


{-| -}
view : List (Attribute msg parts) -> List (Svg msg parts) -> Svg msg parts
view =
    node "view"
