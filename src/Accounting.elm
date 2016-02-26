module Accounting (view, update, init) where

import Html exposing (div)
import Html.Attributes exposing (class)
import String
import Result
import Effects
import Debug

import Accounting.Balance as Balance
import Accounting.PaymentList as PaymentList
import Accounting.PaymentForm as PaymentForm
import Accounting.Interfaces exposing (..)

type alias Model =
  { payments: List Payment
  , newPayment: PaymentForm.Model
  }

type Action
  = NoOp
  | AddPayment Payment
  | RemovePayment Id
  | Form PaymentForm.Action

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

inc = (+) 1

nextId : List Payment -> Id
nextId = Maybe.withDefault 0 << Maybe.map inc << List.maximum << List.map .id

initialModel : Model
initialModel =
  { payments = initialPayments
  , newPayment = PaymentForm.init <| nextId initialPayments
  }


init : (Model, Effects.Effects Action)
init = (initialModel, Effects.none)

paymentListView : Signal.Address Action -> List Payment -> Html.Html
paymentListView address payments =
  let
    context = PaymentList.Context
      (Signal.forwardTo address RemovePayment)
  in
    PaymentList.view context payments

formView : Signal.Address Action -> PaymentForm.Model -> Html.Html
formView address model =
  let
    context = PaymentForm.Context
      (Signal.forwardTo address Form)
      (Signal.forwardTo address AddPayment)
  in
    PaymentForm.view context model


view : Signal.Address Action -> Model -> Html.Html
view address model =
  div
    [ class "accounting" ]
    [ Balance.view model.payments
    , paymentListView address model.payments
    , formView address model.newPayment
    ]


updateModel action model =
  case action of
    NoOp ->
      model

    AddPayment payment ->
      let
        payments = model.payments ++ [ payment ]
        newPayment = PaymentForm.init <| nextId payments
      in
        { model |
            payments = payments
          , newPayment = newPayment
        }

    RemovePayment id ->
      { model |
        payments = List.filter (\p -> p.id /= id) model.payments
      }

    Form formAction ->
      let
        ( newPayment , _ ) = PaymentForm.update formAction model.newPayment
      in
        { model | newPayment = newPayment }



update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  let
    change = Debug.log "Change"
      { prevModel = model
      , action = action
      , nextModel = updateModel action model
      }
  in
    (change.nextModel, Effects.none)
