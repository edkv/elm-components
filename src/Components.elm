module Components
    exposing
        ( Container
        , Signal
        , Slot
        )

import Components.Internal.Core as Core


type alias Container c m s =
    Core.Container c m s


type alias Slot container c =
    Core.Slot container c


type alias Signal c m =
    Core.Signal c m