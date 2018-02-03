module Components.Internal.Shared
    exposing
        ( HtmlItem(HtmlItem)
        , SvgItem(SvgItem)
        , svgNamespace
        )

import Components.Internal.Core exposing (Attribute(PlainAttribute))
import Json.Encode as Json
import VirtualDom


type HtmlItem
    = HtmlItem


type SvgItem
    = SvgItem


svgNamespace : Attribute SvgItem m c
svgNamespace =
    VirtualDom.property "namespace" (Json.string "http://www.w3.org/2000/svg")
        |> PlainAttribute
