module Layout.Update exposing (..)

import Layout.Messages exposing (..)
import Layout.Models exposing (..)
import Fields.Update
import Fields.Messages as FieldsMessage
import Mdl.Layout.Update as Layout
import Mdl.Layout.Models as LayoutModel 

update : Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of
    Layout layoutMsg ->
      let
        (updatedLayout, cmd) = Layout.updater Fields.Update.update
                             |> Layout.drawerUpdate LayoutModel.noUpdate 
                             |> Layout.update layoutMsg model.layout
      in
        ({model|layout=updatedLayout}, Cmd.map Layout cmd)
