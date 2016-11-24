module Table.Subscriptions exposing (..)

import Table.Messages exposing (Message(..))
import Table.Models exposing (Model)

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none
