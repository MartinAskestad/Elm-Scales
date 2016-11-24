module View exposing (view)

import Html exposing (form, div, h1, label, li, option, p, select, span, text, ul)
import Html.Attributes exposing (class, for, id, selected)
import Html.Events exposing (on, targetValue)
import List exposing (map)
import Json.Decode as Json

import Msg exposing(Msg(..))
import Scales exposing(chromatic, getScaleNotes, scales, noteToString)

view model =
    let
        foo = 0

        noteOption name = option [(if model.root == name then selected True else selected False)] [ text name ]
        scaleOption name = option [(if model.scale == name then selected True else selected False)] [ text name]
        onChange tagger = on "change" (Json.map tagger targetValue)
        prettyPrintNotes scale = map (\n -> case n of
                                            Just n -> li [] [ text (noteToString n)]
                                            Nothing -> li [] []) scale
    in  
    form [] [
        div [ class "container" ] [
            div [ class "row"] [
                div [class "col-md-12" ] [
                    h1 [] [text "Scales"],
                    p [] [ text "This is a simple tool to show the notes that are included in a choose scale." ]
                ]
            ],
            div [ class "row" ] [
                div [ class "col-md-6" ] [
                    div [ class "form-group" ] [
                        label [ for "root" ] [ text "Choose root note" ],
                        select [ id "root", class "form-control", onChange ChangeRootNote ]
                        (map noteToString chromatic |> map noteOption )
                    ]
                ],
                div [ class "col-md-6" ] [
                    div [ class "form-group" ] [
                        label [ for "scale" ] [ text "Choose a scale" ],
                        select [ id "scale", class "form-control", onChange ChangeScale ]
                        (map scaleOption scales)
                    ]
                ]
            ],
            div [ class "row" ] [
                div [ class "col-md-12" ] [
                    span [] [ text <| "The notes in the " ++ model.root ++ " " ++ model.scale ++ " scale is:" ],
                    ul [] (prettyPrintNotes (getScaleNotes model.root model.scale))
                ]
            ]
        ]
    ]