module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (Model)
import Messages exposing (..)
import Fields.Views exposing (fieldView)
import Fields.Models exposing (..)
import Regex exposing (..)
import Json.Decode
import String exposing (toLower)


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ h2 [] [ text "Elm Form Creator" ]
        , div [ class "col-md-4" ]
            [ div [ class "panel panel-success" ]
                [ div [ class "panel-heading" ] [ text "Sample Form" ]
                , div [ class "panel-body" ]
                    [ div [] (List.map (fieldView model.activeFieldId) model.fields)
                    , div []
                        [ button
                            [ class "btn btn-primary pull-right add-new-field-button"
                            , onClick AddNewField
                            ]
                            [ text "Add New Field" ]
                        ]
                    ]
                ]
            ]
        , div [ class "col-md-4" ]
            [ div [ class "panel panel-info" ]
                [ div [ class "panel-heading" ] [ text "Selected Field" ]
                , div [ class "panel-body" ]
                    [ fieldForm model ]
                ]
            ]
        , div [ class "col-md-4" ]
            [ div [ class "panel panel-info" ]
                [ div [ class "panel-heading" ] [ text "Application state" ]
                , div [ class "panel-body" ]
                    [ pre [] [ text (jsonPretty (toString model)) ] ]
                ]
            ]
        ]


jsonPretty : String -> String
jsonPretty text =
    text
        |> replace All (regex "[,]") (\_ -> ",\n")
        |> replace All (regex "[\\[]") (\_ -> "[\n")
        |> replace All (regex "[\\]]") (\_ -> "]\n")


fieldForm : Model -> Html Msg
fieldForm model =
    case model.activeFieldId of
        Nothing ->
            div [] [ text "No field selected. Please select a field to edit, or click \"Add New Field\"." ]

        Just activeFieldId ->
            -- TODO: Not sure I like how I have to do the Maybe in the case here. Seems like there should be an easier way.
            let
                activeFields =
                    List.filter (\field -> field.id == activeFieldId) model.fields
            in
                case List.head activeFields of
                    Nothing ->
                        div [] [ text "No field selected. Please select a field to edit, or click \"Add New Field\"." ]

                    Just activeField ->
                        activeFieldForm activeField


typeOption : FieldType -> Html Msg
typeOption type' =
    case type' of
        TextField ->
            option [ value "text" ] [ text "Text" ]

        NumberField ->
            option [ value "number" ] [ text "Number" ]

        DateField ->
            option [ value "date" ] [ text "Date" ]

        BooleanField ->
            option [ value "boolean" ] [ text "True/False" ]


typeToValue : FieldType -> String
typeToValue type' =
    case type' of
        TextField ->
            "text"

        NumberField ->
            "number"

        DateField ->
            "date"

        BooleanField ->
            "boolean"


machineName : String -> String
machineName label =
    replace All (regex "[\\W]") (\_ -> "_") (toLower label)


activeFieldForm : Field -> Html Msg
activeFieldForm field =
    Html.form []
        [ div [ class "form-group" ]
            [ input [ class "form-control", type' "hidden", name "id", value (toString field.id) ] []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Label" ]
            , input
                [ class "form-control"
                , type' "text"
                , name "label"
                , value field.label
                , onInput (UpdateField (\f v -> { f | label = v, name = (machineName v) }) field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Machine Readable Name" ]
            , input
                [ class "form-control"
                , type' "text"
                , name "name"
                , value field.name
                , readonly True
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Description" ]
            , input
                [ class "form-control"
                , type' "text"
                , name "description"
                , value field.description
                , onInput (UpdateField (\f v -> { f | description = v }) field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Instructions" ]
            , input
                [ class "form-control"
                , type' "text"
                , name "instructions"
                , value field.instructions
                , onInput (UpdateField (\f v -> { f | instructions = v }) field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Required" ]
            , input
                [ class "form-control"
                , type' "checkbox"
                , name "required"
                , checked field.required
                , onClick (ToggleRequired field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Type" ]
            , select
                [ class "form-control"
                , name "type"
                , value (typeToValue field.type')
                , on "change" (Json.Decode.map (UpdateType field) targetValueTypeDecoder)
                ]
                [ typeOption TextField
                , typeOption NumberField
                , typeOption DateField
                , typeOption BooleanField
                ]
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Default Value" ]
            , input
                [ class "form-control"
                , type' "text"
                , name "defaultValue"
                , value (Maybe.withDefault "" field.defaultValue)
                , onInput (UpdateField (\f v -> { f | defaultValue = Just v }) field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Read Only" ]
            , input
                [ class "form-control"
                , type' "checkbox"
                , name "readOnly"
                , checked field.readOnly
                , onClick (ToggleReadOnly field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Minimum Value" ]
            , input
                [ class "form-control"
                , type' "text"
                , name "min"
                , value (Maybe.withDefault "" field.min)
                , onInput (UpdateField (\f v -> { f | min = Just v }) field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ label [] [ text "Maximum Value" ]
            , input
                [ class "form-control"
                , type' "text"
                , name "max"
                , value (Maybe.withDefault "" field.max)
                , onInput (UpdateField (\f v -> { f | max = Just v }) field)
                ]
                []
            ]
        , div [ class "form-group" ]
            [ button [ class "btn btn-primary pull-right", onClick Cancel ] [ text "Cancel" ]
            , button [ class "btn btn-primary pull-right", style [ ( "margin-right", "10px" ) ] ] [ text "Save" ]
            ]
        ]


targetValueTypeDecoder : Json.Decode.Decoder FieldType
targetValueTypeDecoder =
    targetValue
        `Json.Decode.andThen`
            \val ->
                case val of
                    "text" ->
                        Json.Decode.succeed TextField

                    "number" ->
                        Json.Decode.succeed NumberField

                    "date" ->
                        Json.Decode.succeed DateField

                    "boolean" ->
                        Json.Decode.succeed BooleanField

                    _ ->
                        Json.Decode.fail ("Invalid Role: " ++ val)
