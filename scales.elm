module Scales exposing (getScaleNotes, chromatic, scales)

import List exposing (scanl, length, drop, head)
import Dict exposing (Dict, fromList, keys)
import Maybe exposing (withDefault)

chromatic: List String
chromatic = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]

get: List String -> Int -> String
get xs idx = 
    let
        item = head <| drop idx xs
    in
        withDefault "" item

findIndex: (a -> Bool) -> List a -> Int
findIndex f list =
    let
      findIndex_ list_ index =
        case list_ of
            [] -> 1
            (x::xs) ->
                if f x == True then index
                else findIndex_ xs (index + 1)
    in
      findIndex_ list 0

up: Int -> String -> String
up halfSteps n =
    let
      idx = chromatic
            |> findIndex (\n_ -> n_ == n)
      i = idx + halfSteps
    in
        get chromatic (i % length chromatic)

getScale: a -> List (a -> a) -> List a
getScale root =
    scanl (\f n -> f n) root

getScaleNotes: String -> String -> List String
getScaleNotes root scaleName =
    let
      scale = Dict.get scaleName scaleFormulas
    in
      case scale of
      Just value -> getScale root value
      Nothing -> []

half: String -> String
half = up 1

whole: String -> String
whole = up 2

wholeHalf: String -> String
wholeHalf = up 3

-- Scale Formulas
scaleFormulas: Dict String (List (String -> String))
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
scales: List String
scales = keys scaleFormulas