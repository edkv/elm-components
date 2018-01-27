module Components.Application
    exposing
        ( Application
        , Self
        , Spec
        , application
        , applicationWithFlags
        , sendToChild
        )

import Components exposing (Component, Container, Node, Signal, Slot)
import Components.Internal.Core as Core
import Components.RegularComponent as RegularComponent
import VirtualDom


type alias Application flags c m s =
    Program flags (State flags c m s) (Msg c m s)


type alias Spec v w c m s =
    { init : Self c -> ( s, Cmd m, List (Signal c m) )
    , update : Self c -> m -> s -> ( s, Cmd m, List (Signal c m) )
    , subscriptions : Self c -> s -> Sub m
    , view : Self c -> s -> Node v w c m
    , children : c
    }


type alias Self c =
    { id : String
    , internal : InternalStuff c
    }


type alias State flags c m s =
    { componentState : Components.State (Container c m s)
    , flags : Maybe flags
    }


type alias Msg c m s =
    Components.Msg (Container c m s)


type InternalStuff c
    = InternalStuff
        { freshContainers : c
        }


application : Spec v w c m s -> Application Never c m s
application spec =
    VirtualDom.program
        { init = init spec Nothing
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


applicationWithFlags : (flags -> Spec v w c m s) -> Application flags c m s
applicationWithFlags getSpec =
    VirtualDom.programWithFlags
        { init = \flags -> init (getSpec flags) (Just flags)
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Spec v w c m s -> Maybe flags -> ( State flags c m s, Cmd (Msg c m s) )
init spec flags =
    let
        ( componentState, cmd ) =
            Components.init (buildComponent spec)
    in
    ( { componentState = componentState
      , flags = flags
      }
    , cmd
    )


update : Msg c m s -> State flags c m s -> ( State flags c m s, Cmd (Msg c m s) )
update msg state =
    let
        ( componentState, cmd ) =
            Components.update msg state.componentState
    in
    ( { state | componentState = componentState }
    , cmd
    )


subscriptions : State flags c m s -> Sub (Msg c m s)
subscriptions state =
    Components.subscriptions state.componentState


view : State flags c m s -> VirtualDom.Node (Msg c m s)
view state =
    Components.view state.componentState


buildComponent :
    Spec v w c m s
    -> Component v w (Container c m s) (Container c m s) Never
buildComponent spec =
    RegularComponent.regularComponent
        { spec
            | init = transformSelf spec >> initComponent spec
            , update = transformSelf spec >> updateComponent spec
            , subscriptions = transformSelf spec >> spec.subscriptions
            , view = transformSelf spec >> spec.view
        }


initComponent :
    Spec v w c m s
    -> Self c
    -> ( s, Cmd m, List (Signal (Container c m s) Never) )
initComponent spec self =
    let
        ( state, cmd, signals ) =
            spec.init self
    in
    ( state
    , cmd
    , List.map (Core.SignalContainer >> Core.ChildMsg) signals
    )


updateComponent :
    Spec v w c m s
    -> Self c
    -> m
    -> s
    -> ( s, Cmd m, List (Signal (Container c m s) Never) )
updateComponent spec self msg state =
    let
        ( updatedState, cmd, signals ) =
            spec.update self msg state
    in
    ( updatedState
    , cmd
    , List.map (Core.SignalContainer >> Core.ChildMsg) signals
    )


transformSelf : Spec v w c m s -> RegularComponent.Self c m s pC -> Self c
transformSelf spec self =
    { id = self.id
    , internal =
        InternalStuff
            { freshContainers = spec.children
            }
    }


sendToChild : Self c -> Slot (Container cC cM cS) c -> cM -> Signal c m
sendToChild self ( _, set ) msg =
    let
        (InternalStuff { freshContainers }) =
            self.internal
    in
    freshContainers
        |> set (Core.SignalContainer (Core.LocalMsg msg))
        |> Core.ChildMsg
