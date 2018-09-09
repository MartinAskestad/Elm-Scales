module Main exposing (main)

import Browser
import Msg exposing (Msg(..))
import Update exposing (update)
import View exposing(view)

model = { root = "C", scale = "Major" }

main =
    Browser.sandbox { init = model, update = update, view = view }