module List.Subscriptions exposing (..)

import List.Messages exposing (Message(..))
import List.Models exposing (Model)

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none
