module Components.Application
    exposing
        ( Application
        , ApplicationWithFlags
        , Self
        , Spec
        , application
        , applicationWithFlags
        , sendToChild
        )

import Components exposing (Container, Signal, Slot)
import Components.Html exposing (Html)
import Components.Html.RegularComponent as RegularComponent
import Components.Internal.Core as Core
import VirtualDom


type alias Application c m s =
    Program Never (State () c m s) (Msg c m s)


type alias ApplicationWithFlags flags c m s =
    Program flags (State flags c m s) (Msg c m s)


type alias Spec c m s =
    { init : Self c -> ( s, Cmd m, List (Signal c m) )
    , update : Self c -> m -> s -> ( s, Cmd m, List (Signal c m) )
    , subscriptions : Self c -> s -> Sub m
    , view : Self c -> s -> Html c m
    , children : c
    }


type alias Self c =
    { id : String
    , internal : InternalData c
    }


type alias State flags c m s =
    { componentState : Components.State (Container c m s)
    , flags : flags
    }


type alias Msg c m s =
    Components.Msg (Container c m s)


type InternalData c
    = InternalData
        { freshContainers : c
        }


application : Spec c m s -> Application c m s
application spec =
    VirtualDom.program
        { init = init spec ()
        , update = update spec
        , subscriptions = subscriptions
        , view = view
        }


applicationWithFlags : (flags -> Spec c m s) -> ApplicationWithFlags flags c m s
applicationWithFlags getSpec =
    VirtualDom.programWithFlags
        { init = \flags -> init (getSpec flags) flags
        , update = \msg state -> update (getSpec state.flags) msg state
        , subscriptions = subscriptions
        , view = view
        }


init : Spec c m s -> flags -> ( State flags c m s, Cmd (Msg c m s) )
init spec flags =
    let
        ( componentState, cmd ) =
            Components.init
    in
    ( { componentState = componentState
      , flags = flags
      }
    , cmd
    )


update :
    Spec c m s
    -> Msg c m s
    -> State flags c m s
    -> ( State flags c m s, Cmd (Msg c m s) )
update spec msg state =
    let
        component =
            RegularComponent.regularComponent
                { spec
                    | init = transformSelf spec >> initComponent spec
                    , update = transformSelf spec >> updateComponent spec
                    , subscriptions = transformSelf spec >> spec.subscriptions
                    , view = transformSelf spec >> spec.view
                }

        ( newComponentState, cmd ) =
            Components.update component msg state.componentState
    in
    ( { state | componentState = newComponentState }
    , cmd
    )


subscriptions : State flags c m s -> Sub (Msg c m s)
subscriptions state =
    Components.subscriptions state.componentState


view : State flags c m s -> VirtualDom.Node (Msg c m s)
view state =
    Components.view state.componentState


initComponent :
    Spec c m s
    -> Self c
    -> ( s, Cmd m, List (Signal (Container c m s) Never) )
initComponent spec self =
    let
        ( state, cmd, outSignals ) =
            spec.init self
    in
    ( state
    , cmd
    , List.map (Core.SignalContainer >> Core.ChildMsg) outSignals
    )


updateComponent :
    Spec c m s
    -> Self c
    -> m
    -> s
    -> ( s, Cmd m, List (Signal (Container c m s) Never) )
updateComponent spec self msg state =
    let
        ( newState, cmd, outSignals ) =
            spec.update self msg state
    in
    ( newState
    , cmd
    , List.map (Core.SignalContainer >> Core.ChildMsg) outSignals
    )


transformSelf : Spec c m s -> RegularComponent.Self c m s pC -> Self c
transformSelf spec self =
    { id = self.id
    , internal =
        InternalData
            { freshContainers = spec.children
            }
    }


sendToChild : Self c -> Slot (Container cC cM cS) c -> cM -> Signal c m
sendToChild self ( _, set ) msg =
    let
        (InternalData internalData) =
            self.internal
    in
    internalData.freshContainers
        |> set (Core.SignalContainer (Core.LocalMsg msg))
        |> Core.ChildMsg
