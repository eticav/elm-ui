module Card.Subscriptions exposing (..)

import Card.Messages exposing (Message(..))
import Card.Models exposing (Model)

subscriptions : Model -> Sub (Message header image footer)
subscriptions model =
  Sub.none
