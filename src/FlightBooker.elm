{- Task #3 - Flight Booker

The task is to build a frame containing a combobox C with the two options “one-way flight” and “return flight”,
two textfields T1 and T2 representing the start and return date, respectively, and a button B for submitting the selected flight.
T2 is enabled iff C’s value is “return flight”.
When C has the value “return flight” and T2’s date is strictly before T1’s then B is disabled.
When a non-disabled textfield T has an ill-formatted date then T is colored red and B is disabled.
When clicking B a message is displayed informing the user of his selection
(e.g. “You have booked a one-way flight on 04.04.2014.”).
Initially, C has the value “one-way flight” and T1 as well as T2 have the same (arbitrary) date (it is implied that T2 is disabled).
-}

module FlightBooker exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value)

main =
  Browser.sandbox { init = init, update = update, view = view }

type Flight
  = OneWay
  | Return

flightText : Flight -> String
flightText f =
  case f of
    OneWay -> "one-way flight"
    Return -> "return flight"

type alias Model =
  String

init : Model
init =
  ""

type Msg
  = Select String

update : Msg -> Model -> Model
update msg model =
  case msg of
     Select s -> s

formAttributes =
  [ style "display" "flex"
  , style "flex-direction" "column"
  , style "width" "200px"
  ]

view : Model -> Html Msg
view model =
  form
    formAttributes
    [ select
        [ onInput Select ]
        [ option [] [ text (flightText OneWay) ]
        , option [] [ text (flightText Return) ]
        ]
    , input
        [ value model ]
        []
    , input
        []
        []
    , button
        []
        [ text "Book" ]
    ]