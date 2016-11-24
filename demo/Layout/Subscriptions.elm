module Layout.Subscriptions exposing (..)

import Layout.Messages exposing (Message(..))
import Layout.Models exposing (Model)

import Mdl.Layout.Subscriptions as Layout

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.map Layout ( Layout.subscriber
                 |> Layout.subscriptions model.layout
                 )
