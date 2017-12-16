module Components.Internal.Shared
    exposing
        ( HtmlAttribute(HtmlAttribute)
        , HtmlComponent(HtmlComponent)
        , HtmlNode(HtmlNode)
        , SvgAttribute(SvgAttribute)
        , SvgComponent(SvgComponent)
        , SvgNode(SvgNode)
        , svgNamespace
        )

import Components.Internal.Core as Core
import Components.Internal.Elements as Elements
import Json.Encode as Json


type HtmlNode c m
    = HtmlNode (Core.Node c m)


type HtmlAttribute c m
    = HtmlAttribute (Elements.Attribute c m)


type HtmlComponent container c m
    = HtmlComponent (Core.Component container c m)


type SvgNode c m
    = SvgNode (Core.Node c m)


type SvgAttribute c m
    = SvgAttribute (Elements.Attribute c m)


type SvgComponent container c m
    = SvgComponent (Core.Component container c m)


svgNamespace : Elements.Attribute c m
svgNamespace =
    Elements.property "namespace" (Json.string "http://www.w3.org/2000/svg")
