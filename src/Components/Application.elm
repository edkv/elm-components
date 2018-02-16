module Components.Application
    exposing
        ( Application
        , Self
        , Spec
        , application
        , applicationWithFlags
        )

import Components exposing (Component, Container, Node, Signal, Slot)
import Components.RegularComponent as RegularComponent
import VirtualDom


type alias Application container flags =
    Program flags (State container flags) (Msg container)


type alias Spec v w s m p =
    { init : Self s m p -> ( s, Cmd m, List (Signal Never (Container s m p)) )
    , update : Self s m p -> m -> s -> ( s, Cmd m, List (Signal Never (Container s m p)) )
    , subscriptions : Self s m p -> s -> Sub m
    , view : Self s m p -> s -> Node v w m p
    , parts : p
    }


type alias Self s m p =
    Components.Self s m p (Container s m p)


type State container flags
    = State
        { componentState : Components.State container Never
        , flags : Maybe flags
        }


type Msg container
    = Msg (Components.Msg container Never)


application : Spec v w s m p -> Application (Container s m p) Never
application spec =
    VirtualDom.program
        { init = init spec Nothing
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


applicationWithFlags : (flags -> Spec v w s m p) -> Application (Container s m p) flags
applicationWithFlags getSpec =
    VirtualDom.programWithFlags
        { init = \flags -> init (getSpec flags) (Just flags)
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init :
    Spec v w s m p
    -> Maybe flags
    -> ( State (Container s m p) flags, Cmd (Msg (Container s m p)) )
init spec flags =
    let
        ( componentState, cmd ) =
            RegularComponent.regularComponent spec
                |> Components.init
    in
    ( State
        { componentState = componentState
        , flags = flags
        }
    , Cmd.map Msg cmd
    )


update :
    Msg (Container s m p)
    -> State (Container s m p) flags
    -> ( State (Container s m p) flags, Cmd (Msg (Container s m p)) )
update (Msg msg) (State state) =
    let
        ( componentState, cmd, _ ) =
            Components.update msg state.componentState
    in
    ( State { state | componentState = componentState }
    , Cmd.map Msg cmd
    )


subscriptions : State (Container s m p) flags -> Sub (Msg (Container s m p))
subscriptions (State state) =
    Components.subscriptions state.componentState
        |> Sub.map Msg


view : State (Container s m p) flags -> VirtualDom.Node (Msg (Container s m p))
view (State state) =
    Components.view state.componentState
        |> VirtualDom.map Msg
