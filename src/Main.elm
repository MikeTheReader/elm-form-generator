module Main exposing (..)

import Html exposing (program)
import Models exposing (Model, init)
import Messages exposing (Msg)
import Views exposing (view)
import Update exposing (update)
import Subscriptions exposing (subscriptions)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
