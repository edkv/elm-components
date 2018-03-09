module Components.Test.BasicTests exposing (tests)

import Components
import Components.Test.Support.App as App
import Components.Test.Support.Counter as Counter
import Expect
import Fuzz
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


tests : Test
tests =
    Test.concat
        [ Test.fuzz Fuzz.string "Generates a namespaced id" <|
            \namespace ->
                Counter.counter
                    { initialValue = 0
                    , step = 1
                    }
                    |> App.initWithNamespace namespace
                    |> App.render
                    |> Query.has [ Selector.id ("_" ++ namespace ++ "_1") ]
        , Test.fuzz Fuzz.int "Renders component" <|
            \initialValue ->
                Counter.counter
                    { initialValue = initialValue
                    , step = 1
                    }
                    |> App.init
                    |> expectCounterValue initialValue
        , Test.fuzz2 Fuzz.int Fuzz.int "Updates component" <|
            \initialValue step ->
                let
                    counter =
                        Counter.counter
                            { initialValue = initialValue
                            , step = step
                            }
                            |> App.init

                    incrementedCounter =
                        counter
                            |> incrementCounter
                            |> incrementCounter

                    decrementedCounter =
                        incrementedCounter
                            |> decrementCounter
                in
                Expect.all
                    [ \() ->
                        expectCounterValue
                            (initialValue + 2 * step)
                            incrementedCounter
                    , \() ->
                        expectCounterValue
                            (initialValue + step)
                            decrementedCounter
                    ]
                    ()
        ]


incrementCounter =
    changeCounter "increment"


decrementCounter =
    changeCounter "decrement"


changeCounter action counter =
    let
        button =
            App.render counter
                |> Query.find [ Selector.id action ]
    in
    App.trigger Event.click button counter


expectCounterValue value =
    App.render
        >> Query.find [ Selector.id "value" ]
        >> Query.has [ Selector.text (toString value) ]
