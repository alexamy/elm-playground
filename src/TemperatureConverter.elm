{- Task #2
The task is to build a frame containing two textfields TC and TF representing the temperature in Celsius and Fahrenheit, respectively.
Initially, both TC and TF are empty.
When the user enters a numerical value into TC the corresponding value in TF is automatically updated and vice versa.
When the user enters a non-numerical string into TC the value in TF is not updated and vice versa.
The formula for converting a temperature C in Celsius into a temperature F in Fahrenheit is C = (F - 32) * (5/9)
and the dual direction is F = C * (9/5) + 32.

---I will skip that part---
When the user enters a non-numerical string into TC the value in TF is not updated and vice versa.

Why do I need to have non-meaningful values anyway?
-}

module TemperatureConverter exposing (..)

import Browser
import Html exposing (Html, div, text, span, input)
import Html.Attributes exposing (value)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput)

celsiusFromFahrenheit f =
  (f - 32) * 5 / 9

fahrenheitFromCelsius c =
  c * 9 / 5 + 32

main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  Float

init : Model
init =
  0.0

type Msg
  = Celsius Float
  | Fahrenheit Float

toFloat : (Float -> Msg) -> String -> Msg
toFloat constructor =
  \s -> constructor (Maybe.withDefault 0 (String.toFloat s))

update : Msg -> Model -> Model
update msg model =
  case msg of
    Celsius c ->
      c
    Fahrenheit f ->
      celsiusFromFahrenheit f

view : Model -> Html Msg
view model =
  div []
    [ input
      [ onInput (toFloat Celsius)
      , value (String.fromFloat model)
      ]
      []
    , text "Celsius"
    , span [ style "padding" "0 10px" ] [ text "=" ]
    , input
      [ onInput (toFloat Fahrenheit)
      , value (String.fromFloat (fahrenheitFromCelsius model))
      ]
      []
    , text "Fahrenheit"
    ]
