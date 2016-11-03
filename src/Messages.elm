module Messages exposing (..)

import Fields.Models exposing (Field, FieldType, FieldProperty)
import Http exposing (Error)


type Msg
    = SelectField Int
    | AddNewField
    | DeleteField Field
    | SaveField
    | Cancel
    | UpdateField Field FieldProperty
    | UpdateType Field FieldType
    | FetchFieldsFail Http.Error
    | FetchFieldsSucceed (List Field)
    | PortCheck
    | PortCount Int
