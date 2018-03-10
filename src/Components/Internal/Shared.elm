module Components.Internal.Shared
    exposing
        ( identify
        , svgNamespace
        , toConsumerSignal
        )

import Components.Internal.Core exposing (..)
import Json.Encode as Json
import VirtualDom


toConsumerSignal :
    Slot (Container s m p) cP
    -> cP
    -> Signal m p
    -> Signal oM cP
toConsumerSignal (( _, set ) as slot) freshConsumerContainers signal =
    freshConsumerContainers
        |> set (SignalContainer signal)
        |> PartMsg (identify slot)


identify : Slot (Container s m p) cP -> Identify cP
identify ( get, _ ) args =
    case get args.states of
        StateContainer state ->
            Just state.id

        _ ->
            Nothing


svgNamespace : Attribute m p
svgNamespace =
    VirtualDom.property "namespace" (Json.string "http://www.w3.org/2000/svg")
        |> PlainAttribute
