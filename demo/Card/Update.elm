module Card.Update exposing (..)

import Card.Messages as Messages exposing (..)
import Card.Models as Models exposing (..)

update : Message header image content footer->
         Model->
         (Model, Cmd (Message header image content footer))
update msg model =
  model ! []
