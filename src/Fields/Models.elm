module Fields.Models exposing (..)


type FieldType
    = TextField
    | NumberField
    | DateField
    | BooleanField


type alias Field =
    { id : Int
    , label : String
    , name : String
    , description : String
    , instructions : String
    , type' : FieldType
    , allowAdditionalOptions : Bool
    , defaultValue : Maybe String
    , readOnly : Bool
    , required : Bool
    , min : Maybe String
    , max : Maybe String
    }
