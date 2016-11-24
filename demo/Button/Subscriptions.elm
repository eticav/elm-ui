module Button.Subscriptions exposing (..)

import Button.Messages exposing (Message(..))
import Button.Models exposing (Model)

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none
