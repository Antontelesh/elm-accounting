module Accounting.PaymentForm (view, update, init, Action, Model, Context) where

import Html exposing (form, div, label, input, text)
import Html.Attributes exposing (class, value, type')
import Html.Events exposing (on, onWithOptions, onSubmit, targetValue)
import Json.Decode
import Json.Encode
import Effects
import String
import Date

import Accounting.Interfaces exposing (..)

type Action
  = NoOp
  | SetDate String
  | SetDescription String
  | SetAmount String

type alias Context =
  { actions: Signal.Address Action
  , submit: Signal.Address Payment
  }

type alias FormData a = { a | amount: String }
type alias Model = FormData Payment

parseAmount : String -> Result String Float
parseAmount = String.toFloat

init : Id -> Model
init id =
  { id = id
  , type' = Supply
  , date = ""
  , description = ""
  , amount = ""
  }

createPayment : Model -> Result String Payment
createPayment model =
  let
    amountResult = parseAmount model.amount
    dateResult = Date.fromString model.date
    create amount _ =
      { model | amount = amount }
  in
    Result.map2 create amountResult dateResult



updateModel : Action -> Model -> Model
updateModel action model =
  case action of
    NoOp ->
      model

    SetDate date ->
      { model | date = date }

    SetDescription text ->
      { model | description = text }

    SetAmount value ->
      { model | amount = value }


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  let
    model' = updateModel action model
  in
    (model', Effects.none)

preventDefault =
  { preventDefault = True
  , stopPropagation = True
  }

onSubmit : (Json.Encode.Value -> Signal.Message) -> Html.Attribute
onSubmit =
  onWithOptions
    "submit"
    preventDefault
    Json.Decode.value

submit : Context -> Model -> Signal.Message
submit context model =
  case createPayment model of
    Ok payment ->
      Signal.message context.submit payment
    Err _ ->
      Signal.message context.actions NoOp

action address ctor =
  Signal.message address << ctor

block contents =
  div [ class "form-block" ] contents

controlGroup name' contents =
  block <| [ label [] [ text name' ] ] ++ contents

view : Context -> Model -> Html.Html
view context model =
  let
    action' = action context.actions
    setDate = action' SetDate
    setDescription = action' SetDescription
    setAmount = action' SetAmount
  in
    form
      [ onSubmit (\_ -> submit context model) ]
      [ controlGroup "Payment Date"
          [ input
              [ on "input" targetValue setDate
              , value model.date
              ] []
          ]

      , controlGroup "Description"
          [ input
              [ on "input" targetValue setDescription
              , value model.description
              ] []
          ]

      , controlGroup "Amount"
          [ input
              [ on "input" targetValue setAmount
              , value model.amount
              ] []
          ]

      , block
          [ input
              [ type' "submit"
              , value "Submit"
              ] []
          ]
      ]
