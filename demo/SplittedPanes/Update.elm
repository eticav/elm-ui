module SplittedPanes.Update exposing (..)

import SplittedPanes.Messages exposing (..)
import SplittedPanes.Models exposing (..)
import Mdl.SplittedPanes.Update as SplittedPanes
import Html

type OutMsg = OutNothing
type OutMsgPrimary = OutNothingPrimary
type OutMsgSecondary = OutNothingSecondary
                     
                      
updatePrimary : PrimaryMessage->PrimaryModel->(PrimaryModel,Cmd PrimaryMessage,OutMsgPrimary)
updatePrimary msg model =
  (model, Cmd.none, OutNothingPrimary)

updateSecondary : SecondaryMessage->SecondaryModel->(SecondaryModel,Cmd SecondaryMessage,OutMsgSecondary)
updateSecondary msg model =
  (model, Cmd.none, OutNothingSecondary)

update : Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of
    SplittedPanes spMsg->
      let
        (updatedSplittedPanes, cmd, outMsg)= SplittedPanes.updater  updatePrimary updateSecondary (\x y->OutNothing)
                                           |> SplittedPanes.update spMsg model.splittedPanes
      in
        ({model|splittedPanes = updatedSplittedPanes}, (Cmd.map SplittedPanes cmd))
