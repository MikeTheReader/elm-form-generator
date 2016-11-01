module Main exposing (..)

import Html.App as App
import Models exposing (Model, init)
import Views exposing (view)
import Update exposing (update)
import Subscriptions exposing (subscriptions)


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
