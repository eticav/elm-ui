module Layout.Main exposing (..)

import Layout.View as View
import Layout.Update as Update
import Layout.Models exposing (Model)
import Layout.Messages exposing (Message)
import Layout.Subscriptions as Subscriptions
import Html

init : (Model, Cmd Message)
init =
  (Layout.Models.initialModel, Cmd.none)
    
main =  
  Html.program
    { init = init
    , update = Update.update
    , view = View.view
    , subscriptions = Subscriptions.subscriptions
    }  
