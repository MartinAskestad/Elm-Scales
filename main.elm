module Main exposing (main)

import Msg exposing (Msg(..))
import Update exposing (update)
import View exposing(view)

import Html exposing (beginnerProgram)

model = { root = "C", scale = "Major" }

main =
    beginnerProgram { model = model, update = update, view = view }