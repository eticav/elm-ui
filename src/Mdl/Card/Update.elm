module Mdl.Card.Update exposing (..)

import Mdl.Card.Models exposing (Model)
import Mdl.Card.Messages exposing (Message(..))

type alias Update header image content footer model outMsg =
  { headerToOut : Maybe (header->model->outMsg)
  , imageToOut : Maybe (image->model->outMsg)
  , contentToOut : Maybe (content->model->outMsg)
  , footerToOut : Maybe (footer->model->outMsg)
  , defaultOutMsg : outMsg
  }

updater : outMsg->Update header image content footer model outMsg
updater defaultOutMsg = { headerToOut = Nothing
                        , imageToOut = Nothing
                        , contentToOut = Nothing
                        , footerToOut = Nothing
                        , defaultOutMsg = defaultOutMsg
                        }

headerToOut : (header->model->outMsg)->
              Update header image content footer model outMsg->
              Update header image content footer model outMsg
headerToOut f updater =
  {updater|headerToOut=Just f}

imageToOut : (image->model->outMsg)->
              Update header image content footer model outMsg->
              Update header image content footer model outMsg
imageToOut f updater =
  {updater|imageToOut=Just f}

contentToOut : (content->model->outMsg)->
              Update header image content footer model outMsg->
              Update header image content footer model outMsg
contentToOut f updater =
  {updater|contentToOut=Just f}

footerToOut : (footer->model->outMsg)->
              Update header image content footer model outMsg->
              Update header image content footer model outMsg
footerToOut f updater =
  {updater|footerToOut=Just f}
              
apply : outMsg->
        model->
        msg->                
        Maybe (msg->model->outMsg)->        
        outMsg
apply default model msg mfun =
  Maybe.map (\f->f msg model) mfun
    |> Maybe.withDefault default
  
update : Message header image content footer->
         model->
         Update header image content footer model outMsg->
         (model, Cmd (Message Message header image content footer), outMsg)
update msg model updater =
  let
    applyOut = apply updater.defaultOutMsg model 
  in
    case msg of
      Header m->
        (model, Cmd.none, applyOut m updater.headerToOut)
      Image m->
        (model, Cmd.none, applyOut m updater.imageToOut)
      Content m->
        (model, Cmd.none, applyOut m updater.contentToOut)
      Footer m->
        (model, Cmd.none, applyOut m updater.footerToOut)  
