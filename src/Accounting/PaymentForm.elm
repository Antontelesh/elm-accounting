module Accounting.PaymentForm (view) where

import Html exposing (form, div, label, input, text)
import Html.Attributes exposing (class)
import Html.Events exposing (on, onWithOptions, onSubmit, targetValue)
import Json.Decode

import Accounting.Interfaces exposing (..)


onSubmit addr msg =
  onWithOptions "submit" {preventDefault = True, stopPropagation = True} Json.Decode.value (\_ -> Signal.message addr msg)


view : Signal.Address Action -> Model -> Html.Html
view address model =
  form
    [ onSubmit address AddPayment ]
    [ div
        [ class "control-group" ]
        [ label [] [ text "Payment Date"]
        , input
            [ on "input" targetValue (\str -> Signal.message address (UpdateDate str)) ]
            []
        ]
    ]
