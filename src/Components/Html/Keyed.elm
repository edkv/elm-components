module Components.Html.Keyed exposing (div, node, ol, ul)

{-| A keyed node helps optimize cases where children are getting added, moved,
removed, etc. Common examples include:

  - The user can delete items from a list.
  - The user can create new items in a list.
  - You can sort a list based on name or date or whatever.
    When you use a keyed node, every child is paired with a string identifier.
    This makes it possible for the underlying diffing algorithm to reuse nodes
    more efficiently.


# Keyed Nodes

@docs node


# Commonly Keyed Nodes

@docs ol, ul, div

-}

import Components.Html exposing (Attribute, Html)
import Components.Internal.Core as Core


{-| Works just like `Components.Html.node`, but you add a unique identifier to
each child node. You want this when you have a list of nodes that is changing:
adding nodes, removing nodes, etc. In these cases, the unique identifiers help
make the DOM modifications more efficient.
-}
node : String -> List (Attribute c m) -> List ( String, Html c m ) -> Html c m
node tag attributes children =
    Core.KeyedSimpleElement
        { tag = tag
        , attributes = attributes
        , children = children
        }


{-| -}
ol : List (Attribute c m) -> List ( String, Html c m ) -> Html c m
ol =
    node "ol"


{-| -}
ul : List (Attribute c m) -> List ( String, Html c m ) -> Html c m
ul =
    node "ul"


{-| -}
div : List (Attribute c m) -> List ( String, Html c m ) -> Html c m
div =
    node "div"
