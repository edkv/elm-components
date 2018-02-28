module Components.Test.Support.App
    exposing
        ( init
        , initWithNamespace
        , render
        , trigger
        , update
        )

import Components exposing (Component, Container, Msg, State)
import Components.Internal.Run as Run
import Json.Encode
import Test.Html.Event as Event exposing (Event)
import Test.Html.Query as Query


init :
    Component v (Container s m p) outMsg (Container s m p)
    -> State (Container s m p) outMsg
init =
    initWithNamespace ""


initWithNamespace :
    String
    -> Component v (Container s m p) outMsg (Container s m p)
    -> State (Container s m p) outMsg
initWithNamespace namespace =
    Components.init
        >> Tuple.first
        >> update (Run.NamespaceGenerated namespace)


update :
    Msg (Container s m p) outMsg
    -> State (Container s m p) outMsg
    -> State (Container s m p) outMsg
update msg component =
    let
        ( state, _, _ ) =
            Components.update msg component
    in
    state


render :
    Components.State (Container s m p) outMsg
    -> Query.Single (Msg (Container s m p) outMsg)
render =
    Components.view >> Query.fromHtml


trigger :
    ( String, Json.Encode.Value )
    -> Query.Single (Msg (Container s m p) outMsg)
    -> Components.State (Container s m p) outMsg
    -> State (Container s m p) outMsg
trigger event node component =
    node
        |> Event.simulate event
        |> Event.toResult
        |> Result.andThen (\msg -> Ok (update msg component))
        |> Result.withDefault component
