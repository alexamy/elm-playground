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
import Html.Attributes exposing (value, style)
import Html.Events exposing (onInput)
import Debug exposing (toString)

celsiusFromFahrenheit : Float -> Float
celsiusFromFahrenheit f =
  (f - 32) * 5 / 9

fahrenheitFromCelsius : Float -> Float
fahrenheitFromCelsius c =
  c * 9 / 5 + 32

main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  { celsius: String
  , fahrenheit: String
  }

initCelsius : Float
initCelsius = 0.0

init : Model
init =
  { celsius = toString initCelsius,
    fahrenheit = toString <| fahrenheitFromCelsius <| initCelsius
  }

type Msg
  = Celsius String
  | Fahrenheit String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Celsius c ->
      { model | celsius = c, fahrenheit = if tryParse c then String.fromFloat <| fahrenheitFromCelsius <| Maybe.withDefault 0 <| String.toFloat <| c else model.fahrenheit }
    Fahrenheit f ->
      { model | fahrenheit = f, celsius = if tryParse f then String.fromFloat <| celsiusFromFahrenheit <| Maybe.withDefault 0 <| String.toFloat <| f else model.celsius }

tryParse s =
  case String.toFloat s of
     Just f -> True
     Nothing -> False

view : Model -> Html Msg
view model =
  div []
    [ input
        [ onInput Celsius
        , value model.celsius
        ]
        []
    , text "Celsius"
    , span
        [ style "padding" "0 10px" ]
        [ text "=" ]
    , input
        [ onInput Fahrenheit
        , value model.fahrenheit
        ]
        []
    , text "Fahrenheit"
    ]
