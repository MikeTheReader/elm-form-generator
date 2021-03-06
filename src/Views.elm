module Views exposing (..)

import Fields.Models exposing (..)
import Fields.Views exposing (fieldView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Messages exposing (..)
import Models exposing (Model)
import Regex exposing (..)


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
                    [ pre [] [ text (jsonPsuedoPretty (toString model)) ] ]
                ]
            ]
        ]


jsonPsuedoPretty : String -> String
jsonPsuedoPretty text =
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
typeOption type_ =
    case type_ of
        TextField ->
            option [ value "text" ] [ text "Text" ]

        NumberField ->
            option [ value "number" ] [ text "Number" ]

        DateField ->
            option [ value "date" ] [ text "Date" ]

        BooleanField ->
            option [ value "boolean" ] [ text "True/False" ]


typeToValue : FieldType -> String
typeToValue type_ =
    case type_ of
        TextField ->
            "text"

        NumberField ->
            "number"

        DateField ->
            "date"

        BooleanField ->
            "boolean"


activeFieldForm : Field -> Html Msg
activeFieldForm field =
    div []
        [ Html.form []
            [ div [ class "form-group" ]
                [ input [ class "form-control", type_ "hidden", name "id", value (toString field.id) ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Label" ]
                , input
                    [ class "form-control"
                    , type_ "text"
                    , name "label"
                    , value field.label
                    , onInput (UpdateField field << Label)
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Machine Readable Name" ]
                , input
                    [ class "form-control"
                    , type_ "text"
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
                    , type_ "text"
                    , name "description"
                    , value field.description
                    , onInput (UpdateField field << Description)
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Instructions" ]
                , input
                    [ class "form-control"
                    , type_ "text"
                    , name "instructions"
                    , value (Maybe.withDefault "" field.instructions)
                    , onInput (UpdateField field << Instructions)
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Required" ]
                , input
                    [ class "form-control"
                    , type_ "checkbox"
                    , name "required"
                    , checked field.required
                    , onClick (UpdateField field (Required (not field.required)))
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Type" ]
                , select
                    [ class "form-control"
                    , name "type"
                    , value (typeToValue field.type_)
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
                    , type_ "text"
                    , name "defaultValue"
                    , value (Maybe.withDefault "" field.defaultValue)
                    , onInput (UpdateField field << DefaultValue << Just)
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Read Only" ]
                , input
                    [ class "form-control"
                    , type_ "checkbox"
                    , name "readOnly"
                    , checked field.readOnly
                    , onClick (UpdateField field (ReadOnly (not field.readOnly)))
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Minimum Value" ]
                , input
                    [ class "form-control"
                    , type_ "text"
                    , name "min"
                    , value (Maybe.withDefault "" field.min)
                    , onInput (UpdateField field << Min << Just)
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Maximum Value" ]
                , input
                    [ class "form-control"
                    , type_ "text"
                    , name "max"
                    , value (Maybe.withDefault "" field.max)
                    , onInput (UpdateField field << Max << Just)
                    ]
                    []
                ]
            ]
        , div [ class "form-group" ]
            [ button [ class "btn btn-primary pull-right", onClick Cancel ] [ text "Cancel" ]
            , button [ class "btn btn-primary pull-right", style [ ( "margin-right", "10px" ) ] ] [ text "Save" ]
            ]
        ]


targetValueTypeDecoder : Json.Decode.Decoder FieldType
targetValueTypeDecoder =
    targetValue
        |> Json.Decode.andThen
            (\val ->
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
            )
