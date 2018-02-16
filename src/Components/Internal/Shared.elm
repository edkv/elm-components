module Components.Internal.Shared
    exposing
        ( HtmlItem(HtmlItem)
        , InternalStuff(InternalStuff)
        , Self
        , SvgItem(SvgItem)
        , identify
        , svgNamespace
        , toParentSignal
        )

import Components.Internal.Core exposing (..)
import Json.Encode as Json
import VirtualDom


type HtmlItem
    = HtmlItem


type SvgItem
    = SvgItem


type alias Self s m p pP =
    { id : String
    , internal : InternalStuff s m p pP
    }


type InternalStuff s m p pP
    = InternalStuff
        { slot : Slot (Container s m p) pP
        , freshContainers : p
        , freshParentContainers : pP
        }


toParentSignal :
    Slot (Container s m p) pP
    -> pP
    -> Signal m p
    -> Signal pM pP
toParentSignal (( _, set ) as slot) freshParentContainers signal =
    freshParentContainers
        |> set (SignalContainer signal)
        |> ChildMsg (identify slot)


identify : Slot (Container s m p) pP -> Identify pP
identify ( get, _ ) args =
    case get args.states of
        StateContainer state ->
            Just state.id

        _ ->
            Nothing


svgNamespace : Attribute SvgItem m p
svgNamespace =
    VirtualDom.property "namespace" (Json.string "http://www.w3.org/2000/svg")
        |> PlainAttribute
