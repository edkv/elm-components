module Components.Svg.Keyed exposing (node, svg)

{-| A keyed node helps optimize cases where children are getting added, moved,
removed, etc. Common examples include:

  - The user can delete items from a list.
  - The user can create new items in a list.
  - You can sort a list based on name or date or whatever.
    When you use a keyed node, every child is paired with a string identifier.
    This makes it possible for the underlying diffing algorithm to reuse nodes
    more efficiently.

@docs node, svg

-}

import Components.Html exposing (Html)
import Components.Internal.Core exposing (Node)
import Components.Internal.Elements as Elements
import Components.Internal.Shared
    exposing
        ( HtmlNode(HtmlNode)
        , SvgAttribute(SvgAttribute)
        , SvgNode(SvgNode)
        , svgNamespace
        )
import Components.Svg exposing (Attribute, Svg)


{-| Works just like `Components.Svg.node`, but you add a unique identifier to
each child node. You want this when you have a list of nodes that is changing:
adding nodes, removing nodes, etc. In these cases, the unique identifiers help
make the DOM modifications more efficient.
-}
node : String -> List (Attribute c m) -> List ( String, Svg c m ) -> Svg c m
node tag attributes children =
    SvgNode (unwrappedNode tag attributes children)


{-| -}
svg : List (Attribute c m) -> List ( String, Svg c m ) -> Html c m
svg attributes children =
    HtmlNode (unwrappedNode "svg" attributes children)


unwrappedNode :
    String
    -> List (Attribute c m)
    -> List ( String, Svg c m )
    -> Node c m
unwrappedNode tag attributes children =
    Elements.keyedElement tag
        (attributes
            |> List.map (\(SvgAttribute attr) -> attr)
            |> (::) svgNamespace
        )
        (List.map (\( key, SvgNode node ) -> ( key, node )) children)
