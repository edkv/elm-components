module Components.Svg.Attributes
    exposing
        ( accelerate
        , accentHeight
        , accumulate
        , additive
        , alignmentBaseline
        , allowReorder
        , alphabetic
        , amplitude
        , arabicForm
        , ascent
        , attribute
        , attributeNS
        , attributeName
        , attributeType
        , autoReverse
        , azimuth
        , baseFrequency
        , baseProfile
        , baselineShift
        , bbox
        , begin
        , bias
        , by
        , calcMode
        , capHeight
        , class
        , clip
        , clipPath
        , clipPathUnits
        , clipRule
        , color
        , colorInterpolation
        , colorInterpolationFilters
        , colorProfile
        , colorRendering
        , contentScriptType
        , contentStyleType
        , css
        , cursor
        , cx
        , cy
        , d
        , decelerate
        , descent
        , diffuseConstant
        , direction
        , display
        , divisor
        , dominantBaseline
        , dur
        , dx
        , dy
        , edgeMode
        , elevation
        , enableBackground
        , end
        , exponent
        , externalResourcesRequired
        , fill
        , fillOpacity
        , fillRule
        , filter
        , filterRes
        , filterUnits
        , floodColor
        , floodOpacity
        , fontFamily
        , fontSize
        , fontSizeAdjust
        , fontStretch
        , fontStyle
        , fontVariant
        , fontWeight
        , format
        , from
        , fx
        , fy
        , g1
        , g2
        , glyphName
        , glyphOrientationHorizontal
        , glyphOrientationVertical
        , glyphRef
        , gradientTransform
        , gradientUnits
        , hanging
        , height
        , horizAdvX
        , horizOriginX
        , horizOriginY
        , id
        , ideographic
        , imageRendering
        , in2
        , in_
        , intercept
        , k
        , k1
        , k2
        , k3
        , k4
        , kernelMatrix
        , kernelUnitLength
        , kerning
        , keyPoints
        , keySplines
        , keyTimes
        , lang
        , lengthAdjust
        , letterSpacing
        , lightingColor
        , limitingConeAngle
        , local
        , map
        , markerEnd
        , markerHeight
        , markerMid
        , markerStart
        , markerUnits
        , markerWidth
        , mask
        , maskContentUnits
        , maskUnits
        , mathematical
        , max
        , media
        , method
        , min
        , mode
        , name
        , none
        , numOctaves
        , offset
        , opacity
        , operator
        , order
        , orient
        , orientation
        , origin
        , overflow
        , overlinePosition
        , overlineThickness
        , panose1
        , path
        , pathLength
        , patternContentUnits
        , patternTransform
        , patternUnits
        , plain
        , pointOrder
        , pointerEvents
        , points
        , pointsAtX
        , pointsAtY
        , pointsAtZ
        , preserveAlpha
        , preserveAspectRatio
        , primitiveUnits
        , r
        , radius
        , refX
        , refY
        , renderingIntent
        , repeatCount
        , repeatDur
        , requiredExtensions
        , requiredFeatures
        , restart
        , result
        , rotate
        , rx
        , ry
        , scale
        , seed
        , shapeRendering
        , slope
        , spacing
        , specularConstant
        , specularExponent
        , speed
        , spreadMethod
        , startOffset
        , stdDeviation
        , stemh
        , stemv
        , stitchTiles
        , stopColor
        , stopOpacity
        , strikethroughPosition
        , strikethroughThickness
        , string
        , stroke
        , strokeDasharray
        , strokeDashoffset
        , strokeLinecap
        , strokeLinejoin
        , strokeMiterlimit
        , strokeOpacity
        , strokeWidth
        , style
        , surfaceScale
        , systemLanguage
        , tableValues
        , target
        , targetX
        , targetY
        , textAnchor
        , textDecoration
        , textLength
        , textRendering
        , title
        , to
        , transform
        , type_
        , u1
        , u2
        , underlinePosition
        , underlineThickness
        , unicode
        , unicodeBidi
        , unicodeRange
        , unitsPerEm
        , vAlphabetic
        , vHanging
        , vIdeographic
        , vMathematical
        , values
        , version
        , vertAdvY
        , vertOriginX
        , vertOriginY
        , viewBox
        , viewTarget
        , visibility
        , width
        , widths
        , wordSpacing
        , writingMode
        , x
        , x1
        , x2
        , xChannelSelector
        , xHeight
        , xlinkActuate
        , xlinkArcrole
        , xlinkHref
        , xlinkRole
        , xlinkShow
        , xlinkTitle
        , xlinkType
        , xmlBase
        , xmlLang
        , xmlSpace
        , y
        , y1
        , y2
        , yChannelSelector
        , z
        , zoomAndPan
        )

{-| Differences from the `elm-lang/svg` package: new [`none`](#none),
[`plain`](#plain) and [`css`](#css) functions.


# Primitives

@docs attribute, attributeNS, none, plain, map


# CSS

@docs css, style


# Regular attributes

@docs accentHeight, accelerate, accumulate, additive, alphabetic, allowReorder, amplitude, arabicForm, ascent, attributeName, attributeType, autoReverse, azimuth, baseFrequency, baseProfile, bbox, begin, bias, by, calcMode, capHeight, class, clipPathUnits, contentScriptType, contentStyleType, cx, cy, d, decelerate, descent, diffuseConstant, divisor, dur, dx, dy, edgeMode, elevation, end, exponent, externalResourcesRequired, filterRes, filterUnits, format, from, fx, fy, g1, g2, glyphName, glyphRef, gradientTransform, gradientUnits, hanging, height, horizAdvX, horizOriginX, horizOriginY, id, ideographic, in_, in2, intercept, k, k1, k2, k3, k4, kernelMatrix, kernelUnitLength, keyPoints, keySplines, keyTimes, lang, lengthAdjust, limitingConeAngle, local, markerHeight, markerUnits, markerWidth, maskContentUnits, maskUnits, mathematical, max, media, method, min, mode, name, numOctaves, offset, operator, order, orient, orientation, origin, overlinePosition, overlineThickness, panose1, path, pathLength, patternContentUnits, patternTransform, patternUnits, pointOrder, points, pointsAtX, pointsAtY, pointsAtZ, preserveAlpha, preserveAspectRatio, primitiveUnits, r, radius, refX, refY, renderingIntent, repeatCount, repeatDur, requiredExtensions, requiredFeatures, restart, result, rotate, rx, ry, scale, seed, slope, spacing, specularConstant, specularExponent, speed, spreadMethod, startOffset, stdDeviation, stemh, stemv, stitchTiles, strikethroughPosition, strikethroughThickness, string, surfaceScale, systemLanguage, tableValues, target, targetX, targetY, textLength, title, to, transform, type_, u1, u2, underlinePosition, underlineThickness, unicode, unicodeRange, unitsPerEm, vAlphabetic, vHanging, vIdeographic, vMathematical, values, version, vertAdvY, vertOriginX, vertOriginY, viewBox, viewTarget, width, widths, x, xHeight, x1, x2, xChannelSelector, xlinkActuate, xlinkArcrole, xlinkHref, xlinkRole, xlinkShow, xlinkTitle, xlinkType, xmlBase, xmlLang, xmlSpace, y, y1, y2, yChannelSelector, z, zoomAndPan


# Presentation attributes

@docs alignmentBaseline, baselineShift, clipPath, clipRule, clip, colorInterpolationFilters, colorInterpolation, colorProfile, colorRendering, color, cursor, direction, display, dominantBaseline, enableBackground, fillOpacity, fillRule, fill, filter, floodColor, floodOpacity, fontFamily, fontSizeAdjust, fontSize, fontStretch, fontStyle, fontVariant, fontWeight, glyphOrientationHorizontal, glyphOrientationVertical, imageRendering, kerning, letterSpacing, lightingColor, markerEnd, markerMid, markerStart, mask, opacity, overflow, pointerEvents, shapeRendering, stopColor, stopOpacity, strokeDasharray, strokeDashoffset, strokeLinecap, strokeLinejoin, strokeMiterlimit, strokeOpacity, strokeWidth, stroke, textAnchor, textDecoration, textRendering, unicodeBidi, visibility, wordSpacing, writingMode

-}

import Components exposing (Signal)
import Components.Internal.Core as Core
import Components.Internal.Shared as Shared
import Components.Svg exposing (Attribute)
import Css
import VirtualDom


-- Primitives


{-| Create a custom attribute.
-}
attribute : String -> String -> Attribute msg parts
attribute key value =
    VirtualDom.attribute key value
        |> Core.PlainAttribute


{-| Create a custom "namespaced" attribute. This corresponds to JavaScript's
`setAttributeNS` function under the hood.
-}
attributeNS : String -> String -> String -> Attribute msg parts
attributeNS namespace key value =
    VirtualDom.attributeNS namespace key value
        |> Core.PlainAttribute


{-| Don't generate any attribute.

    let
        class =
            if someCondition then
                Attributes.class "someClass"
            else
                Attributes.none

    in
    rect [ class ] [ ...  ]

-}
none : Attribute msg parts
none =
    Core.NullAttribute


{-| Use an attribute that was created with another package like
[`elm-lang/svg`](http://package.elm-lang.org/packages/elm-lang/svg/latest).
-}
plain : VirtualDom.Property msg -> Attribute msg parts
plain =
    VirtualDom.mapProperty Core.LocalMsg
        >> Core.PlainAttribute


{-| Transform the [`Signal`s](Components#Signal) produced by an `Attribute`.
-}
map : (Signal a b -> Signal c d) -> Attribute a b -> Attribute c d
map =
    Shared.mapAttribute



-- CSS


{-| Apply styles to an element.

Styles are created with the help of
[`rtfeldman/elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css)
package, so you need to install it.

-}
css : List Css.Style -> Attribute msg parts
css =
    Core.Styles Core.ClassAttribute


{-| Specify a list of inline styles. This will generate a `style` attribute in
the DOM.
-}
style : List ( String, String ) -> Attribute msg parts
style =
    VirtualDom.style >> Core.PlainAttribute



-- Regular attributes


{-| -}
accentHeight : String -> Attribute msg parts
accentHeight =
    attribute "accent-height"


{-| -}
accelerate : String -> Attribute msg parts
accelerate =
    attribute "accelerate"


{-| -}
accumulate : String -> Attribute msg parts
accumulate =
    attribute "accumulate"


{-| -}
additive : String -> Attribute msg parts
additive =
    attribute "additive"


{-| -}
alphabetic : String -> Attribute msg parts
alphabetic =
    attribute "alphabetic"


{-| -}
allowReorder : String -> Attribute msg parts
allowReorder =
    attribute "allowReorder"


{-| -}
amplitude : String -> Attribute msg parts
amplitude =
    attribute "amplitude"


{-| -}
arabicForm : String -> Attribute msg parts
arabicForm =
    attribute "arabic-form"


{-| -}
ascent : String -> Attribute msg parts
ascent =
    attribute "ascent"


{-| -}
attributeName : String -> Attribute msg parts
attributeName =
    attribute "attributeName"


{-| -}
attributeType : String -> Attribute msg parts
attributeType =
    attribute "attributeType"


{-| -}
autoReverse : String -> Attribute msg parts
autoReverse =
    attribute "autoReverse"


{-| -}
azimuth : String -> Attribute msg parts
azimuth =
    attribute "azimuth"


{-| -}
baseFrequency : String -> Attribute msg parts
baseFrequency =
    attribute "baseFrequency"


{-| -}
baseProfile : String -> Attribute msg parts
baseProfile =
    attribute "baseProfile"


{-| -}
bbox : String -> Attribute msg parts
bbox =
    attribute "bbox"


{-| -}
begin : String -> Attribute msg parts
begin =
    attribute "begin"


{-| -}
bias : String -> Attribute msg parts
bias =
    attribute "bias"


{-| -}
by : String -> Attribute msg parts
by =
    attribute "by"


{-| -}
calcMode : String -> Attribute msg parts
calcMode =
    attribute "calcMode"


{-| -}
capHeight : String -> Attribute msg parts
capHeight =
    attribute "cap-height"


{-| -}
class : String -> Attribute msg parts
class =
    attribute "class"


{-| -}
clipPathUnits : String -> Attribute msg parts
clipPathUnits =
    attribute "clipPathUnits"


{-| -}
contentScriptType : String -> Attribute msg parts
contentScriptType =
    attribute "contentScriptType"


{-| -}
contentStyleType : String -> Attribute msg parts
contentStyleType =
    attribute "contentStyleType"


{-| -}
cx : String -> Attribute msg parts
cx =
    attribute "cx"


{-| -}
cy : String -> Attribute msg parts
cy =
    attribute "cy"


{-| -}
d : String -> Attribute msg parts
d =
    attribute "d"


{-| -}
decelerate : String -> Attribute msg parts
decelerate =
    attribute "decelerate"


{-| -}
descent : String -> Attribute msg parts
descent =
    attribute "descent"


{-| -}
diffuseConstant : String -> Attribute msg parts
diffuseConstant =
    attribute "diffuseConstant"


{-| -}
divisor : String -> Attribute msg parts
divisor =
    attribute "divisor"


{-| -}
dur : String -> Attribute msg parts
dur =
    attribute "dur"


{-| -}
dx : String -> Attribute msg parts
dx =
    attribute "dx"


{-| -}
dy : String -> Attribute msg parts
dy =
    attribute "dy"


{-| -}
edgeMode : String -> Attribute msg parts
edgeMode =
    attribute "edgeMode"


{-| -}
elevation : String -> Attribute msg parts
elevation =
    attribute "elevation"


{-| -}
end : String -> Attribute msg parts
end =
    attribute "end"


{-| -}
exponent : String -> Attribute msg parts
exponent =
    attribute "exponent"


{-| -}
externalResourcesRequired : String -> Attribute msg parts
externalResourcesRequired =
    attribute "externalResourcesRequired"


{-| -}
filterRes : String -> Attribute msg parts
filterRes =
    attribute "filterRes"


{-| -}
filterUnits : String -> Attribute msg parts
filterUnits =
    attribute "filterUnits"


{-| -}
format : String -> Attribute msg parts
format =
    attribute "format"


{-| -}
from : String -> Attribute msg parts
from =
    attribute "from"


{-| -}
fx : String -> Attribute msg parts
fx =
    attribute "fx"


{-| -}
fy : String -> Attribute msg parts
fy =
    attribute "fy"


{-| -}
g1 : String -> Attribute msg parts
g1 =
    attribute "g1"


{-| -}
g2 : String -> Attribute msg parts
g2 =
    attribute "g2"


{-| -}
glyphName : String -> Attribute msg parts
glyphName =
    attribute "glyph-name"


{-| -}
glyphRef : String -> Attribute msg parts
glyphRef =
    attribute "glyphRef"


{-| -}
gradientTransform : String -> Attribute msg parts
gradientTransform =
    attribute "gradientTransform"


{-| -}
gradientUnits : String -> Attribute msg parts
gradientUnits =
    attribute "gradientUnits"


{-| -}
hanging : String -> Attribute msg parts
hanging =
    attribute "hanging"


{-| -}
height : String -> Attribute msg parts
height =
    attribute "height"


{-| -}
horizAdvX : String -> Attribute msg parts
horizAdvX =
    attribute "horiz-adv-x"


{-| -}
horizOriginX : String -> Attribute msg parts
horizOriginX =
    attribute "horiz-origin-x"


{-| -}
horizOriginY : String -> Attribute msg parts
horizOriginY =
    attribute "horiz-origin-y"


{-| -}
id : String -> Attribute msg parts
id =
    attribute "id"


{-| -}
ideographic : String -> Attribute msg parts
ideographic =
    attribute "ideographic"


{-| -}
in_ : String -> Attribute msg parts
in_ =
    attribute "in"


{-| -}
in2 : String -> Attribute msg parts
in2 =
    attribute "in2"


{-| -}
intercept : String -> Attribute msg parts
intercept =
    attribute "intercept"


{-| -}
k : String -> Attribute msg parts
k =
    attribute "k"


{-| -}
k1 : String -> Attribute msg parts
k1 =
    attribute "k1"


{-| -}
k2 : String -> Attribute msg parts
k2 =
    attribute "k2"


{-| -}
k3 : String -> Attribute msg parts
k3 =
    attribute "k3"


{-| -}
k4 : String -> Attribute msg parts
k4 =
    attribute "k4"


{-| -}
kernelMatrix : String -> Attribute msg parts
kernelMatrix =
    attribute "kernelMatrix"


{-| -}
kernelUnitLength : String -> Attribute msg parts
kernelUnitLength =
    attribute "kernelUnitLength"


{-| -}
keyPoints : String -> Attribute msg parts
keyPoints =
    attribute "keyPoints"


{-| -}
keySplines : String -> Attribute msg parts
keySplines =
    attribute "keySplines"


{-| -}
keyTimes : String -> Attribute msg parts
keyTimes =
    attribute "keyTimes"


{-| -}
lang : String -> Attribute msg parts
lang =
    attribute "lang"


{-| -}
lengthAdjust : String -> Attribute msg parts
lengthAdjust =
    attribute "lengthAdjust"


{-| -}
limitingConeAngle : String -> Attribute msg parts
limitingConeAngle =
    attribute "limitingConeAngle"


{-| -}
local : String -> Attribute msg parts
local =
    attribute "local"


{-| -}
markerHeight : String -> Attribute msg parts
markerHeight =
    attribute "markerHeight"


{-| -}
markerUnits : String -> Attribute msg parts
markerUnits =
    attribute "markerUnits"


{-| -}
markerWidth : String -> Attribute msg parts
markerWidth =
    attribute "markerWidth"


{-| -}
maskContentUnits : String -> Attribute msg parts
maskContentUnits =
    attribute "maskContentUnits"


{-| -}
maskUnits : String -> Attribute msg parts
maskUnits =
    attribute "maskUnits"


{-| -}
mathematical : String -> Attribute msg parts
mathematical =
    attribute "mathematical"


{-| -}
max : String -> Attribute msg parts
max =
    attribute "max"


{-| -}
media : String -> Attribute msg parts
media =
    attribute "media"


{-| -}
method : String -> Attribute msg parts
method =
    attribute "method"


{-| -}
min : String -> Attribute msg parts
min =
    attribute "min"


{-| -}
mode : String -> Attribute msg parts
mode =
    attribute "mode"


{-| -}
name : String -> Attribute msg parts
name =
    attribute "name"


{-| -}
numOctaves : String -> Attribute msg parts
numOctaves =
    attribute "numOctaves"


{-| -}
offset : String -> Attribute msg parts
offset =
    attribute "offset"


{-| -}
operator : String -> Attribute msg parts
operator =
    attribute "operator"


{-| -}
order : String -> Attribute msg parts
order =
    attribute "order"


{-| -}
orient : String -> Attribute msg parts
orient =
    attribute "orient"


{-| -}
orientation : String -> Attribute msg parts
orientation =
    attribute "orientation"


{-| -}
origin : String -> Attribute msg parts
origin =
    attribute "origin"


{-| -}
overlinePosition : String -> Attribute msg parts
overlinePosition =
    attribute "overline-position"


{-| -}
overlineThickness : String -> Attribute msg parts
overlineThickness =
    attribute "overline-thickness"


{-| -}
panose1 : String -> Attribute msg parts
panose1 =
    attribute "panose-1"


{-| -}
path : String -> Attribute msg parts
path =
    attribute "path"


{-| -}
pathLength : String -> Attribute msg parts
pathLength =
    attribute "pathLength"


{-| -}
patternContentUnits : String -> Attribute msg parts
patternContentUnits =
    attribute "patternContentUnits"


{-| -}
patternTransform : String -> Attribute msg parts
patternTransform =
    attribute "patternTransform"


{-| -}
patternUnits : String -> Attribute msg parts
patternUnits =
    attribute "patternUnits"


{-| -}
pointOrder : String -> Attribute msg parts
pointOrder =
    attribute "point-order"


{-| -}
points : String -> Attribute msg parts
points =
    attribute "points"


{-| -}
pointsAtX : String -> Attribute msg parts
pointsAtX =
    attribute "pointsAtX"


{-| -}
pointsAtY : String -> Attribute msg parts
pointsAtY =
    attribute "pointsAtY"


{-| -}
pointsAtZ : String -> Attribute msg parts
pointsAtZ =
    attribute "pointsAtZ"


{-| -}
preserveAlpha : String -> Attribute msg parts
preserveAlpha =
    attribute "preserveAlpha"


{-| -}
preserveAspectRatio : String -> Attribute msg parts
preserveAspectRatio =
    attribute "preserveAspectRatio"


{-| -}
primitiveUnits : String -> Attribute msg parts
primitiveUnits =
    attribute "primitiveUnits"


{-| -}
r : String -> Attribute msg parts
r =
    attribute "r"


{-| -}
radius : String -> Attribute msg parts
radius =
    attribute "radius"


{-| -}
refX : String -> Attribute msg parts
refX =
    attribute "refX"


{-| -}
refY : String -> Attribute msg parts
refY =
    attribute "refY"


{-| -}
renderingIntent : String -> Attribute msg parts
renderingIntent =
    attribute "rendering-intent"


{-| -}
repeatCount : String -> Attribute msg parts
repeatCount =
    attribute "repeatCount"


{-| -}
repeatDur : String -> Attribute msg parts
repeatDur =
    attribute "repeatDur"


{-| -}
requiredExtensions : String -> Attribute msg parts
requiredExtensions =
    attribute "requiredExtensions"


{-| -}
requiredFeatures : String -> Attribute msg parts
requiredFeatures =
    attribute "requiredFeatures"


{-| -}
restart : String -> Attribute msg parts
restart =
    attribute "restart"


{-| -}
result : String -> Attribute msg parts
result =
    attribute "result"


{-| -}
rotate : String -> Attribute msg parts
rotate =
    attribute "rotate"


{-| -}
rx : String -> Attribute msg parts
rx =
    attribute "rx"


{-| -}
ry : String -> Attribute msg parts
ry =
    attribute "ry"


{-| -}
scale : String -> Attribute msg parts
scale =
    attribute "scale"


{-| -}
seed : String -> Attribute msg parts
seed =
    attribute "seed"


{-| -}
slope : String -> Attribute msg parts
slope =
    attribute "slope"


{-| -}
spacing : String -> Attribute msg parts
spacing =
    attribute "spacing"


{-| -}
specularConstant : String -> Attribute msg parts
specularConstant =
    attribute "specularConstant"


{-| -}
specularExponent : String -> Attribute msg parts
specularExponent =
    attribute "specularExponent"


{-| -}
speed : String -> Attribute msg parts
speed =
    attribute "speed"


{-| -}
spreadMethod : String -> Attribute msg parts
spreadMethod =
    attribute "spreadMethod"


{-| -}
startOffset : String -> Attribute msg parts
startOffset =
    attribute "startOffset"


{-| -}
stdDeviation : String -> Attribute msg parts
stdDeviation =
    attribute "stdDeviation"


{-| -}
stemh : String -> Attribute msg parts
stemh =
    attribute "stemh"


{-| -}
stemv : String -> Attribute msg parts
stemv =
    attribute "stemv"


{-| -}
stitchTiles : String -> Attribute msg parts
stitchTiles =
    attribute "stitchTiles"


{-| -}
strikethroughPosition : String -> Attribute msg parts
strikethroughPosition =
    attribute "strikethrough-position"


{-| -}
strikethroughThickness : String -> Attribute msg parts
strikethroughThickness =
    attribute "strikethrough-thickness"


{-| -}
string : String -> Attribute msg parts
string =
    attribute "string"


{-| -}
surfaceScale : String -> Attribute msg parts
surfaceScale =
    attribute "surfaceScale"


{-| -}
systemLanguage : String -> Attribute msg parts
systemLanguage =
    attribute "systemLanguage"


{-| -}
tableValues : String -> Attribute msg parts
tableValues =
    attribute "tableValues"


{-| -}
target : String -> Attribute msg parts
target =
    attribute "target"


{-| -}
targetX : String -> Attribute msg parts
targetX =
    attribute "targetX"


{-| -}
targetY : String -> Attribute msg parts
targetY =
    attribute "targetY"


{-| -}
textLength : String -> Attribute msg parts
textLength =
    attribute "textLength"


{-| -}
title : String -> Attribute msg parts
title =
    attribute "title"


{-| -}
to : String -> Attribute msg parts
to =
    attribute "to"


{-| -}
transform : String -> Attribute msg parts
transform =
    attribute "transform"


{-| -}
type_ : String -> Attribute msg parts
type_ =
    attribute "type"


{-| -}
u1 : String -> Attribute msg parts
u1 =
    attribute "u1"


{-| -}
u2 : String -> Attribute msg parts
u2 =
    attribute "u2"


{-| -}
underlinePosition : String -> Attribute msg parts
underlinePosition =
    attribute "underline-position"


{-| -}
underlineThickness : String -> Attribute msg parts
underlineThickness =
    attribute "underline-thickness"


{-| -}
unicode : String -> Attribute msg parts
unicode =
    attribute "unicode"


{-| -}
unicodeRange : String -> Attribute msg parts
unicodeRange =
    attribute "unicode-range"


{-| -}
unitsPerEm : String -> Attribute msg parts
unitsPerEm =
    attribute "units-per-em"


{-| -}
vAlphabetic : String -> Attribute msg parts
vAlphabetic =
    attribute "v-alphabetic"


{-| -}
vHanging : String -> Attribute msg parts
vHanging =
    attribute "v-hanging"


{-| -}
vIdeographic : String -> Attribute msg parts
vIdeographic =
    attribute "v-ideographic"


{-| -}
vMathematical : String -> Attribute msg parts
vMathematical =
    attribute "v-mathematical"


{-| -}
values : String -> Attribute msg parts
values =
    attribute "values"


{-| -}
version : String -> Attribute msg parts
version =
    attribute "version"


{-| -}
vertAdvY : String -> Attribute msg parts
vertAdvY =
    attribute "vert-adv-y"


{-| -}
vertOriginX : String -> Attribute msg parts
vertOriginX =
    attribute "vert-origin-x"


{-| -}
vertOriginY : String -> Attribute msg parts
vertOriginY =
    attribute "vert-origin-y"


{-| -}
viewBox : String -> Attribute msg parts
viewBox =
    attribute "viewBox"


{-| -}
viewTarget : String -> Attribute msg parts
viewTarget =
    attribute "viewTarget"


{-| -}
width : String -> Attribute msg parts
width =
    attribute "width"


{-| -}
widths : String -> Attribute msg parts
widths =
    attribute "widths"


{-| -}
x : String -> Attribute msg parts
x =
    attribute "x"


{-| -}
xHeight : String -> Attribute msg parts
xHeight =
    attribute "x-height"


{-| -}
x1 : String -> Attribute msg parts
x1 =
    attribute "x1"


{-| -}
x2 : String -> Attribute msg parts
x2 =
    attribute "x2"


{-| -}
xChannelSelector : String -> Attribute msg parts
xChannelSelector =
    attribute "xChannelSelector"


{-| -}
xlinkActuate : String -> Attribute msg parts
xlinkActuate =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:actuate"


{-| -}
xlinkArcrole : String -> Attribute msg parts
xlinkArcrole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:arcrole"


{-| -}
xlinkHref : String -> Attribute msg parts
xlinkHref =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:href"


{-| -}
xlinkRole : String -> Attribute msg parts
xlinkRole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:role"


{-| -}
xlinkShow : String -> Attribute msg parts
xlinkShow =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:show"


{-| -}
xlinkTitle : String -> Attribute msg parts
xlinkTitle =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:title"


{-| -}
xlinkType : String -> Attribute msg parts
xlinkType =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:type"


{-| -}
xmlBase : String -> Attribute msg parts
xmlBase =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:base"


{-| -}
xmlLang : String -> Attribute msg parts
xmlLang =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:lang"


{-| -}
xmlSpace : String -> Attribute msg parts
xmlSpace =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:space"


{-| -}
y : String -> Attribute msg parts
y =
    attribute "y"


{-| -}
y1 : String -> Attribute msg parts
y1 =
    attribute "y1"


{-| -}
y2 : String -> Attribute msg parts
y2 =
    attribute "y2"


{-| -}
yChannelSelector : String -> Attribute msg parts
yChannelSelector =
    attribute "yChannelSelector"


{-| -}
z : String -> Attribute msg parts
z =
    attribute "z"


{-| -}
zoomAndPan : String -> Attribute msg parts
zoomAndPan =
    attribute "zoomAndPan"



-- Presentation attributes


{-| -}
alignmentBaseline : String -> Attribute msg parts
alignmentBaseline =
    attribute "alignment-baseline"


{-| -}
baselineShift : String -> Attribute msg parts
baselineShift =
    attribute "baseline-shift"


{-| -}
clipPath : String -> Attribute msg parts
clipPath =
    attribute "clip-path"


{-| -}
clipRule : String -> Attribute msg parts
clipRule =
    attribute "clip-rule"


{-| -}
clip : String -> Attribute msg parts
clip =
    attribute "clip"


{-| -}
colorInterpolationFilters : String -> Attribute msg parts
colorInterpolationFilters =
    attribute "color-interpolation-filters"


{-| -}
colorInterpolation : String -> Attribute msg parts
colorInterpolation =
    attribute "color-interpolation"


{-| -}
colorProfile : String -> Attribute msg parts
colorProfile =
    attribute "color-profile"


{-| -}
colorRendering : String -> Attribute msg parts
colorRendering =
    attribute "color-rendering"


{-| -}
color : String -> Attribute msg parts
color =
    attribute "color"


{-| -}
cursor : String -> Attribute msg parts
cursor =
    attribute "cursor"


{-| -}
direction : String -> Attribute msg parts
direction =
    attribute "direction"


{-| -}
display : String -> Attribute msg parts
display =
    attribute "display"


{-| -}
dominantBaseline : String -> Attribute msg parts
dominantBaseline =
    attribute "dominant-baseline"


{-| -}
enableBackground : String -> Attribute msg parts
enableBackground =
    attribute "enable-background"


{-| -}
fillOpacity : String -> Attribute msg parts
fillOpacity =
    attribute "fill-opacity"


{-| -}
fillRule : String -> Attribute msg parts
fillRule =
    attribute "fill-rule"


{-| -}
fill : String -> Attribute msg parts
fill =
    attribute "fill"


{-| -}
filter : String -> Attribute msg parts
filter =
    attribute "filter"


{-| -}
floodColor : String -> Attribute msg parts
floodColor =
    attribute "flood-color"


{-| -}
floodOpacity : String -> Attribute msg parts
floodOpacity =
    attribute "flood-opacity"


{-| -}
fontFamily : String -> Attribute msg parts
fontFamily =
    attribute "font-family"


{-| -}
fontSizeAdjust : String -> Attribute msg parts
fontSizeAdjust =
    attribute "font-size-adjust"


{-| -}
fontSize : String -> Attribute msg parts
fontSize =
    attribute "font-size"


{-| -}
fontStretch : String -> Attribute msg parts
fontStretch =
    attribute "font-stretch"


{-| -}
fontStyle : String -> Attribute msg parts
fontStyle =
    attribute "font-style"


{-| -}
fontVariant : String -> Attribute msg parts
fontVariant =
    attribute "font-variant"


{-| -}
fontWeight : String -> Attribute msg parts
fontWeight =
    attribute "font-weight"


{-| -}
glyphOrientationHorizontal : String -> Attribute msg parts
glyphOrientationHorizontal =
    attribute "glyph-orientation-horizontal"


{-| -}
glyphOrientationVertical : String -> Attribute msg parts
glyphOrientationVertical =
    attribute "glyph-orientation-vertical"


{-| -}
imageRendering : String -> Attribute msg parts
imageRendering =
    attribute "image-rendering"


{-| -}
kerning : String -> Attribute msg parts
kerning =
    attribute "kerning"


{-| -}
letterSpacing : String -> Attribute msg parts
letterSpacing =
    attribute "letter-spacing"


{-| -}
lightingColor : String -> Attribute msg parts
lightingColor =
    attribute "lighting-color"


{-| -}
markerEnd : String -> Attribute msg parts
markerEnd =
    attribute "marker-end"


{-| -}
markerMid : String -> Attribute msg parts
markerMid =
    attribute "marker-mid"


{-| -}
markerStart : String -> Attribute msg parts
markerStart =
    attribute "marker-start"


{-| -}
mask : String -> Attribute msg parts
mask =
    attribute "mask"


{-| -}
opacity : String -> Attribute msg parts
opacity =
    attribute "opacity"


{-| -}
overflow : String -> Attribute msg parts
overflow =
    attribute "overflow"


{-| -}
pointerEvents : String -> Attribute msg parts
pointerEvents =
    attribute "pointer-events"


{-| -}
shapeRendering : String -> Attribute msg parts
shapeRendering =
    attribute "shape-rendering"


{-| -}
stopColor : String -> Attribute msg parts
stopColor =
    attribute "stop-color"


{-| -}
stopOpacity : String -> Attribute msg parts
stopOpacity =
    attribute "stop-opacity"


{-| -}
strokeDasharray : String -> Attribute msg parts
strokeDasharray =
    attribute "stroke-dasharray"


{-| -}
strokeDashoffset : String -> Attribute msg parts
strokeDashoffset =
    attribute "stroke-dashoffset"


{-| -}
strokeLinecap : String -> Attribute msg parts
strokeLinecap =
    attribute "stroke-linecap"


{-| -}
strokeLinejoin : String -> Attribute msg parts
strokeLinejoin =
    attribute "stroke-linejoin"


{-| -}
strokeMiterlimit : String -> Attribute msg parts
strokeMiterlimit =
    attribute "stroke-miterlimit"


{-| -}
strokeOpacity : String -> Attribute msg parts
strokeOpacity =
    attribute "stroke-opacity"


{-| -}
strokeWidth : String -> Attribute msg parts
strokeWidth =
    attribute "stroke-width"


{-| -}
stroke : String -> Attribute msg parts
stroke =
    attribute "stroke"


{-| -}
textAnchor : String -> Attribute msg parts
textAnchor =
    attribute "text-anchor"


{-| -}
textDecoration : String -> Attribute msg parts
textDecoration =
    attribute "text-decoration"


{-| -}
textRendering : String -> Attribute msg parts
textRendering =
    attribute "text-rendering"


{-| -}
unicodeBidi : String -> Attribute msg parts
unicodeBidi =
    attribute "unicode-bidi"


{-| -}
visibility : String -> Attribute msg parts
visibility =
    attribute "visibility"


{-| -}
wordSpacing : String -> Attribute msg parts
wordSpacing =
    attribute "word-spacing"


{-| -}
writingMode : String -> Attribute msg parts
writingMode =
    attribute "writing-mode"
