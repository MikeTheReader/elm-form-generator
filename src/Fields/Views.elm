module Fields.Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Fields.Models exposing (Field, FieldType(TextField, NumberField, DateField, BooleanField))
import Messages exposing (..)


fieldView : Maybe Int -> Field -> Html Msg
fieldView activeId field =
    let
        classNames =
            "field-container"
                ++ (if Maybe.withDefault -1 activeId == field.id then
                        " selected"
                    else
                        ""
                   )
    in
        div [ class classNames, onClick (SelectField field.id) ]
            [ button [ class "btn btn-xs btn-danger pull-right", onClick (DeleteField field) ] [ text "Delete" ]
            , fieldSubView field
            ]


fieldSubView : Field -> Html Msg
fieldSubView field =
    case field.type_ of
        TextField ->
            textFieldView field

        NumberField ->
            numberFieldView field

        DateField ->
            dateFieldView field

        BooleanField ->
            booleanFieldView field


textFieldView : Field -> Html Msg
textFieldView field =
    div [ class "form-group" ]
        [ label [] [ text field.label ]
        , div []
            [ input
                [ type_ "text"
                , class "form-control"
                , placeholder field.description
                , readonly field.readOnly
                , defaultValue (Maybe.withDefault "" field.defaultValue)
                ]
                []
            ]
        ]


numberFieldView : Field -> Html Msg
numberFieldView field =
    div [ class "form-group" ]
        [ label [] [ text field.label ]
        , div []
            [ input
                [ type_ "number"
                , class "form-control"
                , placeholder field.description
                , readonly field.readOnly
                , defaultValue (Maybe.withDefault "" field.defaultValue)
                , Html.Attributes.min (Maybe.withDefault "" field.min)
                , Html.Attributes.max (Maybe.withDefault "" field.max)
                ]
                []
            ]
        ]


dateFieldView : Field -> Html Msg
dateFieldView field =
    div [ class "form-group" ]
        [ label [] [ text field.label ]
        , div []
            [ input
                [ type_ "date"
                , class "form-control"
                , placeholder field.description
                , readonly field.readOnly
                , defaultValue (Maybe.withDefault "" field.defaultValue)
                , Html.Attributes.min (Maybe.withDefault "" field.min)
                , Html.Attributes.max (Maybe.withDefault "" field.max)
                ]
                []
            ]
        ]


booleanFieldView : Field -> Html Msg
booleanFieldView field =
    div [ class "form-group" ]
        [ label [] [ text field.label ]
        , div []
            [ input
                [ type_ "checkbox"
                , class "form-control"
                , placeholder field.description
                , readonly field.readOnly
                , defaultValue (Maybe.withDefault "" field.defaultValue)
                ]
                []
            ]
        ]
