module Button.Update exposing (..)

import Button.Messages as Messages exposing (..)
import Button.Models as Models exposing (..)

update : Message -> Model -> (Model, Cmd Message)
update msg model =
  model ! []
