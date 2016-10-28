module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import String exposing (isEmpty)


-- model


type alias Model =
    Int


initModel : Model
initModel =
    0



-- update


type Msg
    = Test


update : Msg -> Model -> Model
update msg model =
    case msg of
        _ ->
            model



-- view


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ h2 [] [ text "Form Creator" ]
        , div [ class "col-md-4" ]
            [ div [ class "panel panel-success" ]
                [ div [ class "panel-heading" ] [ text "Sample Form" ]
                , div [ class "panel-body" ]
                    [ div [] [] ]
                ]
            ]
        , div [ class "col-md-4" ]
            [ div [ class "panel panel-info" ]
                [ div [ class "panel-heading" ] [ text "Selected Field" ]
                , div [ class "panel-body" ]
                    [ div [] [] ]
                ]
            ]
        ]


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
