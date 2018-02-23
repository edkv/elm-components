module Components.Svg.Keyed exposing (foreignObject, node, svg)

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
import Components.Internal.Core as Core
import Components.Internal.Shared exposing (svgNamespace)
import Components.Svg exposing (Attribute, Svg)


{-| Works just like `Components.Svg.node`, but you add a unique identifier to
each child node. You want this when you have a list of nodes that is changing:
adding nodes, removing nodes, etc. In these cases, the unique identifiers help
make the DOM modifications more efficient.
-}
node : String -> List (Attribute m p) -> List ( String, Svg m p ) -> Svg m p
node tag attributes children =
    Core.KeyedSimpleElement
        { tag = tag
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| -}
svg : List (Attribute m p) -> List ( String, Svg m p ) -> Html m p
svg attributes children =
    Core.KeyedEmbedding
        { tag = "svg"
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| -}
foreignObject : List (Attribute m p) -> List ( String, Html m p ) -> Svg m p
foreignObject attributes children =
    Core.KeyedReversedEmbedding
        { tag = "foreignObject"
        , attributes = svgNamespace :: attributes
        , children = children
        }
