module Components.Internal.Shared
    exposing
        ( ComponentInternalStuff(ComponentInternalStuff)
        , HtmlItem(HtmlItem)
        , SvgItem(SvgItem)
        , identify
        , svgNamespace
        , toOwnerSignal
        )

import Components.Internal.Core exposing (..)
import Json.Encode as Json
import VirtualDom


type HtmlItem
    = HtmlItem


type SvgItem
    = SvgItem


type ComponentInternalStuff s m p oP
    = ComponentInternalStuff
        { slot : Slot (Container s m p) oP
        , freshContainers : p
        , freshOwnerContainers : oP
        }


toOwnerSignal :
    Slot (Container s m p) oP
    -> oP
    -> Signal m p
    -> Signal oM oP
toOwnerSignal (( _, set ) as slot) freshOwnerContainers signal =
    freshOwnerContainers
        |> set (SignalContainer signal)
        |> PartMsg (identify slot)


identify : Slot (Container s m p) oP -> Identify oP
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
