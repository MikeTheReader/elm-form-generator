module Models exposing (..)

import Messages exposing (Msg, Msg(FetchFields))
import Fields.Models exposing (Field, FieldType, FieldType(TextField, NumberField, BooleanField, DateField))
import Http exposing (get)
import Json.Decode exposing (int, string, bool, list, Decoder, succeed, map, nullable)
import Json.Decode.Pipeline exposing (required, decode, hardcoded, optional, custom)


type alias Model =
    { fields : List Field
    , activeFieldId : Maybe Int
    }


init : ( Model, Cmd Msg )
init =
    initModel


initModel : ( Model, Cmd Msg )
initModel =
    ( Model [] Nothing, initFields )


initFields : Cmd Msg
initFields =
    let
        url =
            "//puffin.corvallis.consbio.org:8000/fields/fields"
    in
        Http.send FetchFields (Http.get url decodeFields)


decodeFields : Decoder (List Field)
decodeFields =
    list decodeSingleField


decodeSingleField : Decoder Field
decodeSingleField =
    decode Field
        |> required "id" int
        |> required "label" string
        |> required "name" string
        |> required "description" string
        |> required "instructions" (nullable string)
        |> required "type" (map calcFieldType string)
        |> required "allow_additional_options" bool
        |> required "default_value" (nullable string)
        |> required "read_only" bool
        |> required "required" bool
        |> required "min" (nullable string)
        |> required "max" (nullable string)


decodeType : String -> Decoder FieldType
decodeType typeString =
    succeed (calcFieldType typeString)


calcFieldType : String -> FieldType
calcFieldType typeString =
    case typeString of
        "text" ->
            TextField

        "number" ->
            NumberField

        "date" ->
            DateField

        "boolean" ->
            BooleanField

        -- Shouldn't happen, but just in case
        _ ->
            TextField


dummyFields : List Field
dummyFields =
    [ { id = 1
      , label = "Text Field"
      , name = "text_field"
      , description = "Field One Description"
      , instructions = Just "Field One Description"
      , type_ = TextField
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
      , instructions = Just "Field Two Description"
      , type_ = NumberField
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
      , instructions = Just "Field Three Description"
      , type_ = DateField
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
      , instructions = Just "Field Four Description"
      , type_ = BooleanField
      , allowAdditionalOptions = True
      , defaultValue = Nothing
      , readOnly = False
      , required = True
      , min = Nothing
      , max = Nothing
      }
    ]
