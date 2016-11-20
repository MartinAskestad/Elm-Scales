module Main exposing (main)

import Scales exposing (getScaleNotes, chromatic, scales)
import Html exposing(..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Json.Decode as Json


-- Model
type alias Model = { root:String, scale:String }
model: Model
model = Model "C""Major"

type Msg =
      ChangeRootNote String
    | ChangeScale String

update : Msg -> Model -> Model
update msg model =
  case msg of
  ChangeRootNote note -> { model | root = note }
  ChangeScale scale -> { model |scale = scale }

view : Model -> Html.Html Msg
view model =
    let
        noteOption name = option [(if model.root == name then selected True else selected False)] [ text name ]
        scaleOption name = option [(if model.scale == name then selected True else selected False)] [ text name]
        onChange tagger = on "change" (Json.map tagger targetValue)
        prettyPrintNotes scale = List.map (\note -> li [] [text note]) scale
    in  
    Html.form [] [
        div [class "container"] [
            div [class "row"] [
                div [class "col-md-12"] [ h1 [] [text "Scales" ], p [] [text "This is a simple tool to show the notes that are included in a choose scale."] ]
            ],
            div [class "row"] [
                div [class "col-md-6"] [
                    div [class "form-group"] [
                        label [for "root"] [text "Choose root note" ],
                        select [id "root", class "form-control", onChange ChangeRootNote] 
                        (List.map noteOption chromatic)
                        
                    ]
                ],
                div [class "col-md-6"] [
                    div [class "form-group"] [
                        label [for "scale"] [text "Choose a scale"],
                        select [id "scale", class "form-control", onChange ChangeScale]
                        (List.map scaleOption scales)
                    ]
                ]
            ],
            div [class "row"] [
                div [class "col-md-12"] [
                    span [] [text <| "The notes in the scale " ++ model.root ++ " " ++ model.scale ++ " is:"],
                    ul [] (prettyPrintNotes (getScaleNotes model.root model.scale))
                ]
            ]
        ]
    ]

main: Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }