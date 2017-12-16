module Components.Internal.Elements
    exposing
        ( Attribute
        , EventOptions
        , attribute
        , defaultEventOptions
        , element
        , htmlStyles
        , inlineStyles
        , keyedElement
        , on
        , onWithOptions
        , property
        , text
        )

import Components.Internal.Core
    exposing
        ( Component
        , Node(Node)
        , NodeCall
        , Signal
        )
import Css
import Html.Styled
import Html.Styled.Attributes
import Html.Styled.Events
import Html.Styled.Keyed
import Json.Decode
import Json.Encode


type alias Attribute c m =
    Html.Styled.Attribute (Signal c m)


type alias EventOptions =
    Html.Styled.Events.Options


element : String -> List (Attribute c m) -> List (Node c m) -> Node c m
element tag attributes children =
    Node
        { call =
            callElement
                { children = children
                , unwrapChild = identity
                , wrapView = \child view -> view
                , makeNode = Html.Styled.node tag attributes
                }
        }


keyedElement :
    String
    -> List (Attribute c m)
    -> List ( String, Node c m )
    -> Node c m
keyedElement tag attributes children =
    Node
        { call =
            callElement
                { children = children
                , unwrapChild = \( key, child ) -> child
                , wrapView = \( key, child ) view -> ( key, view )
                , makeNode = Html.Styled.Keyed.node tag attributes
                }
        }


text : String -> Node c m
text value =
    Node
        { call =
            \args ->
                { newStates = args.newStates
                , cmd = Cmd.none
                , outSignals = []
                , sub = Sub.none
                , view = Html.Styled.text value
                , lastComponentId = args.lastComponentId
                }
        }


property : String -> Json.Encode.Value -> Attribute c m
property =
    Html.Styled.Attributes.property


attribute : String -> String -> Attribute c m
attribute =
    Html.Styled.Attributes.attribute


on : String -> Json.Decode.Decoder (Signal c m) -> Attribute c m
on =
    Html.Styled.Events.on


inlineStyles : List ( String, String ) -> Attribute c m
inlineStyles =
    Html.Styled.Attributes.style


htmlStyles : List Css.Style -> Attribute c m
htmlStyles =
    Html.Styled.Attributes.css


onWithOptions :
    String
    -> EventOptions
    -> Json.Decode.Decoder (Signal c m)
    -> Attribute c m
onWithOptions =
    Html.Styled.Events.onWithOptions


defaultEventOptions : EventOptions
defaultEventOptions =
    Html.Styled.Events.defaultOptions


callElement :
    { children : List child
    , unwrapChild : child -> Node c m
    , wrapView : child -> Html.Styled.Html (Signal c m) -> view
    , makeNode : List view -> Html.Styled.Html (Signal c m)
    }
    -> NodeCall c m
callElement { children, unwrapChild, wrapView, makeNode } args =
    let
        { newStates, cmd, outSignals, sub, views, lastComponentId } =
            List.foldl callChild initialData children

        initialData =
            { newStates = args.newStates
            , cmd = Cmd.none
            , outSignals = []
            , sub = Sub.none
            , views = []
            , lastComponentId = args.lastComponentId
            }

        callChild child prevData =
            let
                (Node node) =
                    unwrapChild child

                childCallResult =
                    node.call
                        { newStates = prevData.newStates
                        , currentStates = args.currentStates
                        , msg = args.msg
                        , freshContainers = args.freshContainers
                        , lastComponentId = prevData.lastComponentId
                        , namespace = args.namespace
                        }
            in
            { newStates = childCallResult.newStates
            , cmd = Cmd.batch [ prevData.cmd, childCallResult.cmd ]
            , outSignals = prevData.outSignals ++ childCallResult.outSignals
            , sub = Sub.batch [ prevData.sub, childCallResult.sub ]
            , views = wrapView child childCallResult.view :: prevData.views
            , lastComponentId = childCallResult.lastComponentId
            }
    in
    { newStates = newStates
    , cmd = cmd
    , outSignals = outSignals
    , sub = sub
    , view = makeNode (List.reverse views)
    , lastComponentId = lastComponentId
    }
