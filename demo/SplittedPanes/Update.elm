module SplittedPanes.Update exposing (..)

import SplittedPanes.Messages exposing (..)
import SplittedPanes.Models exposing (..)
import Mdl.SplittedPanes.Update as SplittedPanes
import Html


updatePrimary : PrimaryMessage -> PrimaryModel -> (PrimaryModel, Cmd PrimaryMessage)
updatePrimary msg model =
  (model, Cmd.none)

updateSecondary : SecondaryMessage -> SecondaryModel -> (SecondaryModel, Cmd SecondaryMessage)
updateSecondary msg model =
  (model, Cmd.none)

update : Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of
    SplittedPanes spMsg->
      let
        (updatedSplittedPanes, cmd)= SplittedPanes.updater  updatePrimary updateSecondary
                                   |> SplittedPanes.update spMsg model.splittedPanes
      in
        ({model|splittedPanes = updatedSplittedPanes}, (Cmd.map SplittedPanes cmd))


