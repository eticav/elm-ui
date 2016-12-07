module SplittedPanes.Subscriptions exposing (..)

import SplittedPanes.Messages exposing (Message(..))
import SplittedPanes.Models exposing (Model)

import Mdl.SplittedPanes.Subscriptions as SplittedPanes

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.map SplittedPanes ( SplittedPanes.subscriber
                 |> SplittedPanes.subscriptions model.splittedPanes
                 )


