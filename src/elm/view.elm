module View exposing (view)

import Html exposing (form, div, h1, label, li, option, p, select, span, text, ul, fieldset)
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
    div [class "container"] [
        h1 [] [text "Scales"],
        p [] [ text "This is a simple tool that shows the notes included in a choosen scale."],
        form [ class "pure-form pure-form-aligned" ] [
            fieldset [] [
                div [class "pure-control-group"] [
                    label [for "root"] [text "Choose root note"],
                    select [id "root",  onChange ChangeRootNote]
                    (map noteToString chromatic |> map noteOption)
                ],
                div [class "pure-control-group"] [
                    label [for "scale"] [text "Choose a scale"],
                    select [id "scale", onChange ChangeScale]
                    (map scaleOption scales)
                ],
                span [] [ text <| "The notes in the " ++ model.root ++ " " ++ model.scale ++ " scale are:"],
                ul [] (prettyPrintNotes (getScaleNotes model.root model.scale))
                
            ]
        ]
    ]