module Models exposing (..)

import Messages exposing (Msg)
import Fields.Models exposing (Field, FieldType(TextField, NumberField, BooleanField, DateField))


type alias Model =
    { fields : List Field
    , activeFieldId : Maybe Int
    }


initModel : Model
initModel =
    Model initFields Nothing


initFields : List Field
initFields =
    [ { id = 1
      , label = "Text Field"
      , name = "text_field"
      , description = "Field One Description"
      , instructions = "Field One Description"
      , type' = TextField
      , allowAdditionalOptions = True
      , defaultValue = Nothing
      , readOnly = False
      , required = True
      , min = Nothing
      , max = Nothing
      }
    , { id = 2
      , label = "Number Field"
      , name = "number_field"
      , description = "Field Two Description"
      , instructions = "Field Two Description"
      , type' = NumberField
      , allowAdditionalOptions = True
      , defaultValue = Nothing
      , readOnly = False
      , required = True
      , min = Nothing
      , max = Nothing
      }
    , { id = 3
      , label = "Date Field"
      , name = "date_field"
      , description = "Field Three Description"
      , instructions = "Field Three Description"
      , type' = DateField
      , allowAdditionalOptions = True
      , defaultValue = Nothing
      , readOnly = False
      , required = True
      , min = Nothing
      , max = Nothing
      }
    , { id = 4
      , label = "Boolean Field"
      , name = "boolean_field"
      , description = "Field Four Description"
      , instructions = "Field Four Description"
      , type' = BooleanField
      , allowAdditionalOptions = True
      , defaultValue = Nothing
      , readOnly = False
      , required = True
      , min = Nothing
      , max = Nothing
      }
    ]


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )
