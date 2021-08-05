{- Task #1
The task is to build a frame containing a label or read-only textfield T and a button B.
Initially, the value in T is “0” and each click of B increases the value in T by one.
-}

module Timer exposing (..)

import Browser
import Html exposing (Html, div, text)

main =
  Browser.sandbox { init = 0, update = update, view = view }

update msg model =
  0

view model =
  div [] [ text "Hello" ]
