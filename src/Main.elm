module App (main) where

import StartApp
import Accounting exposing (view, update, init)

app = StartApp.start
  { init = init
  , update = update
  , view = view
  , inputs = []
  }

main = app.html
