module Update exposing (update)

import Msg exposing (Msg(..))

update msg model =
    case msg of
    ChangeRootNote note -> { model | root = note}
    ChangeScale scale -> { model | scale = scale}