module Components.Internal.VirtualDom
    exposing
        ( Node
        , map
        , text
        )


type Node m
    = TextNode String


text : String -> Node m
text =
    TextNode


map : (a -> b) -> Node a -> Node b
map transform node =
    case node of
        TextNode text ->
            TextNode text
