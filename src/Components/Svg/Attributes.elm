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
attribute : String -> String -> Attribute c m
attribute key value =
    VirtualDom.attribute key value
        |> Core.PlainAttribute


{-| Create a custom "namespaced" attribute. This corresponds to JavaScript's
`setAttributeNS` function under the hood.
-}
attributeNS : String -> String -> String -> Attribute c m
attributeNS namespace key value =
    VirtualDom.attributeNS namespace key value
        |> Core.PlainAttribute



-- CSS


{-| Apply styles to an element. See the
[`Css` module documentation](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css)
for an overview of how to use this function.
-}
styles : List Css.Style -> Attribute c m
styles =
    Core.Styles Core.ClassAttribute


{-| Specify a list of inline styles. This will generate a `style` attribute in
the DOM.
-}
inlineStyles : List ( String, String ) -> Attribute c m
inlineStyles =
    VirtualDom.style >> Core.PlainAttribute



-- Regular attributes


{-| -}
accentHeight : String -> Attribute c m
accentHeight =
    attribute "accent-height"


{-| -}
accelerate : String -> Attribute c m
accelerate =
    attribute "accelerate"


{-| -}
accumulate : String -> Attribute c m
accumulate =
    attribute "accumulate"


{-| -}
additive : String -> Attribute c m
additive =
    attribute "additive"


{-| -}
alphabetic : String -> Attribute c m
alphabetic =
    attribute "alphabetic"


{-| -}
allowReorder : String -> Attribute c m
allowReorder =
    attribute "allowReorder"


{-| -}
amplitude : String -> Attribute c m
amplitude =
    attribute "amplitude"


{-| -}
arabicForm : String -> Attribute c m
arabicForm =
    attribute "arabic-form"


{-| -}
ascent : String -> Attribute c m
ascent =
    attribute "ascent"


{-| -}
attributeName : String -> Attribute c m
attributeName =
    attribute "attributeName"


{-| -}
attributeType : String -> Attribute c m
attributeType =
    attribute "attributeType"


{-| -}
autoReverse : String -> Attribute c m
autoReverse =
    attribute "autoReverse"


{-| -}
azimuth : String -> Attribute c m
azimuth =
    attribute "azimuth"


{-| -}
baseFrequency : String -> Attribute c m
baseFrequency =
    attribute "baseFrequency"


{-| -}
baseProfile : String -> Attribute c m
baseProfile =
    attribute "baseProfile"


{-| -}
bbox : String -> Attribute c m
bbox =
    attribute "bbox"


{-| -}
begin : String -> Attribute c m
begin =
    attribute "begin"


{-| -}
bias : String -> Attribute c m
bias =
    attribute "bias"


{-| -}
by : String -> Attribute c m
by =
    attribute "by"


{-| -}
calcMode : String -> Attribute c m
calcMode =
    attribute "calcMode"


{-| -}
capHeight : String -> Attribute c m
capHeight =
    attribute "cap-height"


{-| -}
class : String -> Attribute c m
class =
    attribute "class"


{-| -}
clipPathUnits : String -> Attribute c m
clipPathUnits =
    attribute "clipPathUnits"


{-| -}
contentScriptType : String -> Attribute c m
contentScriptType =
    attribute "contentScriptType"


{-| -}
contentStyleType : String -> Attribute c m
contentStyleType =
    attribute "contentStyleType"


{-| -}
cx : String -> Attribute c m
cx =
    attribute "cx"


{-| -}
cy : String -> Attribute c m
cy =
    attribute "cy"


{-| -}
d : String -> Attribute c m
d =
    attribute "d"


{-| -}
decelerate : String -> Attribute c m
decelerate =
    attribute "decelerate"


{-| -}
descent : String -> Attribute c m
descent =
    attribute "descent"


{-| -}
diffuseConstant : String -> Attribute c m
diffuseConstant =
    attribute "diffuseConstant"


{-| -}
divisor : String -> Attribute c m
divisor =
    attribute "divisor"


{-| -}
dur : String -> Attribute c m
dur =
    attribute "dur"


{-| -}
dx : String -> Attribute c m
dx =
    attribute "dx"


{-| -}
dy : String -> Attribute c m
dy =
    attribute "dy"


{-| -}
edgeMode : String -> Attribute c m
edgeMode =
    attribute "edgeMode"


{-| -}
elevation : String -> Attribute c m
elevation =
    attribute "elevation"


{-| -}
end : String -> Attribute c m
end =
    attribute "end"


{-| -}
exponent : String -> Attribute c m
exponent =
    attribute "exponent"


{-| -}
externalResourcesRequired : String -> Attribute c m
externalResourcesRequired =
    attribute "externalResourcesRequired"


{-| -}
filterRes : String -> Attribute c m
filterRes =
    attribute "filterRes"


{-| -}
filterUnits : String -> Attribute c m
filterUnits =
    attribute "filterUnits"


{-| -}
format : String -> Attribute c m
format =
    attribute "format"


{-| -}
from : String -> Attribute c m
from =
    attribute "from"


{-| -}
fx : String -> Attribute c m
fx =
    attribute "fx"


{-| -}
fy : String -> Attribute c m
fy =
    attribute "fy"


{-| -}
g1 : String -> Attribute c m
g1 =
    attribute "g1"


{-| -}
g2 : String -> Attribute c m
g2 =
    attribute "g2"


{-| -}
glyphName : String -> Attribute c m
glyphName =
    attribute "glyph-name"


{-| -}
glyphRef : String -> Attribute c m
glyphRef =
    attribute "glyphRef"


{-| -}
gradientTransform : String -> Attribute c m
gradientTransform =
    attribute "gradientTransform"


{-| -}
gradientUnits : String -> Attribute c m
gradientUnits =
    attribute "gradientUnits"


{-| -}
hanging : String -> Attribute c m
hanging =
    attribute "hanging"


{-| -}
height : String -> Attribute c m
height =
    attribute "height"


{-| -}
horizAdvX : String -> Attribute c m
horizAdvX =
    attribute "horiz-adv-x"


{-| -}
horizOriginX : String -> Attribute c m
horizOriginX =
    attribute "horiz-origin-x"


{-| -}
horizOriginY : String -> Attribute c m
horizOriginY =
    attribute "horiz-origin-y"


{-| -}
id : String -> Attribute c m
id =
    attribute "id"


{-| -}
ideographic : String -> Attribute c m
ideographic =
    attribute "ideographic"


{-| -}
in_ : String -> Attribute c m
in_ =
    attribute "in"


{-| -}
in2 : String -> Attribute c m
in2 =
    attribute "in2"


{-| -}
intercept : String -> Attribute c m
intercept =
    attribute "intercept"


{-| -}
k : String -> Attribute c m
k =
    attribute "k"


{-| -}
k1 : String -> Attribute c m
k1 =
    attribute "k1"


{-| -}
k2 : String -> Attribute c m
k2 =
    attribute "k2"


{-| -}
k3 : String -> Attribute c m
k3 =
    attribute "k3"


{-| -}
k4 : String -> Attribute c m
k4 =
    attribute "k4"


{-| -}
kernelMatrix : String -> Attribute c m
kernelMatrix =
    attribute "kernelMatrix"


{-| -}
kernelUnitLength : String -> Attribute c m
kernelUnitLength =
    attribute "kernelUnitLength"


{-| -}
keyPoints : String -> Attribute c m
keyPoints =
    attribute "keyPoints"


{-| -}
keySplines : String -> Attribute c m
keySplines =
    attribute "keySplines"


{-| -}
keyTimes : String -> Attribute c m
keyTimes =
    attribute "keyTimes"


{-| -}
lang : String -> Attribute c m
lang =
    attribute "lang"


{-| -}
lengthAdjust : String -> Attribute c m
lengthAdjust =
    attribute "lengthAdjust"


{-| -}
limitingConeAngle : String -> Attribute c m
limitingConeAngle =
    attribute "limitingConeAngle"


{-| -}
local : String -> Attribute c m
local =
    attribute "local"


{-| -}
markerHeight : String -> Attribute c m
markerHeight =
    attribute "markerHeight"


{-| -}
markerUnits : String -> Attribute c m
markerUnits =
    attribute "markerUnits"


{-| -}
markerWidth : String -> Attribute c m
markerWidth =
    attribute "markerWidth"


{-| -}
maskContentUnits : String -> Attribute c m
maskContentUnits =
    attribute "maskContentUnits"


{-| -}
maskUnits : String -> Attribute c m
maskUnits =
    attribute "maskUnits"


{-| -}
mathematical : String -> Attribute c m
mathematical =
    attribute "mathematical"


{-| -}
max : String -> Attribute c m
max =
    attribute "max"


{-| -}
media : String -> Attribute c m
media =
    attribute "media"


{-| -}
method : String -> Attribute c m
method =
    attribute "method"


{-| -}
min : String -> Attribute c m
min =
    attribute "min"


{-| -}
mode : String -> Attribute c m
mode =
    attribute "mode"


{-| -}
name : String -> Attribute c m
name =
    attribute "name"


{-| -}
numOctaves : String -> Attribute c m
numOctaves =
    attribute "numOctaves"


{-| -}
offset : String -> Attribute c m
offset =
    attribute "offset"


{-| -}
operator : String -> Attribute c m
operator =
    attribute "operator"


{-| -}
order : String -> Attribute c m
order =
    attribute "order"


{-| -}
orient : String -> Attribute c m
orient =
    attribute "orient"


{-| -}
orientation : String -> Attribute c m
orientation =
    attribute "orientation"


{-| -}
origin : String -> Attribute c m
origin =
    attribute "origin"


{-| -}
overlinePosition : String -> Attribute c m
overlinePosition =
    attribute "overline-position"


{-| -}
overlineThickness : String -> Attribute c m
overlineThickness =
    attribute "overline-thickness"


{-| -}
panose1 : String -> Attribute c m
panose1 =
    attribute "panose-1"


{-| -}
path : String -> Attribute c m
path =
    attribute "path"


{-| -}
pathLength : String -> Attribute c m
pathLength =
    attribute "pathLength"


{-| -}
patternContentUnits : String -> Attribute c m
patternContentUnits =
    attribute "patternContentUnits"


{-| -}
patternTransform : String -> Attribute c m
patternTransform =
    attribute "patternTransform"


{-| -}
patternUnits : String -> Attribute c m
patternUnits =
    attribute "patternUnits"


{-| -}
pointOrder : String -> Attribute c m
pointOrder =
    attribute "point-order"


{-| -}
points : String -> Attribute c m
points =
    attribute "points"


{-| -}
pointsAtX : String -> Attribute c m
pointsAtX =
    attribute "pointsAtX"


{-| -}
pointsAtY : String -> Attribute c m
pointsAtY =
    attribute "pointsAtY"


{-| -}
pointsAtZ : String -> Attribute c m
pointsAtZ =
    attribute "pointsAtZ"


{-| -}
preserveAlpha : String -> Attribute c m
preserveAlpha =
    attribute "preserveAlpha"


{-| -}
preserveAspectRatio : String -> Attribute c m
preserveAspectRatio =
    attribute "preserveAspectRatio"


{-| -}
primitiveUnits : String -> Attribute c m
primitiveUnits =
    attribute "primitiveUnits"


{-| -}
r : String -> Attribute c m
r =
    attribute "r"


{-| -}
radius : String -> Attribute c m
radius =
    attribute "radius"


{-| -}
refX : String -> Attribute c m
refX =
    attribute "refX"


{-| -}
refY : String -> Attribute c m
refY =
    attribute "refY"


{-| -}
renderingIntent : String -> Attribute c m
renderingIntent =
    attribute "rendering-intent"


{-| -}
repeatCount : String -> Attribute c m
repeatCount =
    attribute "repeatCount"


{-| -}
repeatDur : String -> Attribute c m
repeatDur =
    attribute "repeatDur"


{-| -}
requiredExtensions : String -> Attribute c m
requiredExtensions =
    attribute "requiredExtensions"


{-| -}
requiredFeatures : String -> Attribute c m
requiredFeatures =
    attribute "requiredFeatures"


{-| -}
restart : String -> Attribute c m
restart =
    attribute "restart"


{-| -}
result : String -> Attribute c m
result =
    attribute "result"


{-| -}
rotate : String -> Attribute c m
rotate =
    attribute "rotate"


{-| -}
rx : String -> Attribute c m
rx =
    attribute "rx"


{-| -}
ry : String -> Attribute c m
ry =
    attribute "ry"


{-| -}
scale : String -> Attribute c m
scale =
    attribute "scale"


{-| -}
seed : String -> Attribute c m
seed =
    attribute "seed"


{-| -}
slope : String -> Attribute c m
slope =
    attribute "slope"


{-| -}
spacing : String -> Attribute c m
spacing =
    attribute "spacing"


{-| -}
specularConstant : String -> Attribute c m
specularConstant =
    attribute "specularConstant"


{-| -}
specularExponent : String -> Attribute c m
specularExponent =
    attribute "specularExponent"


{-| -}
speed : String -> Attribute c m
speed =
    attribute "speed"


{-| -}
spreadMethod : String -> Attribute c m
spreadMethod =
    attribute "spreadMethod"


{-| -}
startOffset : String -> Attribute c m
startOffset =
    attribute "startOffset"


{-| -}
stdDeviation : String -> Attribute c m
stdDeviation =
    attribute "stdDeviation"


{-| -}
stemh : String -> Attribute c m
stemh =
    attribute "stemh"


{-| -}
stemv : String -> Attribute c m
stemv =
    attribute "stemv"


{-| -}
stitchTiles : String -> Attribute c m
stitchTiles =
    attribute "stitchTiles"


{-| -}
strikethroughPosition : String -> Attribute c m
strikethroughPosition =
    attribute "strikethrough-position"


{-| -}
strikethroughThickness : String -> Attribute c m
strikethroughThickness =
    attribute "strikethrough-thickness"


{-| -}
string : String -> Attribute c m
string =
    attribute "string"


{-| -}
surfaceScale : String -> Attribute c m
surfaceScale =
    attribute "surfaceScale"


{-| -}
systemLanguage : String -> Attribute c m
systemLanguage =
    attribute "systemLanguage"


{-| -}
tableValues : String -> Attribute c m
tableValues =
    attribute "tableValues"


{-| -}
target : String -> Attribute c m
target =
    attribute "target"


{-| -}
targetX : String -> Attribute c m
targetX =
    attribute "targetX"


{-| -}
targetY : String -> Attribute c m
targetY =
    attribute "targetY"


{-| -}
textLength : String -> Attribute c m
textLength =
    attribute "textLength"


{-| -}
title : String -> Attribute c m
title =
    attribute "title"


{-| -}
to : String -> Attribute c m
to =
    attribute "to"


{-| -}
transform : String -> Attribute c m
transform =
    attribute "transform"


{-| -}
type_ : String -> Attribute c m
type_ =
    attribute "type"


{-| -}
u1 : String -> Attribute c m
u1 =
    attribute "u1"


{-| -}
u2 : String -> Attribute c m
u2 =
    attribute "u2"


{-| -}
underlinePosition : String -> Attribute c m
underlinePosition =
    attribute "underline-position"


{-| -}
underlineThickness : String -> Attribute c m
underlineThickness =
    attribute "underline-thickness"


{-| -}
unicode : String -> Attribute c m
unicode =
    attribute "unicode"


{-| -}
unicodeRange : String -> Attribute c m
unicodeRange =
    attribute "unicode-range"


{-| -}
unitsPerEm : String -> Attribute c m
unitsPerEm =
    attribute "units-per-em"


{-| -}
vAlphabetic : String -> Attribute c m
vAlphabetic =
    attribute "v-alphabetic"


{-| -}
vHanging : String -> Attribute c m
vHanging =
    attribute "v-hanging"


{-| -}
vIdeographic : String -> Attribute c m
vIdeographic =
    attribute "v-ideographic"


{-| -}
vMathematical : String -> Attribute c m
vMathematical =
    attribute "v-mathematical"


{-| -}
values : String -> Attribute c m
values =
    attribute "values"


{-| -}
version : String -> Attribute c m
version =
    attribute "version"


{-| -}
vertAdvY : String -> Attribute c m
vertAdvY =
    attribute "vert-adv-y"


{-| -}
vertOriginX : String -> Attribute c m
vertOriginX =
    attribute "vert-origin-x"


{-| -}
vertOriginY : String -> Attribute c m
vertOriginY =
    attribute "vert-origin-y"


{-| -}
viewBox : String -> Attribute c m
viewBox =
    attribute "viewBox"


{-| -}
viewTarget : String -> Attribute c m
viewTarget =
    attribute "viewTarget"


{-| -}
width : String -> Attribute c m
width =
    attribute "width"


{-| -}
widths : String -> Attribute c m
widths =
    attribute "widths"


{-| -}
x : String -> Attribute c m
x =
    attribute "x"


{-| -}
xHeight : String -> Attribute c m
xHeight =
    attribute "x-height"


{-| -}
x1 : String -> Attribute c m
x1 =
    attribute "x1"


{-| -}
x2 : String -> Attribute c m
x2 =
    attribute "x2"


{-| -}
xChannelSelector : String -> Attribute c m
xChannelSelector =
    attribute "xChannelSelector"


{-| -}
xlinkActuate : String -> Attribute c m
xlinkActuate =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:actuate"


{-| -}
xlinkArcrole : String -> Attribute c m
xlinkArcrole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:arcrole"


{-| -}
xlinkHref : String -> Attribute c m
xlinkHref =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:href"


{-| -}
xlinkRole : String -> Attribute c m
xlinkRole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:role"


{-| -}
xlinkShow : String -> Attribute c m
xlinkShow =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:show"


{-| -}
xlinkTitle : String -> Attribute c m
xlinkTitle =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:title"


{-| -}
xlinkType : String -> Attribute c m
xlinkType =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:type"


{-| -}
xmlBase : String -> Attribute c m
xmlBase =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:base"


{-| -}
xmlLang : String -> Attribute c m
xmlLang =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:lang"


{-| -}
xmlSpace : String -> Attribute c m
xmlSpace =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:space"


{-| -}
y : String -> Attribute c m
y =
    attribute "y"


{-| -}
y1 : String -> Attribute c m
y1 =
    attribute "y1"


{-| -}
y2 : String -> Attribute c m
y2 =
    attribute "y2"


{-| -}
yChannelSelector : String -> Attribute c m
yChannelSelector =
    attribute "yChannelSelector"


{-| -}
z : String -> Attribute c m
z =
    attribute "z"


{-| -}
zoomAndPan : String -> Attribute c m
zoomAndPan =
    attribute "zoomAndPan"



-- Presentation attributes


{-| -}
alignmentBaseline : String -> Attribute c m
alignmentBaseline =
    attribute "alignment-baseline"


{-| -}
baselineShift : String -> Attribute c m
baselineShift =
    attribute "baseline-shift"


{-| -}
clipPath : String -> Attribute c m
clipPath =
    attribute "clip-path"


{-| -}
clipRule : String -> Attribute c m
clipRule =
    attribute "clip-rule"


{-| -}
clip : String -> Attribute c m
clip =
    attribute "clip"


{-| -}
colorInterpolationFilters : String -> Attribute c m
colorInterpolationFilters =
    attribute "color-interpolation-filters"


{-| -}
colorInterpolation : String -> Attribute c m
colorInterpolation =
    attribute "color-interpolation"


{-| -}
colorProfile : String -> Attribute c m
colorProfile =
    attribute "color-profile"


{-| -}
colorRendering : String -> Attribute c m
colorRendering =
    attribute "color-rendering"


{-| -}
color : String -> Attribute c m
color =
    attribute "color"


{-| -}
cursor : String -> Attribute c m
cursor =
    attribute "cursor"


{-| -}
direction : String -> Attribute c m
direction =
    attribute "direction"


{-| -}
display : String -> Attribute c m
display =
    attribute "display"


{-| -}
dominantBaseline : String -> Attribute c m
dominantBaseline =
    attribute "dominant-baseline"


{-| -}
enableBackground : String -> Attribute c m
enableBackground =
    attribute "enable-background"


{-| -}
fillOpacity : String -> Attribute c m
fillOpacity =
    attribute "fill-opacity"


{-| -}
fillRule : String -> Attribute c m
fillRule =
    attribute "fill-rule"


{-| -}
fill : String -> Attribute c m
fill =
    attribute "fill"


{-| -}
filter : String -> Attribute c m
filter =
    attribute "filter"


{-| -}
floodColor : String -> Attribute c m
floodColor =
    attribute "flood-color"


{-| -}
floodOpacity : String -> Attribute c m
floodOpacity =
    attribute "flood-opacity"


{-| -}
fontFamily : String -> Attribute c m
fontFamily =
    attribute "font-family"


{-| -}
fontSizeAdjust : String -> Attribute c m
fontSizeAdjust =
    attribute "font-size-adjust"


{-| -}
fontSize : String -> Attribute c m
fontSize =
    attribute "font-size"


{-| -}
fontStretch : String -> Attribute c m
fontStretch =
    attribute "font-stretch"


{-| -}
fontStyle : String -> Attribute c m
fontStyle =
    attribute "font-style"


{-| -}
fontVariant : String -> Attribute c m
fontVariant =
    attribute "font-variant"


{-| -}
fontWeight : String -> Attribute c m
fontWeight =
    attribute "font-weight"


{-| -}
glyphOrientationHorizontal : String -> Attribute c m
glyphOrientationHorizontal =
    attribute "glyph-orientation-horizontal"


{-| -}
glyphOrientationVertical : String -> Attribute c m
glyphOrientationVertical =
    attribute "glyph-orientation-vertical"


{-| -}
imageRendering : String -> Attribute c m
imageRendering =
    attribute "image-rendering"


{-| -}
kerning : String -> Attribute c m
kerning =
    attribute "kerning"


{-| -}
letterSpacing : String -> Attribute c m
letterSpacing =
    attribute "letter-spacing"


{-| -}
lightingColor : String -> Attribute c m
lightingColor =
    attribute "lighting-color"


{-| -}
markerEnd : String -> Attribute c m
markerEnd =
    attribute "marker-end"


{-| -}
markerMid : String -> Attribute c m
markerMid =
    attribute "marker-mid"


{-| -}
markerStart : String -> Attribute c m
markerStart =
    attribute "marker-start"


{-| -}
mask : String -> Attribute c m
mask =
    attribute "mask"


{-| -}
opacity : String -> Attribute c m
opacity =
    attribute "opacity"


{-| -}
overflow : String -> Attribute c m
overflow =
    attribute "overflow"


{-| -}
pointerEvents : String -> Attribute c m
pointerEvents =
    attribute "pointer-events"


{-| -}
shapeRendering : String -> Attribute c m
shapeRendering =
    attribute "shape-rendering"


{-| -}
stopColor : String -> Attribute c m
stopColor =
    attribute "stop-color"


{-| -}
stopOpacity : String -> Attribute c m
stopOpacity =
    attribute "stop-opacity"


{-| -}
strokeDasharray : String -> Attribute c m
strokeDasharray =
    attribute "stroke-dasharray"


{-| -}
strokeDashoffset : String -> Attribute c m
strokeDashoffset =
    attribute "stroke-dashoffset"


{-| -}
strokeLinecap : String -> Attribute c m
strokeLinecap =
    attribute "stroke-linecap"


{-| -}
strokeLinejoin : String -> Attribute c m
strokeLinejoin =
    attribute "stroke-linejoin"


{-| -}
strokeMiterlimit : String -> Attribute c m
strokeMiterlimit =
    attribute "stroke-miterlimit"


{-| -}
strokeOpacity : String -> Attribute c m
strokeOpacity =
    attribute "stroke-opacity"


{-| -}
strokeWidth : String -> Attribute c m
strokeWidth =
    attribute "stroke-width"


{-| -}
stroke : String -> Attribute c m
stroke =
    attribute "stroke"


{-| -}
textAnchor : String -> Attribute c m
textAnchor =
    attribute "text-anchor"


{-| -}
textDecoration : String -> Attribute c m
textDecoration =
    attribute "text-decoration"


{-| -}
textRendering : String -> Attribute c m
textRendering =
    attribute "text-rendering"


{-| -}
unicodeBidi : String -> Attribute c m
unicodeBidi =
    attribute "unicode-bidi"


{-| -}
visibility : String -> Attribute c m
visibility =
    attribute "visibility"


{-| -}
wordSpacing : String -> Attribute c m
wordSpacing =
    attribute "word-spacing"


{-| -}
writingMode : String -> Attribute c m
writingMode =
    attribute "writing-mode"
