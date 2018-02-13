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


type alias Application flags s m p =
    Program flags (State flags s m p) (Msg s m p)


type alias Spec v w s m p =
    { init : Self p -> ( s, Cmd m, List (Signal m p) )
    , update : Self p -> m -> s -> ( s, Cmd m, List (Signal m p) )
    , subscriptions : Self p -> s -> Sub m
    , view : Self p -> s -> Node v w m p
    , parts : p
    }


type alias Self p =
    { id : String
    , internal : InternalStuff p
    }


type alias State flags s m p =
    { componentState : Components.State (Container s m p)
    , flags : Maybe flags
    }


type alias Msg s m p =
    Components.Msg (Container s m p)


type InternalStuff c
    = InternalStuff
        { freshContainers : c
        }


application : Spec v w s m p -> Application Never s m p
application spec =
    VirtualDom.program
        { init = init spec Nothing
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


applicationWithFlags : (flags -> Spec v w s m p) -> Application flags s m p
applicationWithFlags getSpec =
    VirtualDom.programWithFlags
        { init = \flags -> init (getSpec flags) (Just flags)
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Spec v w s m p -> Maybe flags -> ( State flags s m p, Cmd (Msg s m p) )
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


update : Msg s m p -> State flags s m p -> ( State flags s m p, Cmd (Msg s m p) )
update msg state =
    let
        ( componentState, cmd ) =
            Components.update msg state.componentState
    in
    ( { state | componentState = componentState }
    , cmd
    )


subscriptions : State flags s m p -> Sub (Msg s m p)
subscriptions state =
    Components.subscriptions state.componentState


view : State flags s m p -> VirtualDom.Node (Msg s m p)
view state =
    Components.view state.componentState


buildComponent :
    Spec v w s m p
    -> Component v w (Container s m p) Never (Container s m p)
buildComponent spec =
    RegularComponent.regularComponent
        { spec
            | init = transformSelf spec >> initComponent spec
            , update = transformSelf spec >> updateComponent spec
            , subscriptions = transformSelf spec >> spec.subscriptions
            , view = transformSelf spec >> spec.view
        }


initComponent :
    Spec v w s m p
    -> Self p
    -> ( s, Cmd m, List (Signal Never (Container s m p)) )
initComponent spec self =
    let
        ( state, cmd, signals ) =
            spec.init self
    in
    ( state, cmd, List.map transformSignal signals )


updateComponent :
    Spec v w s m p
    -> Self p
    -> m
    -> s
    -> ( s, Cmd m, List (Signal Never (Container s m p)) )
updateComponent spec self msg state =
    let
        ( updatedState, cmd, signals ) =
            spec.update self msg state
    in
    ( updatedState, cmd, List.map transformSignal signals )


transformSignal : Signal m p -> Signal Never (Container s m p)
transformSignal =
    Core.SignalContainer >> Core.ChildMsg (\_ -> Nothing)


transformSelf : Spec v w s m p -> RegularComponent.Self s m p pP -> Self p
transformSelf spec self =
    { id = self.id
    , internal =
        InternalStuff
            { freshContainers = spec.parts
            }
    }


sendToChild : Self p -> Slot (Container cS cM cP) p -> cM -> Signal m p
sendToChild self slot msg =
    let
        (InternalStuff { freshContainers }) =
            self.internal
    in
    msg
        |> Core.LocalMsg
        |> toParentSignal slot freshContainers
