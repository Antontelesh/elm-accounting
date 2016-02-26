module Accounting.Interfaces (..) where

type PaymentType
  = Supply
  | Withdraw

type alias PaymentData =
  { type': PaymentType
  , amount: Float
  , description: String
  , date: String
  }

type alias WithId a =
  { a | id: Id }

type alias Payment = WithId PaymentData

type alias Id = Int
