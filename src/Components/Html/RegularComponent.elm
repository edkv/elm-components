module Components.Html.RegularComponent
    exposing
        ( Options
        , Self
        , Spec
        , SpecWithOptions
        , defaultOptions
        , regularComponent
        , regularComponentWithOptions
        )

import Components exposing (Container, Signal)
import Components.Html exposing (Component, Html)
import Components.Internal.Core exposing (Node)
import Components.Internal.RegularComponent as RegularComponent
import Components.Internal.Shared
    exposing
        ( HtmlComponent(HtmlComponent)
        , HtmlNode(HtmlNode)
        )


type alias Spec c m s pC pM =
    { init : Self -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self -> s -> Sub m
    , view : Self -> s -> Html c m
    , children : c
    }


type alias SpecWithOptions c m s pC pM =
    { init : Self -> ( s, Cmd m, List (Signal pC pM) )
    , update : Self -> m -> s -> ( s, Cmd m, List (Signal pC pM) )
    , subscriptions : Self -> s -> Sub m
    , view : Self -> s -> Html c m
    , children : c
    , options : Options m
    }


type alias Self =
    RegularComponent.Self


type alias Options m =
    RegularComponent.Options m


regularComponent : Spec c m s pC pM -> Component (Container c m s) pC pM
regularComponent spec =
    regularComponentWithOptions
        { init = spec.init
        , update = spec.update
        , subscriptions = spec.subscriptions
        , view = spec.view
        , children = spec.children
        , options = defaultOptions
        }


regularComponentWithOptions :
    SpecWithOptions c m s pC pM
    -> Component (Container c m s) pC pM
regularComponentWithOptions spec =
    { spec | view = view spec }
        |> RegularComponent.regularComponentWithOptions
        |> HtmlComponent


view : SpecWithOptions c m s pC pM -> Self -> s -> Node c m
view spec self state =
    let
        (HtmlNode node) =
            spec.view self state
    in
    node


defaultOptions : Options m
defaultOptions =
    RegularComponent.defaultOptions
