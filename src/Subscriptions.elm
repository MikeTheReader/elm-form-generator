module Subscriptions exposing (..)

import Models exposing (Model)
import Messages exposing (Msg)
import Update exposing (portCount)


subscriptions : Model -> Sub Msg
subscriptions model =
    portCount Messages.PortCount
