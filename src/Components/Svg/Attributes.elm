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
attribute : String -> String -> Attribute m p
attribute key value =
    VirtualDom.attribute key value
        |> Core.PlainAttribute


{-| Create a custom "namespaced" attribute. This corresponds to JavaScript's
`setAttributeNS` function under the hood.
-}
attributeNS : String -> String -> String -> Attribute m p
attributeNS namespace key value =
    VirtualDom.attributeNS namespace key value
        |> Core.PlainAttribute


none : Attribute m p
none =
    Core.NullAttribute



-- CSS


{-| Apply styles to an element. See the
[`Css` module documentation](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css)
for an overview of how to use this function.
-}
styles : List Css.Style -> Attribute m p
styles =
    Core.Styles Core.ClassAttribute


{-| Specify a list of inline styles. This will generate a `style` attribute in
the DOM.
-}
inlineStyles : List ( String, String ) -> Attribute m p
inlineStyles =
    VirtualDom.style >> Core.PlainAttribute



-- Regular attributes


{-| -}
accentHeight : String -> Attribute m p
accentHeight =
    attribute "accent-height"


{-| -}
accelerate : String -> Attribute m p
accelerate =
    attribute "accelerate"


{-| -}
accumulate : String -> Attribute m p
accumulate =
    attribute "accumulate"


{-| -}
additive : String -> Attribute m p
additive =
    attribute "additive"


{-| -}
alphabetic : String -> Attribute m p
alphabetic =
    attribute "alphabetic"


{-| -}
allowReorder : String -> Attribute m p
allowReorder =
    attribute "allowReorder"


{-| -}
amplitude : String -> Attribute m p
amplitude =
    attribute "amplitude"


{-| -}
arabicForm : String -> Attribute m p
arabicForm =
    attribute "arabic-form"


{-| -}
ascent : String -> Attribute m p
ascent =
    attribute "ascent"


{-| -}
attributeName : String -> Attribute m p
attributeName =
    attribute "attributeName"


{-| -}
attributeType : String -> Attribute m p
attributeType =
    attribute "attributeType"


{-| -}
autoReverse : String -> Attribute m p
autoReverse =
    attribute "autoReverse"


{-| -}
azimuth : String -> Attribute m p
azimuth =
    attribute "azimuth"


{-| -}
baseFrequency : String -> Attribute m p
baseFrequency =
    attribute "baseFrequency"


{-| -}
baseProfile : String -> Attribute m p
baseProfile =
    attribute "baseProfile"


{-| -}
bbox : String -> Attribute m p
bbox =
    attribute "bbox"


{-| -}
begin : String -> Attribute m p
begin =
    attribute "begin"


{-| -}
bias : String -> Attribute m p
bias =
    attribute "bias"


{-| -}
by : String -> Attribute m p
by =
    attribute "by"


{-| -}
calcMode : String -> Attribute m p
calcMode =
    attribute "calcMode"


{-| -}
capHeight : String -> Attribute m p
capHeight =
    attribute "cap-height"


{-| -}
class : String -> Attribute m p
class =
    attribute "class"


{-| -}
clipPathUnits : String -> Attribute m p
clipPathUnits =
    attribute "clipPathUnits"


{-| -}
contentScriptType : String -> Attribute m p
contentScriptType =
    attribute "contentScriptType"


{-| -}
contentStyleType : String -> Attribute m p
contentStyleType =
    attribute "contentStyleType"


{-| -}
cx : String -> Attribute m p
cx =
    attribute "cx"


{-| -}
cy : String -> Attribute m p
cy =
    attribute "cy"


{-| -}
d : String -> Attribute m p
d =
    attribute "d"


{-| -}
decelerate : String -> Attribute m p
decelerate =
    attribute "decelerate"


{-| -}
descent : String -> Attribute m p
descent =
    attribute "descent"


{-| -}
diffuseConstant : String -> Attribute m p
diffuseConstant =
    attribute "diffuseConstant"


{-| -}
divisor : String -> Attribute m p
divisor =
    attribute "divisor"


{-| -}
dur : String -> Attribute m p
dur =
    attribute "dur"


{-| -}
dx : String -> Attribute m p
dx =
    attribute "dx"


{-| -}
dy : String -> Attribute m p
dy =
    attribute "dy"


{-| -}
edgeMode : String -> Attribute m p
edgeMode =
    attribute "edgeMode"


{-| -}
elevation : String -> Attribute m p
elevation =
    attribute "elevation"


{-| -}
end : String -> Attribute m p
end =
    attribute "end"


{-| -}
exponent : String -> Attribute m p
exponent =
    attribute "exponent"


{-| -}
externalResourcesRequired : String -> Attribute m p
externalResourcesRequired =
    attribute "externalResourcesRequired"


{-| -}
filterRes : String -> Attribute m p
filterRes =
    attribute "filterRes"


{-| -}
filterUnits : String -> Attribute m p
filterUnits =
    attribute "filterUnits"


{-| -}
format : String -> Attribute m p
format =
    attribute "format"


{-| -}
from : String -> Attribute m p
from =
    attribute "from"


{-| -}
fx : String -> Attribute m p
fx =
    attribute "fx"


{-| -}
fy : String -> Attribute m p
fy =
    attribute "fy"


{-| -}
g1 : String -> Attribute m p
g1 =
    attribute "g1"


{-| -}
g2 : String -> Attribute m p
g2 =
    attribute "g2"


{-| -}
glyphName : String -> Attribute m p
glyphName =
    attribute "glyph-name"


{-| -}
glyphRef : String -> Attribute m p
glyphRef =
    attribute "glyphRef"


{-| -}
gradientTransform : String -> Attribute m p
gradientTransform =
    attribute "gradientTransform"


{-| -}
gradientUnits : String -> Attribute m p
gradientUnits =
    attribute "gradientUnits"


{-| -}
hanging : String -> Attribute m p
hanging =
    attribute "hanging"


{-| -}
height : String -> Attribute m p
height =
    attribute "height"


{-| -}
horizAdvX : String -> Attribute m p
horizAdvX =
    attribute "horiz-adv-x"


{-| -}
horizOriginX : String -> Attribute m p
horizOriginX =
    attribute "horiz-origin-x"


{-| -}
horizOriginY : String -> Attribute m p
horizOriginY =
    attribute "horiz-origin-y"


{-| -}
id : String -> Attribute m p
id =
    attribute "id"


{-| -}
ideographic : String -> Attribute m p
ideographic =
    attribute "ideographic"


{-| -}
in_ : String -> Attribute m p
in_ =
    attribute "in"


{-| -}
in2 : String -> Attribute m p
in2 =
    attribute "in2"


{-| -}
intercept : String -> Attribute m p
intercept =
    attribute "intercept"


{-| -}
k : String -> Attribute m p
k =
    attribute "k"


{-| -}
k1 : String -> Attribute m p
k1 =
    attribute "k1"


{-| -}
k2 : String -> Attribute m p
k2 =
    attribute "k2"


{-| -}
k3 : String -> Attribute m p
k3 =
    attribute "k3"


{-| -}
k4 : String -> Attribute m p
k4 =
    attribute "k4"


{-| -}
kernelMatrix : String -> Attribute m p
kernelMatrix =
    attribute "kernelMatrix"


{-| -}
kernelUnitLength : String -> Attribute m p
kernelUnitLength =
    attribute "kernelUnitLength"


{-| -}
keyPoints : String -> Attribute m p
keyPoints =
    attribute "keyPoints"


{-| -}
keySplines : String -> Attribute m p
keySplines =
    attribute "keySplines"


{-| -}
keyTimes : String -> Attribute m p
keyTimes =
    attribute "keyTimes"


{-| -}
lang : String -> Attribute m p
lang =
    attribute "lang"


{-| -}
lengthAdjust : String -> Attribute m p
lengthAdjust =
    attribute "lengthAdjust"


{-| -}
limitingConeAngle : String -> Attribute m p
limitingConeAngle =
    attribute "limitingConeAngle"


{-| -}
local : String -> Attribute m p
local =
    attribute "local"


{-| -}
markerHeight : String -> Attribute m p
markerHeight =
    attribute "markerHeight"


{-| -}
markerUnits : String -> Attribute m p
markerUnits =
    attribute "markerUnits"


{-| -}
markerWidth : String -> Attribute m p
markerWidth =
    attribute "markerWidth"


{-| -}
maskContentUnits : String -> Attribute m p
maskContentUnits =
    attribute "maskContentUnits"


{-| -}
maskUnits : String -> Attribute m p
maskUnits =
    attribute "maskUnits"


{-| -}
mathematical : String -> Attribute m p
mathematical =
    attribute "mathematical"


{-| -}
max : String -> Attribute m p
max =
    attribute "max"


{-| -}
media : String -> Attribute m p
media =
    attribute "media"


{-| -}
method : String -> Attribute m p
method =
    attribute "method"


{-| -}
min : String -> Attribute m p
min =
    attribute "min"


{-| -}
mode : String -> Attribute m p
mode =
    attribute "mode"


{-| -}
name : String -> Attribute m p
name =
    attribute "name"


{-| -}
numOctaves : String -> Attribute m p
numOctaves =
    attribute "numOctaves"


{-| -}
offset : String -> Attribute m p
offset =
    attribute "offset"


{-| -}
operator : String -> Attribute m p
operator =
    attribute "operator"


{-| -}
order : String -> Attribute m p
order =
    attribute "order"


{-| -}
orient : String -> Attribute m p
orient =
    attribute "orient"


{-| -}
orientation : String -> Attribute m p
orientation =
    attribute "orientation"


{-| -}
origin : String -> Attribute m p
origin =
    attribute "origin"


{-| -}
overlinePosition : String -> Attribute m p
overlinePosition =
    attribute "overline-position"


{-| -}
overlineThickness : String -> Attribute m p
overlineThickness =
    attribute "overline-thickness"


{-| -}
panose1 : String -> Attribute m p
panose1 =
    attribute "panose-1"


{-| -}
path : String -> Attribute m p
path =
    attribute "path"


{-| -}
pathLength : String -> Attribute m p
pathLength =
    attribute "pathLength"


{-| -}
patternContentUnits : String -> Attribute m p
patternContentUnits =
    attribute "patternContentUnits"


{-| -}
patternTransform : String -> Attribute m p
patternTransform =
    attribute "patternTransform"


{-| -}
patternUnits : String -> Attribute m p
patternUnits =
    attribute "patternUnits"


{-| -}
pointOrder : String -> Attribute m p
pointOrder =
    attribute "point-order"


{-| -}
points : String -> Attribute m p
points =
    attribute "points"


{-| -}
pointsAtX : String -> Attribute m p
pointsAtX =
    attribute "pointsAtX"


{-| -}
pointsAtY : String -> Attribute m p
pointsAtY =
    attribute "pointsAtY"


{-| -}
pointsAtZ : String -> Attribute m p
pointsAtZ =
    attribute "pointsAtZ"


{-| -}
preserveAlpha : String -> Attribute m p
preserveAlpha =
    attribute "preserveAlpha"


{-| -}
preserveAspectRatio : String -> Attribute m p
preserveAspectRatio =
    attribute "preserveAspectRatio"


{-| -}
primitiveUnits : String -> Attribute m p
primitiveUnits =
    attribute "primitiveUnits"


{-| -}
r : String -> Attribute m p
r =
    attribute "r"


{-| -}
radius : String -> Attribute m p
radius =
    attribute "radius"


{-| -}
refX : String -> Attribute m p
refX =
    attribute "refX"


{-| -}
refY : String -> Attribute m p
refY =
    attribute "refY"


{-| -}
renderingIntent : String -> Attribute m p
renderingIntent =
    attribute "rendering-intent"


{-| -}
repeatCount : String -> Attribute m p
repeatCount =
    attribute "repeatCount"


{-| -}
repeatDur : String -> Attribute m p
repeatDur =
    attribute "repeatDur"


{-| -}
requiredExtensions : String -> Attribute m p
requiredExtensions =
    attribute "requiredExtensions"


{-| -}
requiredFeatures : String -> Attribute m p
requiredFeatures =
    attribute "requiredFeatures"


{-| -}
restart : String -> Attribute m p
restart =
    attribute "restart"


{-| -}
result : String -> Attribute m p
result =
    attribute "result"


{-| -}
rotate : String -> Attribute m p
rotate =
    attribute "rotate"


{-| -}
rx : String -> Attribute m p
rx =
    attribute "rx"


{-| -}
ry : String -> Attribute m p
ry =
    attribute "ry"


{-| -}
scale : String -> Attribute m p
scale =
    attribute "scale"


{-| -}
seed : String -> Attribute m p
seed =
    attribute "seed"


{-| -}
slope : String -> Attribute m p
slope =
    attribute "slope"


{-| -}
spacing : String -> Attribute m p
spacing =
    attribute "spacing"


{-| -}
specularConstant : String -> Attribute m p
specularConstant =
    attribute "specularConstant"


{-| -}
specularExponent : String -> Attribute m p
specularExponent =
    attribute "specularExponent"


{-| -}
speed : String -> Attribute m p
speed =
    attribute "speed"


{-| -}
spreadMethod : String -> Attribute m p
spreadMethod =
    attribute "spreadMethod"


{-| -}
startOffset : String -> Attribute m p
startOffset =
    attribute "startOffset"


{-| -}
stdDeviation : String -> Attribute m p
stdDeviation =
    attribute "stdDeviation"


{-| -}
stemh : String -> Attribute m p
stemh =
    attribute "stemh"


{-| -}
stemv : String -> Attribute m p
stemv =
    attribute "stemv"


{-| -}
stitchTiles : String -> Attribute m p
stitchTiles =
    attribute "stitchTiles"


{-| -}
strikethroughPosition : String -> Attribute m p
strikethroughPosition =
    attribute "strikethrough-position"


{-| -}
strikethroughThickness : String -> Attribute m p
strikethroughThickness =
    attribute "strikethrough-thickness"


{-| -}
string : String -> Attribute m p
string =
    attribute "string"


{-| -}
surfaceScale : String -> Attribute m p
surfaceScale =
    attribute "surfaceScale"


{-| -}
systemLanguage : String -> Attribute m p
systemLanguage =
    attribute "systemLanguage"


{-| -}
tableValues : String -> Attribute m p
tableValues =
    attribute "tableValues"


{-| -}
target : String -> Attribute m p
target =
    attribute "target"


{-| -}
targetX : String -> Attribute m p
targetX =
    attribute "targetX"


{-| -}
targetY : String -> Attribute m p
targetY =
    attribute "targetY"


{-| -}
textLength : String -> Attribute m p
textLength =
    attribute "textLength"


{-| -}
title : String -> Attribute m p
title =
    attribute "title"


{-| -}
to : String -> Attribute m p
to =
    attribute "to"


{-| -}
transform : String -> Attribute m p
transform =
    attribute "transform"


{-| -}
type_ : String -> Attribute m p
type_ =
    attribute "type"


{-| -}
u1 : String -> Attribute m p
u1 =
    attribute "u1"


{-| -}
u2 : String -> Attribute m p
u2 =
    attribute "u2"


{-| -}
underlinePosition : String -> Attribute m p
underlinePosition =
    attribute "underline-position"


{-| -}
underlineThickness : String -> Attribute m p
underlineThickness =
    attribute "underline-thickness"


{-| -}
unicode : String -> Attribute m p
unicode =
    attribute "unicode"


{-| -}
unicodeRange : String -> Attribute m p
unicodeRange =
    attribute "unicode-range"


{-| -}
unitsPerEm : String -> Attribute m p
unitsPerEm =
    attribute "units-per-em"


{-| -}
vAlphabetic : String -> Attribute m p
vAlphabetic =
    attribute "v-alphabetic"


{-| -}
vHanging : String -> Attribute m p
vHanging =
    attribute "v-hanging"


{-| -}
vIdeographic : String -> Attribute m p
vIdeographic =
    attribute "v-ideographic"


{-| -}
vMathematical : String -> Attribute m p
vMathematical =
    attribute "v-mathematical"


{-| -}
values : String -> Attribute m p
values =
    attribute "values"


{-| -}
version : String -> Attribute m p
version =
    attribute "version"


{-| -}
vertAdvY : String -> Attribute m p
vertAdvY =
    attribute "vert-adv-y"


{-| -}
vertOriginX : String -> Attribute m p
vertOriginX =
    attribute "vert-origin-x"


{-| -}
vertOriginY : String -> Attribute m p
vertOriginY =
    attribute "vert-origin-y"


{-| -}
viewBox : String -> Attribute m p
viewBox =
    attribute "viewBox"


{-| -}
viewTarget : String -> Attribute m p
viewTarget =
    attribute "viewTarget"


{-| -}
width : String -> Attribute m p
width =
    attribute "width"


{-| -}
widths : String -> Attribute m p
widths =
    attribute "widths"


{-| -}
x : String -> Attribute m p
x =
    attribute "x"


{-| -}
xHeight : String -> Attribute m p
xHeight =
    attribute "x-height"


{-| -}
x1 : String -> Attribute m p
x1 =
    attribute "x1"


{-| -}
x2 : String -> Attribute m p
x2 =
    attribute "x2"


{-| -}
xChannelSelector : String -> Attribute m p
xChannelSelector =
    attribute "xChannelSelector"


{-| -}
xlinkActuate : String -> Attribute m p
xlinkActuate =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:actuate"


{-| -}
xlinkArcrole : String -> Attribute m p
xlinkArcrole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:arcrole"


{-| -}
xlinkHref : String -> Attribute m p
xlinkHref =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:href"


{-| -}
xlinkRole : String -> Attribute m p
xlinkRole =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:role"


{-| -}
xlinkShow : String -> Attribute m p
xlinkShow =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:show"


{-| -}
xlinkTitle : String -> Attribute m p
xlinkTitle =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:title"


{-| -}
xlinkType : String -> Attribute m p
xlinkType =
    attributeNS "http://www.w3.org/1999/xlink" "xlink:type"


{-| -}
xmlBase : String -> Attribute m p
xmlBase =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:base"


{-| -}
xmlLang : String -> Attribute m p
xmlLang =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:lang"


{-| -}
xmlSpace : String -> Attribute m p
xmlSpace =
    attributeNS "http://www.w3.org/XML/1998/namespace" "xml:space"


{-| -}
y : String -> Attribute m p
y =
    attribute "y"


{-| -}
y1 : String -> Attribute m p
y1 =
    attribute "y1"


{-| -}
y2 : String -> Attribute m p
y2 =
    attribute "y2"


{-| -}
yChannelSelector : String -> Attribute m p
yChannelSelector =
    attribute "yChannelSelector"


{-| -}
z : String -> Attribute m p
z =
    attribute "z"


{-| -}
zoomAndPan : String -> Attribute m p
zoomAndPan =
    attribute "zoomAndPan"



-- Presentation attributes


{-| -}
alignmentBaseline : String -> Attribute m p
alignmentBaseline =
    attribute "alignment-baseline"


{-| -}
baselineShift : String -> Attribute m p
baselineShift =
    attribute "baseline-shift"


{-| -}
clipPath : String -> Attribute m p
clipPath =
    attribute "clip-path"


{-| -}
clipRule : String -> Attribute m p
clipRule =
    attribute "clip-rule"


{-| -}
clip : String -> Attribute m p
clip =
    attribute "clip"


{-| -}
colorInterpolationFilters : String -> Attribute m p
colorInterpolationFilters =
    attribute "color-interpolation-filters"


{-| -}
colorInterpolation : String -> Attribute m p
colorInterpolation =
    attribute "color-interpolation"


{-| -}
colorProfile : String -> Attribute m p
colorProfile =
    attribute "color-profile"


{-| -}
colorRendering : String -> Attribute m p
colorRendering =
    attribute "color-rendering"


{-| -}
color : String -> Attribute m p
color =
    attribute "color"


{-| -}
cursor : String -> Attribute m p
cursor =
    attribute "cursor"


{-| -}
direction : String -> Attribute m p
direction =
    attribute "direction"


{-| -}
display : String -> Attribute m p
display =
    attribute "display"


{-| -}
dominantBaseline : String -> Attribute m p
dominantBaseline =
    attribute "dominant-baseline"


{-| -}
enableBackground : String -> Attribute m p
enableBackground =
    attribute "enable-background"


{-| -}
fillOpacity : String -> Attribute m p
fillOpacity =
    attribute "fill-opacity"


{-| -}
fillRule : String -> Attribute m p
fillRule =
    attribute "fill-rule"


{-| -}
fill : String -> Attribute m p
fill =
    attribute "fill"


{-| -}
filter : String -> Attribute m p
filter =
    attribute "filter"


{-| -}
floodColor : String -> Attribute m p
floodColor =
    attribute "flood-color"


{-| -}
floodOpacity : String -> Attribute m p
floodOpacity =
    attribute "flood-opacity"


{-| -}
fontFamily : String -> Attribute m p
fontFamily =
    attribute "font-family"


{-| -}
fontSizeAdjust : String -> Attribute m p
fontSizeAdjust =
    attribute "font-size-adjust"


{-| -}
fontSize : String -> Attribute m p
fontSize =
    attribute "font-size"


{-| -}
fontStretch : String -> Attribute m p
fontStretch =
    attribute "font-stretch"


{-| -}
fontStyle : String -> Attribute m p
fontStyle =
    attribute "font-style"


{-| -}
fontVariant : String -> Attribute m p
fontVariant =
    attribute "font-variant"


{-| -}
fontWeight : String -> Attribute m p
fontWeight =
    attribute "font-weight"


{-| -}
glyphOrientationHorizontal : String -> Attribute m p
glyphOrientationHorizontal =
    attribute "glyph-orientation-horizontal"


{-| -}
glyphOrientationVertical : String -> Attribute m p
glyphOrientationVertical =
    attribute "glyph-orientation-vertical"


{-| -}
imageRendering : String -> Attribute m p
imageRendering =
    attribute "image-rendering"


{-| -}
kerning : String -> Attribute m p
kerning =
    attribute "kerning"


{-| -}
letterSpacing : String -> Attribute m p
letterSpacing =
    attribute "letter-spacing"


{-| -}
lightingColor : String -> Attribute m p
lightingColor =
    attribute "lighting-color"


{-| -}
markerEnd : String -> Attribute m p
markerEnd =
    attribute "marker-end"


{-| -}
markerMid : String -> Attribute m p
markerMid =
    attribute "marker-mid"


{-| -}
markerStart : String -> Attribute m p
markerStart =
    attribute "marker-start"


{-| -}
mask : String -> Attribute m p
mask =
    attribute "mask"


{-| -}
opacity : String -> Attribute m p
opacity =
    attribute "opacity"


{-| -}
overflow : String -> Attribute m p
overflow =
    attribute "overflow"


{-| -}
pointerEvents : String -> Attribute m p
pointerEvents =
    attribute "pointer-events"


{-| -}
shapeRendering : String -> Attribute m p
shapeRendering =
    attribute "shape-rendering"


{-| -}
stopColor : String -> Attribute m p
stopColor =
    attribute "stop-color"


{-| -}
stopOpacity : String -> Attribute m p
stopOpacity =
    attribute "stop-opacity"


{-| -}
strokeDasharray : String -> Attribute m p
strokeDasharray =
    attribute "stroke-dasharray"


{-| -}
strokeDashoffset : String -> Attribute m p
strokeDashoffset =
    attribute "stroke-dashoffset"


{-| -}
strokeLinecap : String -> Attribute m p
strokeLinecap =
    attribute "stroke-linecap"


{-| -}
strokeLinejoin : String -> Attribute m p
strokeLinejoin =
    attribute "stroke-linejoin"


{-| -}
strokeMiterlimit : String -> Attribute m p
strokeMiterlimit =
    attribute "stroke-miterlimit"


{-| -}
strokeOpacity : String -> Attribute m p
strokeOpacity =
    attribute "stroke-opacity"


{-| -}
strokeWidth : String -> Attribute m p
strokeWidth =
    attribute "stroke-width"


{-| -}
stroke : String -> Attribute m p
stroke =
    attribute "stroke"


{-| -}
textAnchor : String -> Attribute m p
textAnchor =
    attribute "text-anchor"


{-| -}
textDecoration : String -> Attribute m p
textDecoration =
    attribute "text-decoration"


{-| -}
textRendering : String -> Attribute m p
textRendering =
    attribute "text-rendering"


{-| -}
unicodeBidi : String -> Attribute m p
unicodeBidi =
    attribute "unicode-bidi"


{-| -}
visibility : String -> Attribute m p
visibility =
    attribute "visibility"


{-| -}
wordSpacing : String -> Attribute m p
wordSpacing =
    attribute "word-spacing"


{-| -}
writingMode : String -> Attribute m p
writingMode =
    attribute "writing-mode"
