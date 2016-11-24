module List.Main exposing (..)

import List.View as View
import List.Update as Update
import List.Models as Models exposing (Model)
import List.Messages exposing (Message)
import List.Subscriptions as Subscriptions 
import Html

init : (Model, Cmd Message)
init =
  (Models.initialModel, Cmd.none)
    
main =  
  Html.program
    { init = init
    , update = Update.update
    , view = View.view
    , subscriptions = Subscriptions.subscriptions
    }  
