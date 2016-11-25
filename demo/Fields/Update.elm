module Fields.Update exposing (..)

import Fields.Messages as Messages exposing (..)
import Fields.Models as Models exposing (..)
import Mdl.TextField.TextField as TextField exposing (..)
import Helpers.Components exposing (..)

update : Messages.Message -> Models.Model -> (Models.Model, Cmd Messages.Message)
update msg model =
  case msg of
    TextField msg ->
      TextField.update msg model.textField
        |> mapComponent (\x->{model|textField=x})
        |> mapCmd Messages.TextField
        |> evaluate interpretTextFieldOut

           
interpretTextFieldOut : TextField.OutMessage->Models.Model->(Models.Model, Cmd Messages.Message)
interpretTextFieldOut outMsg model = 
  (model, Cmd.none)
