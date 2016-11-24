module Fields.Main exposing (..)

import Fields.View as View
import Fields.Update as Update
import Fields.Models as Models exposing (Model)
import Fields.Messages exposing (Message)
import Html

init : (Model, Cmd Message)
init =
  (Models.initialModel, Cmd.none)
    
main =  
  Html.program
    { init = init
    , update = Update.update
    , view = View.view
    , subscriptions = \x->Sub.none
    }  
