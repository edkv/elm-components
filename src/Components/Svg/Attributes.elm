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
        , inlineStyles
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
        , styles
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

{-|


# Custom attributes

@docs attribute, attributeNS


# CSS

@docs styles, inlineStyles


# Regular attributes

@docs accentHeight, accelerate, accumulate, additive, alphabetic, allowReorder, amplitude, arabicForm, ascent, attributeName, attributeType, autoReverse, azimuth, baseFrequency, baseProfile, bbox, begin, bias, by, calcMode, capHeight, class, clipPathUnits, contentScriptType, contentStyleType, cx, cy, d, decelerate, descent, diffuseConstant, divisor, dur, dx, dy, edgeMode, elevation, end, exponent, externalResourcesRequired, filterRes, filterUnits, format, from, fx, fy, g1, g2, glyphName, glyphRef, gradientTransform, gradientUnits, hanging, height, horizAdvX, horizOriginX, horizOriginY, id, ideographic, in_, in2, intercept, k, k1, k2, k3, k4, kernelMatrix, kernelUnitLength, keyPoints, keySplines, keyTimes, lang, lengthAdjust, limitingConeAngle, local, markerHeight, markerUnits, markerWidth, maskContentUnits, maskUnits, mathematical, max, media, method, min, mode, name, numOctaves, offset, operator, order, orient, orientation, origin, overlinePosition, overlineThickness, panose1, path, pathLength, patternContentUnits, patternTransform, patternUnits, pointOrder, points, pointsAtX, pointsAtY, pointsAtZ, preserveAlpha, preserveAspectRatio, primitiveUnits, r, radius, refX, refY, renderingIntent, repeatCount, repeatDur, requiredExtensions, requiredFeatures, restart, result, rotate, rx, ry, scale, seed, slope, spacing, specularConstant, specularExponent, speed, spreadMethod, startOffset, stdDeviation, stemh, stemv, stitchTiles, strikethroughPosition, strikethroughThickness, string, style, surfaceScale, systemLanguage, tableValues, target, targetX, targetY, textLength, title, to, transform, type_, u1, u2, underlinePosition, underlineThickness, unicode, unicodeRange, unitsPerEm, vAlphabetic, vHanging, vIdeographic, vMathematical, values, version, vertAdvY, vertOriginX, vertOriginY, viewBox, viewTarget, width, widths, x, xHeight, x1, x2, xChannelSelector, xlinkActuate, xlinkArcrole, xlinkHref, xlinkRole, xlinkShow, xlinkTitle, xlinkType, xmlBase, xmlLang, xmlSpace, y, y1, y2, yChannelSelector, z, zoomAndPan


# Presentation attributes

@docs alignmentBaseline, baselineShift, clipPath, clipRule, clip, colorInterpolationFilters, colorInterpolation, colorProfile, colorRendering, color, cursor, direction, display, dominantBaseline, enableBackground, fillOpacity, fillRule, fill, filter, floodColor, floodOpacity, fontFamily, fontSizeAdjust, fontSize, fontStretch, fontStyle, fontVariant, fontWeight, glyphOrientationHorizontal, glyphOrientationVertical, imageRendering, kerning, letterSpacing, lightingColor, markerEnd, markerMid, markerStart, mask, opacity, overflow, pointerEvents, shapeRendering, stopColor, stopOpacity, strokeDasharray, strokeDashoffset, strokeLinecap, strokeLinejoin, strokeMiterlimit, strokeOpacity, strokeWidth, stroke, textAnchor, textDecoration, textRendering, unicodeBidi, visibility, wordSpacing, writingMode

-}

import Components.Internal.Core as Core
import Components.Svg exposing (Attribute)
import Css
import VirtualDom


-- Custom attributes


{-| Create a custom attribute.
-}
attribute : String -> String -> Attribute m c
attribute key value =
    VirtualDom.attribute key value
        |> Core.PlainAttribute


{-| Create a custom "namespaced" attribute. This corresponds to JavaScript's
`setAttributeNS` function under the hood.
-}
attributeNS : String -> String -> String -> Attribute m c
attributeNS namespace key value =
    VirtualDom.attributeNS namespace key value
        |> Core.PlainAttribute



-- CSS


{-| Apply styles to an element. See the
[`Css` module documentation](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css)
for an overview of how to use this function.
-}
styles : List Css.Style -> Attribute m c
styles =
    Core.Styles Core.ClassAttribute


{-| Specify a list of inline styles. This will generate a `style` attribute in
the DOM.
-}
inlineStyles : List ( String, String ) -> Attribute m c
inlineStyles =
    VirtualDom.style >> Core.PlainAttribute



-- Regular attributes


{-| -}
accentHeight : String -> Attribute m c
accentHeight =
    attribute "accent-height"


{-| -}
accelerate : String -> Attribute m c
accelerate =
    attribute "accelerate"


{-| -}
accumulate : String -> Attribute m c
accumulate =
    attribute "accumulate"


{-| -}
additive : String -> Attribute m c
additive =
    attribute "additive"


{-| -}
alphabetic : String -> Attribute m c
alphabetic =
    attribute "alphabetic"


{-| -}
allowReorder : String -> Attribute m c
allowReorder =
    attribute "allowReorder"


{-| -}
amplitude : String -> Attribute m c
amplitude =
    attribute "amplitude"


{-| -}
arabicForm : String -> Attribute m c
arabicForm =
    attribute "arabic-form"


{-| -}
ascent : String -> Attribute m c
ascent =
    attribute "ascent"


{-| -}
attributeName : String -> Attribute m c
attributeName =
    attribute "attributeName"


{-| -}
attributeType : String -> Attribute m c
attributeType =
    attribute "attributeType"


{-| -}
autoReverse : String -> Attribute m c
autoReverse =
    attribute "autoReverse"


{-| -}
azimuth : String -> Attribute m c
azimuth =
    attribute "azimuth"


{-| -}
baseFrequency : String -> Attribute m c
baseFrequency =
    attribute "baseFrequency"


{-| -}
baseProfile : String -> Attribute m c
baseProfile =
    attribute "baseProfile"


{-| -}
bbox : String -> Attribute m c
bbox =
    attribute "bbox"


{-| -}
begin : String -> Attribute m c
begin =
    attribute "begin"


{-| -}
bias : String -> Attribute m c
bias =
    attribute "bias"


{-| -}
by : String -> Attribute m c
by =
    attribute "by"


{-| -}
calcMode : String -> Attribute m c
calcMode =
    attribute "calcMode"


{-| -}
capHeight : String -> Attribute m c
capHeight =
    attribute "cap-height"


{-| -}
class : String -> Attribute m c
class =
    attribute "class"


{-| -}
clipPathUnits : String -> Attribute m c
clipPathUnits =
    attribute "clipPathUnits"


{-| -}
contentScriptType : String -> Attribute m c
contentScriptType =
    attribute "contentScriptType"


{-| -}
contentStyleType : String -> Attribute m c
contentStyleType =
    attribute "contentStyleType"


{-| -}
cx : String -> Attribute m c
cx =
    attribute "cx"


{-| -}
cy : String -> Attribute m c
cy =
    attribute "cy"


{-| -}
d : String -> Attribute m c
d =
    attribute "d"


{-| -}
decelerate : String -> Attribute m c
decelerate =
    attribute "decelerate"


{-| -}
descent : String -> Attribute m c
descent =
    attribute "descent"


{-| -}
diffuseConstant : String -> Attribute m c
diffuseConstant =
    attribute "diffuseConstant"


{-| -}
divisor : String -> Attribute m c
divisor =
    attribute "divisor"


{-| -}
dur : String -> Attribute m c
dur =
    attribute "dur"


{-| -}
dx : String -> Attribute m c
dx =
    attribute "dx"


{-| -}
dy : String -> Attribute m c
dy =
    attribute "dy"


{-| -}
edgeMode : String -> Attribute m c
edgeMode =
    attribute "edgeMode"


{-| -}
elevation : String -> Attribute m c
elevation =
    attribute "elevation"


{-| -}
end : String -> Attribute m c
end =
    attribute "end"


{-| -}
exponent : String -> Attribute m c
exponent =
    attribute "exponent"


{-| -}
externalResourcesRequired : String -> Attribute m c
externalResourcesRequired =
    attribute "externalResourcesRequired"


{-| -}
filterRes : String -> Attribute m c
filterRes =
    attribute "filterRes"


{-| -}
filterUnits : String -> Attribute m c
filterUnits =
    attribute "filterUnits"


{-| -}
format : String -> Attribute m c
format =
    attribute "format"


{-| -}
from : String -> Attribute m c
from =
    attribute "from"


{-| -}
fx : String -> Attribute m c
fx =
    attribute "fx"


{-| -}
fy : String -> Attribute m c
fy =
    attribute "fy"


{-| -}
g1 : String -> Attribute m c
g1 =
    attribute "g1"


{-| -}
g2 : String -> Attribute m c
g2 =
    attribute "g2"


{-| -}
glyphName : String -> Attribute m c
glyphName =
    attribute "glyph-name"


{-| -}
glyphRef : String -> Attribute m c
glyphRef =
    attribute "glyphRef"


{-| -}
gradientTransform : String -> Attribute m c
gradientTransform =
    attribute "gradientTransform"


{-| -}
gradientUnits : String -> Attribute m c
gradientUnits =
    attribute "gradientUnits"


{-| -}
hanging : String -> Attribute m c
hanging =
    attribute "hanging"


{-| -}
height : String -> Attribute m c
height =
    attribute "height"


{-| -}
horizAdvX : String -> Attribute m c
horizAdvX =
    attribute "horiz-adv-x"


{-| -}
horizOriginX : String -> Attribute m c
horizOriginX =
    attribute "horiz-origin-x"


{-| -}
horizOriginY : String -> Attribute m c
horizOriginY =
    attribute "horiz-origin-y"


{-| -}
id : String -> Attribute m c
id =
    attribute "id"


{-| -}
ideographic : String -> Attribute m c
ideographic =
    attribute "ideographic"


{-| -}
in_ : String -> Attribute m c
in_ =
    attribute "in"


{-| -}
in2 : String -> Attribute m c
in2 =
    attribute "in2"


{-| -}
intercept : String -> Attribute m c
intercept =
    attribute "intercept"


{-| -}
k : String -> Attribute m c
k =
    attribute "k"


{-| -}
k1 : String -> Attribute m c
k1 =
    attribute "k1"


{-| -}
k2 : String -> Attribute m c
k2 =
    attribute "k2"


{-| -}
k3 : String -> Attribute m c
k3 =
    attribute "k3"


{-| -}
k4 : String -> Attribute m c
k4 =
    attribute "k4"


{-| -}
kernelMatrix : String -> Attribute m c
kernelMatrix =
    attribute "kernelMatrix"


{-| -}
kernelUnitLength : String -> Attribute m c
kernelUnitLength =
    attribute "kernelUnitLength"


{-| -}
keyPoints : String -> Attribute m c
keyPoints =
    attribute "keyPoints"


{-| -}
keySplines : String -> Attribute m c
keySplines =
    attribute "keySplines"


{-| -}
keyTimes : String -> Attribute m c
keyTimes =
    attribute "keyTimes"


{-| -}
lang : String -> Attribute m c
lang =
    attribute "lang"


{-| -}
lengthAdjust : String -> Attribute m c
lengthAdjust =
    attribute "lengthAdjust"


{-| -}
limitingConeAngle : String -> Attribute m c
limitingConeAngle =
    attribute "limitingConeAngle"


{-| -}
local : String -> Attribute m c
local =
    attribute "local"


{-| -}
markerHeight : String -> Attribute m c
markerHeight =
    attribute "markerHeight"


{-| -}
markerUnits : String -> Attribute m c
markerUnits =
    attribute "markerUnits"


{-| -}
markerWidth : String -> Attribute m c
markerWidth =
    attribute "markerWidth"


{-| -}
maskContentUnits : String -> Attribute m c
maskContentUnits =
    attribute "maskContentUnits"


{-| -}
maskUnits : String -> Attribute m c
maskUnits =
    attribute "maskUnits"


{-| -}
mathematical : String -> Attribute m c
mathematical =
    attribute "mathematical"


{-| -}
max : String -> Attribute m c
max =
    attribute "max"


{-| -}
media : String -> Attribute m c
media =
    attribute "media"


{-| -}
method : String -> Attribute m c
method =
    attribute "method"


{-| -}
min : String -> Attribute m c
min =
    attribute "min"


{-| -}
mode : String -> Attribute m c
mode =
    attribute "mode"


{-| -}
name : String -> Attribute m c
name =
    attribute "name"


{-| -}
numOctaves : String -> Attribute m c
numOctaves =
    attribute "numOctaves"


{-| -}
offset : String -> Attribute m c
offset =
    attribute "offset"


{-| -}
operator : String -> Attribute m c
operator =
    attribute "operator"


{-| -}
order : String -> Attribute m c
order =
    attribute "order"


{-| -}
orient : String -> Attribute m c
orient =
    attribute "orient"


{-| -}
orientation : String -> Attribute m c
orientation =
    attribute "orientation"


{-| -}
origin : String -> Attribute m c
origin =
    attribute "origin"


{-| -}
overlinePosition : String -> Attribute m c
overlinePosition =
    attribute "overline-position"


{-| -}
overlineThickness : String -> Attribute m c
overlineThickness =
    attribute "overline-thickness"


{-| -}
panose1 : String -> Attribute m c
panose1 =
    attribute "panose-1"


{-| -}
path : String -> Attribute m c
path =
    attribute "path"


{-| -}
pathLength : String -> Attribute m c
pathLength =
    attribute "pathLength"


{-| -}
patternContentUnits : String -> Attribute m c
patternContentUnits =
    attribute "patternContentUnits"


{-| -}
patternTransform : String -> Attribute m c
patternTransform =
    attribute "patternTransform"


{-| -}
patternUnits : String -> Attribute m c
patternUnits =
    attribute "patternUnits"


{-| -}
pointOrder : String -> Attribute m c
pointOrder =
    attribute "point-order"


{-| -}
points : String -> Attribute m c
points =
    attribute "points"


{-| -}
pointsAtX : String -> Attribute m c
pointsAtX =
    attribute "pointsAtX"


{-| -}
pointsAtY : String -> Attribute m c
pointsAtY =
    attribute "pointsAtY"


{-| -}
pointsAtZ : String -> Attribute m c
pointsAtZ =
    attribute "pointsAtZ"


{-| -}
preserveAlpha : String -> Attribute m c
preserveAlpha =
    attribute "preserveAlpha"


{-| -}
preserveAspectRatio : String -> Attribute m c
preserveAspectRatio =
    attribute "preserveAspectRatio"


{-| -}
primitiveUnits : String -> Attribute m c
primitiveUnits =
    attribute "primitiveUnits"


{-| -}
r : String -> Attribute m c
r =
    attribute "r"


{-| -}
radius : String -> Attribute m c
radius =
    attribute "radius"


{-| -}
refX : String -> Attribute m c
refX =
    attribute "refX"


{-| -}
refY : String -> Attribute m c
refY =
    attribute "refY"


{-| -}
renderingIntent : String -> Attribute m c
renderingIntent =
    attribute "rendering-intent"


{-| -}
repeatCount : String -> Attribute m c
repeatCount =
    attribute "repeatCount"


{-| -}
repeatDur : String -> Attribute m c
repeatDur =
    attribute "repeatDur"


{-| -}
requiredExtensions : String -> Attribute m c
requiredExtensions =
    attribute "requiredExtensions"


{-| -}
requiredFeatures : String -> Attribute m c
requiredFeatures =
    attribute "requiredFeatures"


{-| -}
restart : String -> Attribute m c
restart =
    attribute "restart"


{-| -}
result : String -> Attribute m c
result =
    attribute "result"


{-| -}
rotate : String -> Attribute m c
rotate =
    attribute "rotate"


{-| -}
rx : String -> Attribute m c
rx =
    attribute "rx"


{-| -}
ry : String -> Attribute m c
ry =
    attribute "ry"


{-| -}
scale : String -> Attribute m c
scale =
    attribute "scale"


{-| -}
seed : String -> Attribute m c
seed =
    attribute "seed"


{-| -}
slope : String -> Attribute m c
slope =
    attribute "slope"


{-| -}
spacing : String -> Attribute m c
spacing =
    attribute "spacing"


{-| -}
specularConstant : String -> Attribute m c
specularConstant =
    attribute "specularConstant"


{-| -}
specularExponent : String -> Attribute m c
specularExponent =
    attribute "specularExponent"


{-| -}
speed : String -> Attribute m c
speed =
    attribute "speed"


{-| -}
spreadMethod : String -> Attribute m c
spreadMethod =
    attribute "spreadMethod"


{-| -}
startOffset : String -> Attribute m c
startOffset =
    attribute "startOffset"


{-| -}
stdDeviation : String -> Attribute m c
stdDeviation =
    attribute "stdDeviation"


{-| -}
stemh : String -> Attribute m c
stemh =
    attribute "stemh"


{-| -}
stemv : String -> Attribute m c
stemv =
    attribute "stemv"


{-| -}
stitchTiles : String -> Attribute m c
stitchTiles =
    attribute "stitchTiles"


{-| -}
strikethroughPosition : String -> Attribute m c
strikethroughPosition =
    attribute "strikethrough-position"


{-| -}
strikethroughThickness : String -> Attribute m c
strikethroughThickness =
    attribute "strikethrough-thickness"


{-| -}
string : String -> Attribute m c
string =
    attribute "string"


{-| -}
surfaceScale : String -> Attribute m c
surfaceScale =
    attribute "surfaceScale"


{-| -}
systemLanguage : String -> Attribute m c
systemLanguage =
    attribute "systemLanguage"


{-| -}
tableValues : String -> Attribute m c
tableValues =
    attribute "tableValues"


{-| -}
target : String -> Attribute m c
target =
    attribute "target"


{-| -}
targetX : String -> Attribute m c
targetX =
    attribute "targetX"


{-| -}
targetY : String -> Attribute m c
targetY =
    attribute "targetY"


{-| -}
textLength : String -> Attribute m c
textLength =
    attribute "textLength"


{-| -}
title : String -> Attribute m c
title =
    attribute "title"


{-| -}
to : String -> Attribute m c
to =
    attribute "to"


{-| -}
transform : String -> Attribute m c
transform =
    attribute "transform"


{-| -}
type_ : String -> Attribute m c
type_ =
    attribute "type"


{-| -}
u1 : String -> Attribute m c
u1 =
    attribute "u1"


{-| -}
u2 : String -> Attribute m c
u2 =
    attribute "u2"


{-| -}
underlinePosition : String -> Attribute m c
underlinePosition =
    attribute "underline-position"


{-| -}
underlineThickness : String -> Attribute m c
underlineThickness =
    attribute "underline-thickness"


{-| -}
unicode : String -> Attribute m c
unicode =
    attribute "unicode"


{-| -}
unicodeRange : String -> Attribute m c
unicodeRange =
    attribute "unicode-range"


{-| -}
unitsPerEm : String -> Attribute m c
unitsPerEm =
    attribute "units-per-em"


{-| -}
vAlphabetic : String -> Attribute m c
vAlphabetic =
    attribute "v-alphabetic"


{-| -}
vHanging : String -> Attribute m c
vHanging =
    attribute "v-hanging"


{-| -}
vIdeographic : String -> Attribute m c
vIdeographic =
    attribute "v-ideographic"


{-| -}
vMathematical : String -> Attribute m c
vMathematical =
    attribute "v-mathematical"


{-| -}
values : String -> Attribute m c
values =
    attribute "values"


{-| -}
version : String -> Attribute m c
version =
    attribute "version"


{-| -}
vertAdvY : String -> Attribute m c
vertAdvY =
    attribute "vert-adv-y"


{-| -}
vertOriginX : String -> Attribute m c
vertOriginX =
    attribute "vert-origin-x"


{-| -}
vertOriginY : String -> Attribute m c
vertOriginY =
    attribute "vert-origin-y"


{-| -}
viewBox : String -> Attribute m c
viewBox =
    attribute "viewBox"


{-| -}
viewTarget : String -> Attribute m c
viewTarget =
    attribute "viewTarget"


{-| -}
width : String -> Attribute m c
width =
    attribute "width"


{-| -}
widths : String -> Attribute m c
widths =
    attribute "widths"


{-| -}
x : String -> Attribute m c
x =
    attribute "x"


{-| -}
xHeight : String -> Attribute m c
xHeight =
    attribute "x-height"


{-| -}
x1 : String -> Attribute m c
x1 =
    attribute "x1"


{-| -}
x2 : String -> Attribute m c
x2 =
    attribute "x2"


{-| -}
xChannelSelector : String -> Attribute m c
xChannelSelector =
    attribute "xChannelSelector"


{-| -}
xlinkActuate : String -> Attribute m c
xlinkActuate =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:actuate"


{-| -}
xlinkArcrole : String -> Attribute m c
xlinkArcrole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:arcrole"


{-| -}
xlinkHref : String -> Attribute m c
xlinkHref =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:href"


{-| -}
xlinkRole : String -> Attribute m c
xlinkRole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:role"


{-| -}
xlinkShow : String -> Attribute m c
xlinkShow =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:show"


{-| -}
xlinkTitle : String -> Attribute m c
xlinkTitle =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:title"


{-| -}
xlinkType : String -> Attribute m c
xlinkType =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:type"


{-| -}
xmlBase : String -> Attribute m c
xmlBase =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:base"


{-| -}
xmlLang : String -> Attribute m c
xmlLang =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:lang"


{-| -}
xmlSpace : String -> Attribute m c
xmlSpace =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:space"


{-| -}
y : String -> Attribute m c
y =
    attribute "y"


{-| -}
y1 : String -> Attribute m c
y1 =
    attribute "y1"


{-| -}
y2 : String -> Attribute m c
y2 =
    attribute "y2"


{-| -}
yChannelSelector : String -> Attribute m c
yChannelSelector =
    attribute "yChannelSelector"


{-| -}
z : String -> Attribute m c
z =
    attribute "z"


{-| -}
zoomAndPan : String -> Attribute m c
zoomAndPan =
    attribute "zoomAndPan"



-- Presentation attributes


{-| -}
alignmentBaseline : String -> Attribute m c
alignmentBaseline =
    attribute "alignment-baseline"


{-| -}
baselineShift : String -> Attribute m c
baselineShift =
    attribute "baseline-shift"


{-| -}
clipPath : String -> Attribute m c
clipPath =
    attribute "clip-path"


{-| -}
clipRule : String -> Attribute m c
clipRule =
    attribute "clip-rule"


{-| -}
clip : String -> Attribute m c
clip =
    attribute "clip"


{-| -}
colorInterpolationFilters : String -> Attribute m c
colorInterpolationFilters =
    attribute "color-interpolation-filters"


{-| -}
colorInterpolation : String -> Attribute m c
colorInterpolation =
    attribute "color-interpolation"


{-| -}
colorProfile : String -> Attribute m c
colorProfile =
    attribute "color-profile"


{-| -}
colorRendering : String -> Attribute m c
colorRendering =
    attribute "color-rendering"


{-| -}
color : String -> Attribute m c
color =
    attribute "color"


{-| -}
cursor : String -> Attribute m c
cursor =
    attribute "cursor"


{-| -}
direction : String -> Attribute m c
direction =
    attribute "direction"


{-| -}
display : String -> Attribute m c
display =
    attribute "display"


{-| -}
dominantBaseline : String -> Attribute m c
dominantBaseline =
    attribute "dominant-baseline"


{-| -}
enableBackground : String -> Attribute m c
enableBackground =
    attribute "enable-background"


{-| -}
fillOpacity : String -> Attribute m c
fillOpacity =
    attribute "fill-opacity"


{-| -}
fillRule : String -> Attribute m c
fillRule =
    attribute "fill-rule"


{-| -}
fill : String -> Attribute m c
fill =
    attribute "fill"


{-| -}
filter : String -> Attribute m c
filter =
    attribute "filter"


{-| -}
floodColor : String -> Attribute m c
floodColor =
    attribute "flood-color"


{-| -}
floodOpacity : String -> Attribute m c
floodOpacity =
    attribute "flood-opacity"


{-| -}
fontFamily : String -> Attribute m c
fontFamily =
    attribute "font-family"


{-| -}
fontSizeAdjust : String -> Attribute m c
fontSizeAdjust =
    attribute "font-size-adjust"


{-| -}
fontSize : String -> Attribute m c
fontSize =
    attribute "font-size"


{-| -}
fontStretch : String -> Attribute m c
fontStretch =
    attribute "font-stretch"


{-| -}
fontStyle : String -> Attribute m c
fontStyle =
    attribute "font-style"


{-| -}
fontVariant : String -> Attribute m c
fontVariant =
    attribute "font-variant"


{-| -}
fontWeight : String -> Attribute m c
fontWeight =
    attribute "font-weight"


{-| -}
glyphOrientationHorizontal : String -> Attribute m c
glyphOrientationHorizontal =
    attribute "glyph-orientation-horizontal"


{-| -}
glyphOrientationVertical : String -> Attribute m c
glyphOrientationVertical =
    attribute "glyph-orientation-vertical"


{-| -}
imageRendering : String -> Attribute m c
imageRendering =
    attribute "image-rendering"


{-| -}
kerning : String -> Attribute m c
kerning =
    attribute "kerning"


{-| -}
letterSpacing : String -> Attribute m c
letterSpacing =
    attribute "letter-spacing"


{-| -}
lightingColor : String -> Attribute m c
lightingColor =
    attribute "lighting-color"


{-| -}
markerEnd : String -> Attribute m c
markerEnd =
    attribute "marker-end"


{-| -}
markerMid : String -> Attribute m c
markerMid =
    attribute "marker-mid"


{-| -}
markerStart : String -> Attribute m c
markerStart =
    attribute "marker-start"


{-| -}
mask : String -> Attribute m c
mask =
    attribute "mask"


{-| -}
opacity : String -> Attribute m c
opacity =
    attribute "opacity"


{-| -}
overflow : String -> Attribute m c
overflow =
    attribute "overflow"


{-| -}
pointerEvents : String -> Attribute m c
pointerEvents =
    attribute "pointer-events"


{-| -}
shapeRendering : String -> Attribute m c
shapeRendering =
    attribute "shape-rendering"


{-| -}
stopColor : String -> Attribute m c
stopColor =
    attribute "stop-color"


{-| -}
stopOpacity : String -> Attribute m c
stopOpacity =
    attribute "stop-opacity"


{-| -}
strokeDasharray : String -> Attribute m c
strokeDasharray =
    attribute "stroke-dasharray"


{-| -}
strokeDashoffset : String -> Attribute m c
strokeDashoffset =
    attribute "stroke-dashoffset"


{-| -}
strokeLinecap : String -> Attribute m c
strokeLinecap =
    attribute "stroke-linecap"


{-| -}
strokeLinejoin : String -> Attribute m c
strokeLinejoin =
    attribute "stroke-linejoin"


{-| -}
strokeMiterlimit : String -> Attribute m c
strokeMiterlimit =
    attribute "stroke-miterlimit"


{-| -}
strokeOpacity : String -> Attribute m c
strokeOpacity =
    attribute "stroke-opacity"


{-| -}
strokeWidth : String -> Attribute m c
strokeWidth =
    attribute "stroke-width"


{-| -}
stroke : String -> Attribute m c
stroke =
    attribute "stroke"


{-| -}
textAnchor : String -> Attribute m c
textAnchor =
    attribute "text-anchor"


{-| -}
textDecoration : String -> Attribute m c
textDecoration =
    attribute "text-decoration"


{-| -}
textRendering : String -> Attribute m c
textRendering =
    attribute "text-rendering"


{-| -}
unicodeBidi : String -> Attribute m c
unicodeBidi =
    attribute "unicode-bidi"


{-| -}
visibility : String -> Attribute m c
visibility =
    attribute "visibility"


{-| -}
wordSpacing : String -> Attribute m c
wordSpacing =
    attribute "word-spacing"


{-| -}
writingMode : String -> Attribute m c
writingMode =
    attribute "writing-mode"
