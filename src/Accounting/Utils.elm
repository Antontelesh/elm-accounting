module Accounting.Utils (..) where

import Accounting.Interfaces exposing (..)

totalAmount : List Payment -> Float
totalAmount = List.sum << List.map .amount

totalIncome : List Payment -> Float
totalIncome = totalAmount << List.filter isSupply

totalOutcome : List Payment -> Float
totalOutcome = totalAmount << List.filter isWithdraw

balance : List Payment -> Float
balance payments =
  totalIncome payments - totalOutcome payments

isSupply : Payment -> Bool
isSupply = (==) Supply << .type'

isWithdraw : Payment -> Bool
isWithdraw = (==) Withdraw << .type'
