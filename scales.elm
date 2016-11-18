module Scales exposing (getScaleNotes, chromatic, scales)

import List exposing (scanl, length)
import Dict exposing (fromList, keys)

-- Main Program
--type Note = A | A_ | B | C | C_ | D | D_ | E | F | F_ | G | G_ | X

chromatic = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]

get xs idx = List.head <| List.drop idx xs

indexOf el list =
    let
      indexOf_ list_ index =
        case list_ of
                [] -> 1
                (x::xs) ->
                    if x == el then index
                    else indexOf_ xs (index +1)
    in
        indexOf_ list 0

up halfSteps n =
    let
      --chromatic = [A, A_, B, C, C_, D, D_, E, F, F_, G, G_]
      idx = chromatic
            |> indexOf n
      i = idx + halfSteps
    in
        case get chromatic (i % length chromatic) of
         Just val -> val
         Nothing -> ""

getScale root =
    scanl (\f n -> f n) root

getScaleNotes root scaleName =
    let
      scale = Dict.get scaleName scaleFormulas
    in
      case scale of
      Just value -> getScale root value
      Nothing -> []
half = up 1
whole = up 2
wholeHalf = up 3

-- Scale Formulas
scaleFormulas = fromList [("Major", [whole, whole, half, whole, whole, whole, half]),
                          ("Natural minor", [whole, half, whole, whole, half, whole, whole]),
                          ("Major pentatonic", [whole, whole, wholeHalf, whole, wholeHalf]),
                          ("Minor pentatonic", [wholeHalf, whole, whole, wholeHalf, whole]),
                          ("Blues", [wholeHalf, whole, half, half, wholeHalf, whole]),
                          ("Major blues", [whole, half, half, half, half, half, whole, half, whole]),
                          ("Minor blues", [whole, half, whole, half, half, half, whole, whole]),
                          ("Ionian mode", [whole, whole, half, whole, whole, whole, half]),
                          ("Dorian mode", [whole, half, whole, whole, whole, half, whole]),
                          ("Phrygian mode", [half, whole, whole, whole, half, whole, whole]), 
                          ("Lydian mode", [whole, whole, whole, half, whole, whole, half]),
                          ("Mixolydian mode", [whole, whole, half, whole, whole, half, whole]),
                          ("Aeolian mode", [whole, half, whole, whole, half, whole, whole]),
                          ("Locrian mode", [half, whole, whole, half, whole, whole, whole]),
                          ("Harmonic minor", [whole, half, whole, whole, half, wholeHalf, half]),
                          ("Jazz melodic minor", [whole, half, whole, whole, whole, whole, half]),
                          ("Chromatic", [half, half, half, half, half, half, half, half, half, half, half, half]),
                          ("Whole tone", [whole, whole, whole, whole, whole, whole, whole]),
                          ("Hungarian minor", [whole, half, wholeHalf, half, wholeHalf, half]),
                          ("Japanese", [half, wholeHalf, whole, half, whole, half])]
scales = keys scaleFormulas