module Card.Update exposing (..)

import Card.Messages as Messages exposing (..)
import Mdl.Card.Update as Card
import Card.Models as Models exposing (..)

update : Message header image footer->
         Model->
         (Model, Cmd (Message header image footer))
update msg model =
  let
    updater = Card.updater NoOutMsg
            |> Card.contentToOut contentToOut
               
    (_,cmd,outMsg) = case msg of
                       Card m -> Card.update m model updater
                                 
    _=Debug.log "outMsg" outMsg
  in
    model ! []

contentToOut : ContentMessage->Model->MessageOut
contentToOut msg model =
  case msg of
    ContentClick str-> OutContentClick str
