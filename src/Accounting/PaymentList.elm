module Accounting.PaymentList (view, Context) where

import Html exposing (div, h2, table, thead, tbody, tfoot, tr, td, text, button)
import Html.Attributes exposing (style, class, key, type')
import Html.Events exposing (onClick)

import Accounting.Formatters exposing (formatAmount, formatDate)
import Accounting.Interfaces exposing (..)
import Accounting.Utils exposing (..)

type alias Context =
  { remove: Signal.Address Id
  }

amountText : Bool -> Float -> String
amountText isShown amount =
  if isShown
    then formatAmount amount
    else " "


view : Context -> List Payment -> Html.Html
view context payments =
  div
    [ class "payment-list" ]
    [ h2 [] [text "Payments"]
    , table
        [ class "payment-list__list"
        , style [("width", "100%")]
        ]
        [ thead
            [ style [ ("font-weight", "bold") ] ]
            [ tr
                []
                [ td [] [ text "Date" ]
                , td [] [ text "Description" ]
                , td [] [ text "Income" ]
                , td [] [ text "Outcome" ]
                ]
            ]
        ]
        , tbody
            []
            (List.map (itemView context) payments)
        , tfoot
            [ style [("font-weight", "bold")]]
            [ tr
                []
                [ td [] [ text "Total" ]
                , td [] [ text " " ]
                , td [] [ text << formatAmount <| totalIncome payments ]
                , td [] [ text << formatAmount <| totalOutcome payments ]
                ]
            ]
        ]

itemView context payment =
  let
    supplyAmount =
      amountText (isSupply payment) payment.amount

    withdrawAmount =
      amountText (isWithdraw payment) payment.amount

  in
    tr
      [ class "payment-list__list-item payment-list-item"
      , key <| toString payment.id ]
      [ td
          [ class "payment-list-item__date" ]
          [ text <| formatDate payment.date ]
      , td
          [ class "payment-list-item__description" ]
          [ text payment.description ]
      , td
          [ class "payment-list-item__amount-supply" ]
          [ text supplyAmount ]
      , td
          [ class "payment-list-item__amount-withdraw" ]
          [ text withdrawAmount ]
      , td
          []
          [ button
              [ type' "button"
              , onClick context.remove payment.id
              ]
              [ text "×" ]
          ]
      ]
