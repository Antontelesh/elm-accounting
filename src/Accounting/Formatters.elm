module Accounting.Formatters (formatAmount, formatDate) where

import String
import Date

formatAmount : Float -> String
formatAmount amount =
  let
    parts = amount
      |> toString
      |> String.split "."

    wholes = parts
      |> List.head
      |> Maybe.withDefault "0"

    coins = parts
      |> List.drop 1
      |> List.head
      |> Maybe.withDefault "00"
      |> String.padRight 2 '0'
  in
    wholes ++ "," ++ coins



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
