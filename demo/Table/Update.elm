module Table.Update exposing (..)

import Table.Messages exposing (..)
import Table.Models exposing (..)
import Mdl.Table.Update as Table
import Html

update : Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of
    Table tableMsg->
      let
        (updatedTable, cmd)= Table.update tableMsg model.table
      in
        ({model|table = updatedTable}, (Cmd.map Table cmd))
