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
import List exposing (all)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value, disabled)

import Date
import Flight exposing (Flight)

main : Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }

-- TYPES

type alias Model =
  { status: Flight
  , startDate: String
  , returnDate: String
  }

init : Model
init =
  { status = Flight.OneWay
  , startDate = "2021-01-01"
  , returnDate = "2021-01-01"
  }

type Msg
  = Select String
  | SetStart String
  | SetReturn String

-- UPDATE

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetStart date -> { model | startDate = date }
    SetReturn date -> { model | returnDate = date }
    Select kind ->
      case Flight.fromString kind of
        Just f -> { model | status = f }
        Nothing -> model

-- DATE

isDate : String -> Bool
isDate dateString =
  case Date.fromIsoString dateString of
    Ok _ -> True
    Err _ -> False

isProperDateOrder : String -> String -> Bool
isProperDateOrder s1 s2 =
  case Result.map2 Date.compare (Date.fromIsoString s1) (Date.fromIsoString s2) of
    Err _ -> False
    Ok order -> order /= GT

-- VIEW

noAttribute : Attribute msg
noAttribute = style "" ""

buttonEnabled : Model -> Bool
buttonEnabled model =
  case model.status of
    Flight.OneWay -> isDate model.startDate
    Flight.Return -> (all isDate [model.startDate, model.returnDate]) && (isProperDateOrder model.startDate model.returnDate)

formAttributes : List (Attribute msg)
formAttributes =
  [ style "display" "flex"
  , style "flex-direction" "column"
  , style "width" "200px"
  ]

type alias Color = String
inputBackground : String -> Attribute msg
inputBackground s =
  case Date.fromIsoString s of
    Ok _ -> noAttribute
    Err _ -> style "background" "#e84118"

startInputBackground : Model -> Attribute msg
startInputBackground model =
  inputBackground model.startDate

returnInputBackground : Model -> Attribute msg
returnInputBackground model =
  case model.status of
    Flight.OneWay -> noAttribute
    Flight.Return -> inputBackground model.returnDate

view : Model -> Html Msg
view model =
  form
    formAttributes
    [ select
        [ onInput Select ]
        [ option [] [ text (Flight.toString Flight.OneWay) ]
        , option [] [ text (Flight.toString Flight.Return) ]
        ]
    , input
        [ value (model.startDate)
        , onInput SetStart
        , startInputBackground model
        ]
        []
    , input
        [ value (model.returnDate)
        , disabled (model.status == Flight.OneWay)
        , onInput SetReturn
        , returnInputBackground model
        ]
        []
    , button
        [ disabled (model |> buttonEnabled |> not) ]
        [ text "Book" ]
    ]
