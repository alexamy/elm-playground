{- Task #2
The task is to build a frame containing two textfields TC and TF representing the temperature in Celsius and Fahrenheit, respectively.
Initially, both TC and TF are empty.
When the user enters a numerical value into TC the corresponding value in TF is automatically updated and vice versa.
When the user enters a non-numerical string into TC the value in TF is not updated and vice versa.
The formula for converting a temperature C in Celsius into a temperature F in Fahrenheit is C = (F - 32) * (5/9)
and the dual direction is F = C * (9/5) + 32.
-}

module TemperatureConverter exposing (..)

import Browser
import Html exposing (div, text, span, input)
import Html.Attributes exposing (value)
import Html.Attributes exposing (style)

main =
  Browser.sandbox { init = init, update = update, view = view }

init =
  0

update msg model =
  model

view model =
  div []
    [ input [ value (String.fromInt model) ] []
    , text "Celsius"
    , span [ style "padding" "0 10px" ] [ text "=" ]
    , input [ value (String.fromInt model) ] []
    , text "Fahrenheit"
    ]
