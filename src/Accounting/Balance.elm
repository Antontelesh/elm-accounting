module Accounting.Balance (view) where

import Html exposing (h2, text)
import Html.Attributes exposing (class, style)

import Accounting.Formatters exposing (formatAmount)
import Accounting.Interfaces exposing (..)
import Accounting.Utils exposing (..)


view : List Payment -> Html.Html
view payments =
  let
    balance' = balance payments
    color = if balance' > 0 then "green" else if balance' < 0 then "red" else "black"
  in
    h2
      [ class "balance"
      , style [("color", color)]
      ]
      [ text ("Balance: " ++ (formatAmount balance')) ]
