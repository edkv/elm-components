module Components.Internal.Shared
    exposing
        ( HtmlAttribute(HtmlAttribute)
        , HtmlComponent(HtmlComponent)
        , HtmlNode(HtmlNode)
        )

import Components.Internal.Core exposing (Component, Node)
import Components.Internal.Elements exposing (Attribute)


type HtmlNode c m
    = HtmlNode (Node c m)


type HtmlAttribute c m
    = HtmlAttribute (Attribute c m)


type HtmlComponent container c m
    = HtmlComponent (Component container c m)
