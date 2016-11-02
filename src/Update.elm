port module Update exposing (..)

import Models exposing (Model, dummyFields)
import Messages exposing (Msg)
import Fields.Models exposing (Field, FieldType(TextField))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Messages.AddNewField ->
            let
                addedField =
                    newField model
            in
                ( { model | fields = (model.fields ++ [ addedField ]), activeFieldId = Just addedField.id }, Cmd.none )

        Messages.SelectField fieldId ->
            ( { model | activeFieldId = Just fieldId }, Cmd.none )

        Messages.Cancel ->
            ( { model | activeFieldId = Nothing }, Cmd.none )

        Messages.UpdateField updateOperation changedField value ->
            ( { model
                | fields =
                    List.map
                        (\field ->
                            if field.id == changedField.id then
                                updateOperation field value
                            else
                                field
                        )
                        model.fields
              }
            , Cmd.none
            )

        Messages.UpdateType changedField fieldType ->
            ( { model
                | fields =
                    List.map
                        (\field ->
                            if field.id == changedField.id then
                                { field
                                    | type' = fieldType
                                }
                            else
                                field
                        )
                        model.fields
              }
            , Cmd.none
            )

        Messages.DeleteField field ->
            ( { model
                | fields = List.filter (\f -> f.id /= field.id) model.fields
              }
            , Cmd.none
            )

        Messages.FetchFieldsSucceed fieldList ->
            ( { model
                | fields = fieldList
              }
            , Cmd.none
            )

        Messages.FetchFieldsFail error ->
            Debug.log ((toString error) ++ " Using Dummy Fields")
                ( { model | fields = dummyFields }, Cmd.none )

        Messages.PortCheck ->
            ( model, portCheck "testing 1 2 3" )

        Messages.PortCount num ->
            Debug.log ("Got a count back into Elm: " ++ (toString num))
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


newField : Model -> Fields.Models.Field
newField model =
    { id = List.length model.fields + 1
    , label = "< New Field >"
    , name = "__new_field__"
    , description = "Add Description"
    , instructions = "Add Instructions"
    , type' = Fields.Models.TextField
    , allowAdditionalOptions = True
    , defaultValue = Nothing
    , readOnly = False
    , required = True
    , min = Nothing
    , max = Nothing
    }



-- These are experiments with ports


port portCheck : String -> Cmd msg


port portCount : (Int -> msg) -> Sub msg
