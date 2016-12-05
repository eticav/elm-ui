module Table.Main exposing (..)

import Table.View as View
import Table.Update as Update
import Table.Models as Models exposing (Model)
import Table.Messages exposing (Message)
import Table.Subscriptions as Subscriptions 

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
