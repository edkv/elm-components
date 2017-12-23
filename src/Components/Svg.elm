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
        , none
        , path
        , pattern
        , plainSvg
        , polygon
        , polyline
        , radialGradient
        , rect
        , script
        , set
        , slot
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

import Components exposing (Container, Signal, Slot)
import Components.Html exposing (Html)
import Components.Internal.Core as Core exposing (Node)
import Components.Internal.Elements as Elements
import Components.Internal.Shared
    exposing
        ( HtmlNode(HtmlNode)
        , SvgAttribute(SvgAttribute)
        , SvgComponent(SvgComponent)
        , SvgNode(SvgNode)
        , svgNamespace
        )
import VirtualDom


type alias Svg c m =
    SvgNode c m


type alias Attribute c m =
    SvgAttribute c m


type alias Component container c m =
    SvgComponent container c m


{-| Create any SVG node. To create a `<rect>` helper function, you would write:

    rect : List (Attribute c m) -> List (Svg c m) -> Svg c m
    rect attributes children =
        node "rect" attributes children

You should always be able to use the helper functions already defined in this
library though!

-}
node : String -> List (Attribute c m) -> List (Svg c m) -> Svg c m
node tag attributes children =
    nodeHelp
        tag
        attributes
        (List.map (\(SvgNode node) -> node) children)
        |> SvgNode


{-| A simple text node, no tags at all.

Warning: not to be confused with `text_` which produces the SVG `<text>` tag!

-}
text : String -> Svg c m
text =
    Elements.text >> SvgNode


none : Svg c m
none =
    text ""


plainSvg : VirtualDom.Node m -> Svg c m
plainSvg =
    Elements.plainElement >> SvgNode


slot :
    Slot (Container c m s) pC
    -> Component (Container c m s) pC pM
    -> Svg pC pM
slot slot_ (SvgComponent (Core.Component component)) =
    SvgNode (component slot_)


{-| The root `<svg>` node for any SVG scene. This example shows a scene
containing a rounded rectangle:

    import Components.Html exposing (Html)
    import Svg exposing (..)
    import Svg.Attributes exposing (..)

    roundRect : Html c m
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
svg : List (Attribute c m) -> List (Svg c m) -> Html c m
svg attributes children =
    nodeHelp
        "svg"
        attributes
        (List.map (\(SvgNode node) -> node) children)
        |> HtmlNode


{-| -}
foreignObject : List (Attribute c m) -> List (Html c m) -> Svg c m
foreignObject attributes children =
    nodeHelp
        "foreignObject"
        attributes
        (List.map (\(HtmlNode node) -> node) children)
        |> SvgNode


nodeHelp : String -> List (Attribute c m) -> List (Node c m) -> Node c m
nodeHelp tag attributes children =
    Elements.element tag
        (attributes
            |> List.map (\(SvgAttribute attr) -> attr)
            |> (::) svgNamespace
        )
        children



-- Animation elements


{-| -}
animate : List (Attribute c m) -> List (Svg c m) -> Svg c m
animate =
    node "animate"


{-| -}
animateColor : List (Attribute c m) -> List (Svg c m) -> Svg c m
animateColor =
    node "animateColor"


{-| -}
animateMotion : List (Attribute c m) -> List (Svg c m) -> Svg c m
animateMotion =
    node "animateMotion"


{-| -}
animateTransform : List (Attribute c m) -> List (Svg c m) -> Svg c m
animateTransform =
    node "animateTransform"


{-| -}
mpath : List (Attribute c m) -> List (Svg c m) -> Svg c m
mpath =
    node "mpath"


{-| -}
set : List (Attribute c m) -> List (Svg c m) -> Svg c m
set =
    node "set"



-- Container elements


{-| The SVG Anchor Element defines a hyperlink.
-}
a : List (Attribute c m) -> List (Svg c m) -> Svg c m
a =
    node "a"


{-| -}
defs : List (Attribute c m) -> List (Svg c m) -> Svg c m
defs =
    node "defs"


{-| -}
g : List (Attribute c m) -> List (Svg c m) -> Svg c m
g =
    node "g"


{-| -}
marker : List (Attribute c m) -> List (Svg c m) -> Svg c m
marker =
    node "marker"


{-| -}
mask : List (Attribute c m) -> List (Svg c m) -> Svg c m
mask =
    node "mask"


{-| -}
pattern : List (Attribute c m) -> List (Svg c m) -> Svg c m
pattern =
    node "pattern"


{-| -}
switch : List (Attribute c m) -> List (Svg c m) -> Svg c m
switch =
    node "switch"


{-| -}
symbol : List (Attribute c m) -> List (Svg c m) -> Svg c m
symbol =
    node "symbol"



-- Descriptive elements


{-| -}
desc : List (Attribute c m) -> List (Svg c m) -> Svg c m
desc =
    node "desc"


{-| -}
metadata : List (Attribute c m) -> List (Svg c m) -> Svg c m
metadata =
    node "metadata"


{-| -}
title : List (Attribute c m) -> List (Svg c m) -> Svg c m
title =
    node "title"



-- Filter primitive elements


{-| -}
feBlend : List (Attribute c m) -> List (Svg c m) -> Svg c m
feBlend =
    node "feBlend"


{-| -}
feColorMatrix : List (Attribute c m) -> List (Svg c m) -> Svg c m
feColorMatrix =
    node "feColorMatrix"


{-| -}
feComponentTransfer : List (Attribute c m) -> List (Svg c m) -> Svg c m
feComponentTransfer =
    node "feComponentTransfer"


{-| -}
feComposite : List (Attribute c m) -> List (Svg c m) -> Svg c m
feComposite =
    node "feComposite"


{-| -}
feConvolveMatrix : List (Attribute c m) -> List (Svg c m) -> Svg c m
feConvolveMatrix =
    node "feConvolveMatrix"


{-| -}
feDiffuseLighting : List (Attribute c m) -> List (Svg c m) -> Svg c m
feDiffuseLighting =
    node "feDiffuseLighting"


{-| -}
feDisplacementMap : List (Attribute c m) -> List (Svg c m) -> Svg c m
feDisplacementMap =
    node "feDisplacementMap"


{-| -}
feFlood : List (Attribute c m) -> List (Svg c m) -> Svg c m
feFlood =
    node "feFlood"


{-| -}
feFuncA : List (Attribute c m) -> List (Svg c m) -> Svg c m
feFuncA =
    node "feFuncA"


{-| -}
feFuncB : List (Attribute c m) -> List (Svg c m) -> Svg c m
feFuncB =
    node "feFuncB"


{-| -}
feFuncG : List (Attribute c m) -> List (Svg c m) -> Svg c m
feFuncG =
    node "feFuncG"


{-| -}
feFuncR : List (Attribute c m) -> List (Svg c m) -> Svg c m
feFuncR =
    node "feFuncR"


{-| -}
feGaussianBlur : List (Attribute c m) -> List (Svg c m) -> Svg c m
feGaussianBlur =
    node "feGaussianBlur"


{-| -}
feImage : List (Attribute c m) -> List (Svg c m) -> Svg c m
feImage =
    node "feImage"


{-| -}
feMerge : List (Attribute c m) -> List (Svg c m) -> Svg c m
feMerge =
    node "feMerge"


{-| -}
feMergeNode : List (Attribute c m) -> List (Svg c m) -> Svg c m
feMergeNode =
    node "feMergeNode"


{-| -}
feMorphology : List (Attribute c m) -> List (Svg c m) -> Svg c m
feMorphology =
    node "feMorphology"


{-| -}
feOffset : List (Attribute c m) -> List (Svg c m) -> Svg c m
feOffset =
    node "feOffset"


{-| -}
feSpecularLighting : List (Attribute c m) -> List (Svg c m) -> Svg c m
feSpecularLighting =
    node "feSpecularLighting"


{-| -}
feTile : List (Attribute c m) -> List (Svg c m) -> Svg c m
feTile =
    node "feTile"


{-| -}
feTurbulence : List (Attribute c m) -> List (Svg c m) -> Svg c m
feTurbulence =
    node "feTurbulence"



-- Font elements


{-| -}
font : List (Attribute c m) -> List (Svg c m) -> Svg c m
font =
    node "font"



-- Gradient elements


{-| -}
linearGradient : List (Attribute c m) -> List (Svg c m) -> Svg c m
linearGradient =
    node "linearGradient"


{-| -}
radialGradient : List (Attribute c m) -> List (Svg c m) -> Svg c m
radialGradient =
    node "radialGradient"


{-| -}
stop : List (Attribute c m) -> List (Svg c m) -> Svg c m
stop =
    node "stop"



-- Graphics elements


{-| The circle element is an SVG basic shape, used to create circles based on
a center point and a radius.

    circle [ cx "60", cy "60", r "50" ]

-}
circle : List (Attribute c m) -> List (Svg c m) -> Svg c m
circle =
    node "circle"


{-| -}
ellipse : List (Attribute c m) -> List (Svg c m) -> Svg c m
ellipse =
    node "ellipse"


{-| -}
image : List (Attribute c m) -> List (Svg c m) -> Svg c m
image =
    node "image"


{-| -}
line : List (Attribute c m) -> List (Svg c m) -> Svg c m
line =
    node "line"


{-| -}
path : List (Attribute c m) -> List (Svg c m) -> Svg c m
path =
    node "path"


{-| -}
polygon : List (Attribute c m) -> List (Svg c m) -> Svg c m
polygon =
    node "polygon"


{-| The polyline element is an SVG basic shape, used to create a series of
straight lines connecting several points. Typically a polyline is used to
create open shapes.

    polyline [ fill "none", stroke "black", points "20,100 40,60 70,80 100,20" ]

-}
polyline : List (Attribute c m) -> List (Svg c m) -> Svg c m
polyline =
    node "polyline"


{-| -}
rect : List (Attribute c m) -> List (Svg c m) -> Svg c m
rect =
    node "rect"


{-| -}
use : List (Attribute c m) -> List (Svg c m) -> Svg c m
use =
    node "use"



-- Light source elements


{-| -}
feDistantLight : List (Attribute c m) -> List (Svg c m) -> Svg c m
feDistantLight =
    node "feDistantLight"


{-| -}
fePointLight : List (Attribute c m) -> List (Svg c m) -> Svg c m
fePointLight =
    node "fePointLight"


{-| -}
feSpotLight : List (Attribute c m) -> List (Svg c m) -> Svg c m
feSpotLight =
    node "feSpotLight"



-- Text content elements


{-| -}
altGlyph : List (Attribute c m) -> List (Svg c m) -> Svg c m
altGlyph =
    node "altGlyph"


{-| -}
altGlyphDef : List (Attribute c m) -> List (Svg c m) -> Svg c m
altGlyphDef =
    node "altGlyphDef"


{-| -}
altGlyphItem : List (Attribute c m) -> List (Svg c m) -> Svg c m
altGlyphItem =
    node "altGlyphItem"


{-| -}
glyph : List (Attribute c m) -> List (Svg c m) -> Svg c m
glyph =
    node "glyph"


{-| -}
glyphRef : List (Attribute c m) -> List (Svg c m) -> Svg c m
glyphRef =
    node "glyphRef"


{-| -}
textPath : List (Attribute c m) -> List (Svg c m) -> Svg c m
textPath =
    node "textPath"


{-| -}
text_ : List (Attribute c m) -> List (Svg c m) -> Svg c m
text_ =
    node "text"


{-| -}
tref : List (Attribute c m) -> List (Svg c m) -> Svg c m
tref =
    node "tref"


{-| -}
tspan : List (Attribute c m) -> List (Svg c m) -> Svg c m
tspan =
    node "tspan"



-- Uncategorized elements


{-| -}
clipPath : List (Attribute c m) -> List (Svg c m) -> Svg c m
clipPath =
    node "clipPath"


{-| -}
colorProfile : List (Attribute c m) -> List (Svg c m) -> Svg c m
colorProfile =
    node "colorProfile"


{-| -}
cursor : List (Attribute c m) -> List (Svg c m) -> Svg c m
cursor =
    node "cursor"


{-| -}
filter : List (Attribute c m) -> List (Svg c m) -> Svg c m
filter =
    node "filter"


{-| -}
script : List (Attribute c m) -> List (Svg c m) -> Svg c m
script =
    node "script"


{-| -}
style : List (Attribute c m) -> List (Svg c m) -> Svg c m
style =
    node "style"


{-| -}
view : List (Attribute c m) -> List (Svg c m) -> Svg c m
view =
    node "view"
