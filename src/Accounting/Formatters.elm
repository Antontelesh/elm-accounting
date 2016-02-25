module Accounting.Formatters (formatAmount, formatDate) where

import String
import Date

formatAmount : Float -> String
formatAmount amount =
  let
    str = toString amount
    parts = String.split "." str
    maybeWholes = List.head parts
    maybeCoins = List.head (List.drop 1 parts)
    wholes = Maybe.withDefault "0" maybeWholes
    coins = Maybe.withDefault "00" maybeCoins
    fullCoins = String.padRight 2 '0' coins
  in
    wholes ++ "," ++ fullCoins



formatDate : String -> String
formatDate date =
  let
    resolve attr fn = fn attr

    year = toString << Date.year
    month = toString << Date.month
    day = toString << Date.day

  in
    case Date.fromString date of
      Result.Ok d ->
        [day, month, year]
          |> List.map (resolve d)
          |> String.join " "

      Result.Err _ -> ""
