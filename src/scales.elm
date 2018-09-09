module Scales exposing (chromatic, getScaleNotes, noteToString, scales)

import Dict exposing (Dict, fromList, keys)
import List exposing (drop, foldl, head, length, reverse)
import Maybe exposing (withDefault)
import String exposing (replace, uncons)

type Note = A | A_ | B | C | C_ | D | D_ | E | F | F_ | G | G_

scanl f b xs =
  let
    scan1 x accAcc =
      case accAcc of
        acc :: _ ->
          f x acc :: accAcc
        [] ->
          [] -- impossible
  in
    reverse (foldl scan1 [b] xs)
    

fromString s =
    case uncons s of
    Just ('A', "")  -> Just A
    Just ('A', "#") -> Just A_
    Just ('B', "")  -> Just B
    Just ('C', "")  -> Just C
    Just ('C', "#") -> Just C_
    Just ('D', "")  -> Just D
    Just ('D', "#") -> Just D_
    Just ('E', "")  -> Just E
    Just ('F', "")  -> Just F
    Just ('F', "#") -> Just F_
    Just ('G', "")  -> Just G
    Just ('G', "#") -> Just G_
    _ -> Nothing

noteToString n =
    case n of
        A  -> "A"
        A_ -> "A#"
        B  -> "B"
        C  -> "C"
        C_ -> "C#"
        D  -> "D"
        D_ -> "D#"
        E  -> "E"
        F  -> "F"
        F_ -> "F#"
        G  -> "G"
        G_ -> "G#"

chromatic = [A, A_, B, C, C_, D, D_, E, F, F_, G , G_]

get xs idx = head <| drop idx xs

findIndex f list =
    let
      findIndex_ list_ idx =
        case list_ of
            [] -> 1
            (x::xs) -> if f x == True then idx
                       else findIndex_ xs (idx + 1)
    in
      findIndex_ list 0

up halfSteps n =
    let
        idx = chromatic |> findIndex (\n_ -> n_ == n)
    in
        get chromatic (modBy (length chromatic) (idx + halfSteps))

half = up 1

whole = up 2

wholeHalf = up 3

getScale root =
    let
        scanner = \f n -> case n of
                          Just n_ -> f n_
                          Nothing -> f A
    in
        scanl scanner root

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

getScaleNotes root scaleName =
    let scale = Dict.get scaleName scaleFormulas
    in
        case scale of
        Just value -> getScale (fromString root) value
        Nothing -> []