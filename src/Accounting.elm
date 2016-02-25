module Accounting (view, update, init) where

import Html exposing (div)
import Html.Attributes exposing (class)
import Effects

import Accounting.Balance as Balance
import Accounting.PaymentList as PaymentList
import Accounting.PaymentForm as PaymentForm
import Accounting.Interfaces exposing (..)


initialPayments : List Payment
initialPayments =
  [ payment 0 Withdraw 119790 "MacBook Pro 13\" 2015 8Gb/256Gb" "2016-02-24"
  , payment 1 Supply   576000 "Salary for October, November, December, January" "2016-02-25"
  ]

payment id type' amount description date =
  { id = id
  , type' = type'
  , amount = amount
  , description = description
  , date = date
  }

emptyPayment id =
  payment id Supply 0 "" ""

inc = (+) 1

nextId : List Payment -> Id
nextId = Maybe.withDefault 0 << Maybe.map inc << List.maximum << List.map .id

initialModel : Model
initialModel =
  { payments = initialPayments
  , newPayment = emptyPayment <| List.length initialPayments
  }


init : (Model, Effects.Effects Action)
init = (initialModel, Effects.none)


view : Signal.Address Action -> Model -> Html.Html
view address model =
  div
    [ class "accounting" ]
    [ Balance.view address model
    , PaymentList.view address model
    , PaymentForm.view address model
    ]


updateModel action model =
  case action of
    NoOp ->
      model

    AddPayment ->
      let
        payments = model.payments ++ [model.newPayment]
        newPayment = emptyPayment <| nextId payments
      in
        { model |
            payments = payments,
            newPayment = newPayment
        }

    RemovePayment id ->
      { model |
        payments = List.filter (\p -> p.id /= id) model.payments
      }

    UpdateDate date ->
      let
        oldPayment = model.newPayment
        newPayment = { oldPayment | date = date }
      in
        { model | newPayment = newPayment }

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  (updateModel action model, Effects.none)
