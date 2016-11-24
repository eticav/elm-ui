module Button.Main exposing (..)

import Button.View as View
import Button.Update as Update
import Button.Models as Models exposing (Model)
import Button.Messages exposing (Message)
import Button.Subscriptions as Subscriptions 

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
