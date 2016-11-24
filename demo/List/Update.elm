module List.Update exposing (..)

import List.Messages as Messages exposing (..)
import List.Models as Models exposing (..)

update : Message -> Model -> (Model, Cmd Message)
update msg model =
  model ! []
