module Accounting.Interfaces (..) where

type PaymentType
  = Supply
  | Withdraw

type alias Payment =
  { id: Id
  , type': PaymentType
  , amount: Float
  , description: String
  , date: String
  }

type alias Id = Int

type alias Model =
  { payments: List Payment
  , newPayment: Payment
  }

type Action
  = NoOp
  | AddPayment
  | RemovePayment Id
  | UpdateDate String
