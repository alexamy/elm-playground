module Flight exposing (..)

type Flight
  = OneWay
  | Return

toString : Flight -> String
toString f =
  case f of
    OneWay -> "one-way flight"
    Return -> "return flight"

fromString : String -> Maybe Flight
fromString s =
  case s of
    "one-way flight" -> Just OneWay
    "return flight" -> Just Return
    _ -> Nothing
