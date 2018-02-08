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
import Components.Internal.Shared exposing (toParentSignal)
import Components.RegularComponent as RegularComponent
import VirtualDom


type alias Application flags s m c =
    Program flags (State flags s m c) (Msg s m c)


type alias Spec v w s m c =
    { init : Self c -> ( s, Cmd m, List (Signal m c) )
    , update : Self c -> m -> s -> ( s, Cmd m, List (Signal m c) )
    , subscriptions : Self c -> s -> Sub m
    , view : Self c -> s -> Node v w m c
    , children : c
    }


type alias Self c =
    { id : String
    , internal : InternalStuff c
    }


type alias State flags s m c =
    { componentState : Components.State (Container s m c)
    , flags : Maybe flags
    }


type alias Msg s m c =
    Components.Msg (Container s m c)


type InternalStuff c
    = InternalStuff
        { freshContainers : c
        }


application : Spec v w s m c -> Application Never s m c
application spec =
    VirtualDom.program
        { init = init spec Nothing
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


applicationWithFlags : (flags -> Spec v w s m c) -> Application flags s m c
applicationWithFlags getSpec =
    VirtualDom.programWithFlags
        { init = \flags -> init (getSpec flags) (Just flags)
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Spec v w s m c -> Maybe flags -> ( State flags s m c, Cmd (Msg s m c) )
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


update : Msg s m c -> State flags s m c -> ( State flags s m c, Cmd (Msg s m c) )
update msg state =
    let
        ( componentState, cmd ) =
            Components.update msg state.componentState
    in
    ( { state | componentState = componentState }
    , cmd
    )


subscriptions : State flags s m c -> Sub (Msg s m c)
subscriptions state =
    Components.subscriptions state.componentState


view : State flags s m c -> VirtualDom.Node (Msg s m c)
view state =
    Components.view state.componentState


buildComponent :
    Spec v w s m c
    -> Component v w (Container s m c) Never (Container s m c)
buildComponent spec =
    RegularComponent.regularComponent
        { spec
            | init = transformSelf spec >> initComponent spec
            , update = transformSelf spec >> updateComponent spec
            , subscriptions = transformSelf spec >> spec.subscriptions
            , view = transformSelf spec >> spec.view
        }


initComponent :
    Spec v w s m c
    -> Self c
    -> ( s, Cmd m, List (Signal Never (Container s m c)) )
initComponent spec self =
    let
        ( state, cmd, signals ) =
            spec.init self
    in
    ( state, cmd, List.map transformSignal signals )


updateComponent :
    Spec v w s m c
    -> Self c
    -> m
    -> s
    -> ( s, Cmd m, List (Signal Never (Container s m c)) )
updateComponent spec self msg state =
    let
        ( updatedState, cmd, signals ) =
            spec.update self msg state
    in
    ( updatedState, cmd, List.map transformSignal signals )


transformSignal : Signal m c -> Signal Never (Container s m c)
transformSignal =
    Core.SignalContainer >> Core.ChildMsg (\_ -> Nothing)


transformSelf : Spec v w s m c -> RegularComponent.Self s m c pC -> Self c
transformSelf spec self =
    { id = self.id
    , internal =
        InternalStuff
            { freshContainers = spec.children
            }
    }


sendToChild : Self c -> Slot (Container cS cM cC) c -> cM -> Signal m c
sendToChild self slot msg =
    let
        (InternalStuff { freshContainers }) =
            self.internal
    in
    msg
        |> Core.LocalMsg
        |> toParentSignal slot freshContainers
