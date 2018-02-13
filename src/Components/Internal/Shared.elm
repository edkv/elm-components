module Components.Internal.Shared
    exposing
        ( HtmlItem(HtmlItem)
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
