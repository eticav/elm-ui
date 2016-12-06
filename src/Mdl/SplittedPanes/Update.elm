module Mdl.SplittedPanes.Update exposing (..)

import Mdl.SplittedPanes.Models exposing (Model, Orientation(..))
import Mdl.SplittedPanes.Messages exposing (Message(..))

import MouseEvents

type alias Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg =
  { primaryUpdate : (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg))
  , secondaryUpdate : (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg))
  , primaryToBus : Maybe (primaryMsg->busMsg)
  , secondaryToBus : Maybe (secondaryMsg->busMsg)
  , busToPrimary : Maybe (busMsg->Maybe primaryMsg)
  , busToSecondary : Maybe (busMsg->Maybe secondaryMsg)
  }

updater : (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg))->
          (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg))->
          Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg
updater primaryUpdate secondaryUpdate = { primaryUpdate = primaryUpdate
                                        , secondaryUpdate = secondaryUpdate
                                        , primaryToBus = Nothing
                                        , secondaryToBus = Nothing
                                        , busToPrimary = Nothing
                                        , busToSecondary = Nothing
                                        }


primaryToBus : (primaryMsg->busMsg)->
               Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
               Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg
primaryToBus f updater = 
  {updater|primaryToBus=Just f}

secondaryToBus : (secondaryMsg->busMsg)->
                 Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
                   Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg
secondaryToBus f updater = 
  {updater|secondaryToBus=Just f}

busToPrimary : (busMsg->Maybe primaryMsg)->
                 Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
                 Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg
busToPrimary f updater = 
  {updater|busToPrimary=Just f}
  
busToSecondary : (busMsg->Maybe secondaryMsg)->
                 Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
                 Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg
busToSecondary f updater = 
  {updater|busToSecondary=Just f}
  
  
update : Message primaryMsg secondaryMsg->
         Model primaryModel secondaryModel->
         Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
         (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg))
update msg model updater =
    (updateFromMsg model updater msg)
      |> updateFromBus msg updater
  
updateFromMsg : Model primaryModel secondaryModel->
                Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
                Message primaryMsg secondaryMsg->
                (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg))
updateFromMsg model updater msg  =
    case msg of
      Primary primaryMsg ->
        let
          (updatePrimary,cmd) = updater.primaryUpdate primaryMsg model.primary
        in
          ({model|primary=updatePrimary}, Cmd.map Primary cmd)
      Secondary secondaryMsg ->
        let
          (updateSecondary,cmd) = updater.secondaryUpdate secondaryMsg model.secondary
        in
          ({model|secondary=updateSecondary}, Cmd.map Secondary cmd)
      MouseDown me->
        let
          splitter = model.splitter
          updatedSplitter = {splitter|resizing=True}
        in
          ({model|splitter = updatedSplitter}, Cmd.none)
      MouseUp me->
        let
          splitter = model.splitter
          updatedSplitter = {splitter|resizing=False}
        in
          ({model|splitter = updatedSplitter}, Cmd.none)
      Move me->
        let
          splitter = model.splitter
          primaryRatio unit pos = pos
          secondaryRatio unit pos parentSize = parentSize-pos
          updatedSplitter = case ((rem me.buttons 2)==1, splitter.resizing) of
                              (True,True)->
                                let
                                  (parentSize, pos) = case model.orientation of
                                                        Horizontal -> ( me.height
                                                                      , ((MouseEvents.relPos me).y)
                                                                      )
                                                        Vertical -> ( me.width
                                                                    , ((MouseEvents.relPos me).x)
                                                                    )
                                in
                                  {splitter|primaryRatio = primaryRatio 5 pos, secondaryRatio=secondaryRatio 5 pos parentSize}
                              (_,_)-> {splitter|resizing=False}
        in        
          ({model|splitter=updatedSplitter}, Cmd.none)

toBusMsg : Message primaryMsg secondaryMsg->
           Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
           Maybe busMsg
toBusMsg msg updater =
  case msg of
    Primary primaryMsg -> Maybe.map (\f-> f primaryMsg) updater.primaryToBus
    Secondary secondaryMsg -> Maybe.map (\f-> f secondaryMsg) updater.secondaryToBus
    _ -> Nothing
          
updateFromBus :Message primaryMsg secondaryMsg->
                Update primaryMsg primaryModel secondaryMsg secondaryModel busMsg->
                (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg))->
                (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg))
updateFromBus msg updater (model, cmd) =
  let             
    updateBus model busMsg =
      let        
        (primaryUpdatedModel, primaryCmd) = maybeApply updater.busToPrimary busMsg
                                            |> Maybe.map (\x->updateFromMsg model updater (Primary x))
                                            |> Maybe.withDefault (model, Cmd.none)

        (secondaryUpdatedModel, secondaryCmd) = maybeApply updater.busToSecondary busMsg
                                            |> Maybe.map (\x->updateFromMsg primaryUpdatedModel updater (Secondary x))
                                            |> Maybe.withDefault (primaryUpdatedModel, Cmd.none)
      in
        secondaryUpdatedModel ! [cmd, primaryCmd, secondaryCmd]
  in
    updateBus model (toBusMsg msg updater)      
             
maybeApply mf mx =
  case (mf, mx) of
     (Just f, Just x) -> f x
     _ -> Nothing
           
