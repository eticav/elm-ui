module SplittedPanes.Main exposing (..)

import SplittedPanes.View as View
import SplittedPanes.Update as Update
import SplittedPanes.Models as Models exposing (Model)
import SplittedPanes.Messages exposing (Message)
--import SplittedPanes.Subscriptions as Subscriptions 

import Html

init : (Model, Cmd Message)
init =
  (Models.initialModel, Cmd.none)
    
main =  
  Html.program
    { init = init
    , update = Update.update
    , view = View.view
    , subscriptions = (\x->Sub.none)--Subscriptions.subscriptions
    }  


