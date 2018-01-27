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

import Components.Core.Internal as Core
import Components.Core.Shared exposing (svgNamespace)
import Components.Html exposing (Html)
import Components.Svg exposing (Attribute, Svg)


{-| Works just like `Components.Svg.node`, but you add a unique identifier to
each child node. You want this when you have a list of nodes that is changing:
adding nodes, removing nodes, etc. In these cases, the unique identifiers help
make the DOM modifications more efficient.
-}
node : String -> List (Attribute c m) -> List ( String, Svg c m ) -> Svg c m
node tag attributes children =
    Core.KeyedSimpleElement
        { tag = tag
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| -}
svg : List (Attribute c m) -> List ( String, Svg c m ) -> Html c m
svg attributes children =
    Core.KeyedEmbedding
        { tag = "svg"
        , attributes = svgNamespace :: attributes
        , children = children
        }


{-| -}
foreignObject : List (Attribute c m) -> List ( String, Html c m ) -> Svg c m
foreignObject attributes children =
    Core.KeyedReversedEmbedding
        { tag = "foreignObject"
        , attributes = svgNamespace :: attributes
        , children = children
        }
