{- Task #1
The task is to build a frame containing a label or read-only textfield T and a button B.
Initially, the value in T is “0” and each click of B increases the value in T by one.
-}

module Timer exposing (..)

import Browser
import Html exposing (div, text, button, input)
import Html.Events exposing (onClick)
import Html.Attributes exposing (value)
import Html.Attributes exposing (readonly)

main =
  Browser.sandbox { init = 0, update = update, view = view }

type Msg = Increment

update msg model =
  case msg of
    Increment ->
      model + 1

view model =
  div []
    [ input
        [ value (String.fromInt model)
        , readonly True
        ] []
    , button [ onClick Increment ] [ text "Count" ]
    ]
