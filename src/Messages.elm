module Messages exposing (..)

import Fields.Models exposing (Field, FieldType)
import Http exposing (Error)


type Msg
    = SelectField Int
    | AddNewField
    | DeleteField Field
    | SaveField
    | Cancel
    | UpdateField (Field -> String -> Field) Field String
    | UpdateType Field FieldType
    | FetchFieldsFail Http.Error
    | FetchFieldsSucceed (List Field)
