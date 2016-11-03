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


type FieldProperty
    = Label String
    | Description String
    | Instructions String
    | Type FieldType
    | AllowAdditionalOptions Bool
    | DefaultValue (Maybe String)
    | ReadOnly Bool
    | Required Bool
    | Min (Maybe String)
    | Max (Maybe String)
