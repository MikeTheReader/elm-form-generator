module Messages exposing (..)

import Fields.Models exposing (Field, FieldType)


type Msg
    = SelectField Int
    | AddNewField
    | DeleteField Field
    | SaveField
    | Cancel
    | UpdateField (Field -> String -> Field) Field String
    | UpdateType Field FieldType
    | ToggleRequired Field
    | ToggleReadOnly Field
