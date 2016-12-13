module Card.Main exposing (..)

import Card.View as View
import Card.Update as Update
import Card.Models as Models exposing (Model)
import Card.Messages exposing (Message)
import Card.Subscriptions as Subscriptions 

import Html

init : (Model, Cmd (Message header image content footer))
init =
  (Models.initialModel, Cmd.none)
    
main =  
  Html.program
    { init = init
    , update = Update.update
    , view = View.view
    , subscriptions = Subscriptions.subscriptions
    }  

