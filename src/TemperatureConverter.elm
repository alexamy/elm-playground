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

celsiusFromFahrenheit : Float -> Float
celsiusFromFahrenheit f =
  (f - 32) * 5 / 9

fahrenheitFromCelsius : Float -> Float
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

update : Msg -> Model -> Model
update msg _ =
  case msg of
    Celsius c ->
      c
    Fahrenheit f ->
      celsiusFromFahrenheit f

view : Model -> Html Msg
view model =
  div []
    [ input
        [ onInput (Celsius << Maybe.withDefault 0 << String.toFloat)
        , value (String.fromFloat model)
        ]
        []
    , text "Celsius"
    , span
        [ style "padding" "0 10px" ]
        [ text "=" ]
    , input
        [ onInput (Fahrenheit << Maybe.withDefault 0 << String.toFloat)
        , value (String.fromFloat <| fahrenheitFromCelsius <| model)
        ]
        []
    , text "Fahrenheit"
    ]
