{-
Task #3 - Flight Booker

The task is to build a frame containing a combobox C with the two options “one-way flight” and “return flight”,
two textfields T1 and T2 representing the start and return date, respectively, and a button B for submitting the selected flight.
T2 is enabled iff C’s value is “return flight”.
When C has the value “return flight” and T2’s date is strictly before T1’s then B is disabled.
When a non-disabled textfield T has an ill-formatted date then T is colored red and B is disabled.
When clicking B a message is displayed informing the user of his selection
(e.g. “You have booked a one-way flight on 04.04.2014.”).
Initially, C has the value “one-way flight” and T1 as well as T2 have the same (arbitrary) date (it is implied that T2 is disabled).
-}

-- add this under `var app = Elm.FlightBooker.init` in result HTML:
-- app.ports.showAlert.subscribe(function(msg) { alert(msg); });

port module FlightBooker exposing (..)

import Browser
import List exposing (all)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value, disabled)

import Date
import Flight exposing (Flight)
import Html.Events exposing (onClick)

port showAlert : String -> Cmd msg

main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

-- TYPES

type alias Model =
  { status: Flight
  , startDate: String
  , returnDate: String
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( { status = Flight.OneWay
    , startDate = "2021-01-01"
    , returnDate = "2021-01-01"
    }
  , Cmd.none
  )

type Msg
  = Select String
  | SetStart String
  | SetReturn String
  | Book

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Book ->
      ( model
      , showAlert (bookMessage model)
      )
    SetStart date ->
      ( { model | startDate = date }
      , Cmd.none
      )
    SetReturn date ->
      ( { model | returnDate = date }
      , Cmd.none
      )
    Select kind ->
      case Flight.fromString kind of
        Just f ->
          ( { model | status = f }
          , Cmd.none
          )
        Nothing ->
          ( model
          , Cmd.none
          )

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- HELPERS

bookMessage : Model -> String
bookMessage model =
  case model.status of
    Flight.OneWay -> String.concat
      [ "You have booked a "
      , (Flight.toString model.status)
      , " on "
      , model.startDate
      , "."
      ]
    Flight.Return -> String.concat
      [ "You have booked a "
      , (Flight.toString model.status)
      , " on "
      , model.startDate
      , " to "
      , model.returnDate
      , "."
      ]

isDate : String -> Bool
isDate dateString =
  case Date.fromIsoString dateString of
    Ok _ -> True
    Err _ -> False

isFirstDateLowerOrEqual : String -> String -> Bool
isFirstDateLowerOrEqual s1 s2 =
  case Result.map2 Date.compare (Date.fromIsoString s1) (Date.fromIsoString s2) of
    Err _ -> False
    Ok order -> order /= GT

-- VIEW

buttonEnabled : Model -> Bool
buttonEnabled model =
  case model.status of
    Flight.OneWay -> isDate model.startDate
    Flight.Return ->
      all isDate [model.startDate, model.returnDate] &&
      isFirstDateLowerOrEqual model.startDate model.returnDate

inputCheckBackground : String -> String
inputCheckBackground s =
  case Date.fromIsoString s of
    Ok _ -> ""
    Err _ -> "#e84118"

startInputBackground : Model -> Attribute msg
startInputBackground model =
  style "background" (inputCheckBackground model.startDate)

returnInputBackground : Model -> Attribute msg
returnInputBackground model =
  case model.status of
    Flight.OneWay -> style "" ""
    Flight.Return -> style "background" (inputCheckBackground model.returnDate)

view : Model -> Html Msg
view model =
  form
    [ style "display" "flex"
    , style "flex-direction" "column"
    , style "width" "200px"
    ]
    [ select
        [ onInput Select
        ]
        [ option [] [ text (Flight.toString Flight.OneWay) ]
        , option [] [ text (Flight.toString Flight.Return) ]
        ]
    , input
        [ onInput SetStart
        , value (model.startDate)
        , startInputBackground model
        ]
        []
    , input
        [ onInput SetReturn
        , value (model.returnDate)
        , disabled (model.status == Flight.OneWay)
        , returnInputBackground model
        ]
        []
    , button
        [ onClick Book
        , disabled (model |> buttonEnabled |> not)
        ]
        [ text "Book" ]
    ]
