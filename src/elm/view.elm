module View exposing (view)

import Html exposing (form, div, h1, label, li, option, p, select, span, text, ul)
import Html.Attributes exposing (class, for, id, selected)
import Html.Events exposing (on, targetValue)
import List exposing (map)
import Json.Decode as Json

import Msg exposing(Msg(..))
import Scales exposing(chromatic, getScaleNotes, scales, noteToString)


view : { a | root : String, scale : String } -> Html.Html Msg
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
    form [ class "pure-form pure-form-stacked" ] [
        div [ class "container" ] [
            div [ class "pure-g"] [
                div [class "pure-u-1" ] [
                    h1 [] [text "Scales"],
                    p [] [ text "This is a simple tool to show the notes that are included in a choose scale." ]
                ]
            ],
            div [ class "pure-g" ] [
                div [ class "pure-u-1 pure-u-md-1-2 pure-u-lg-1-5" ] [
                    div [ class "pure-group" ] [
                        label [ for "root" ] [ text "Choose root note" ],
                        select [ id "root", class "pure-input-1", onChange ChangeRootNote ]
                        (map noteToString chromatic |> map noteOption )
                    ]
                ],
                div [ class "pure-u-1 pure-u-md-1-2 pure-u-lg-1-5" ] [
                    div [ class "pure-group" ] [
                        label [ for "scale" ] [ text "Choose a scale" ],
                        select [ id "scale", class "pure-input-1", onChange ChangeScale ]
                        (map scaleOption scales)
                    ]
                ]
            ],
            div [ class "pure-g" ] [
                div [ class "pure-u-1-1" ] [
                    span [] [ text <| "The notes in the " ++ model.root ++ " " ++ model.scale ++ " scale is:" ],
                    ul [] (prettyPrintNotes (getScaleNotes model.root model.scale))
                ]
            ]
        ]
    ]