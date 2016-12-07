module Mdl.SplittedPanes.Update exposing (..)

import Mdl.SplittedPanes.Models exposing (Model, Orientation(..))
import Mdl.SplittedPanes.Messages exposing (Message(..))

import MouseEvents

type alias Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg =
  { primaryUpdate : (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg, primaryOutMsg))
  , secondaryUpdate : (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg, secondaryOutMsg))
  , primaryOutToBus : Maybe (primaryOutMsg->busMsg)
  , secondaryOutToBus : Maybe (secondaryOutMsg->busMsg)
  , busToPrimary : Maybe (busMsg->Maybe primaryMsg)
  , busToSecondary : Maybe (busMsg->Maybe secondaryMsg)
  , toOutMsg : Maybe busMsg->Maybe busMsg->outMsg
  }

updater : (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg,primaryOutMsg))->
          (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg,secondaryOutMsg))->
          (Maybe busMsg->Maybe busMsg->outMsg)-> 
          Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
updater primaryUpdate secondaryUpdate toOutMsg = { primaryUpdate = primaryUpdate
                                                 , secondaryUpdate = secondaryUpdate
                                                 , primaryOutToBus = Nothing
                                                 , secondaryOutToBus = Nothing
                                                 , busToPrimary = Nothing
                                                 , busToSecondary = Nothing
                                                 , toOutMsg=toOutMsg
                                                 }


primaryOutToBus : (primaryOutMsg->busMsg)->
                  Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                    Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
primaryOutToBus f updater = 
  {updater|primaryOutToBus=Just f}

secondaryOutToBus : (secondaryOutMsg->busMsg)->
                    Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                    Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
secondaryOutToBus f updater = 
  {updater|secondaryOutToBus=Just f}

busToPrimary : (busMsg->Maybe primaryMsg)->
                 Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                 Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
busToPrimary f updater = 
  {updater|busToPrimary=Just f}
  
busToSecondary : (busMsg->Maybe secondaryMsg)->
                 Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                 Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
busToSecondary f updater = 
  {updater|busToSecondary=Just f}
  
  
update : Message primaryMsg secondaryMsg->
         Model primaryModel secondaryModel->
         Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
         (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg),outMsg)
update msg model updater =
    (updateFromMsg model updater msg)
      |> updateFromBus msg updater
  
updateFromMsg : Model primaryModel secondaryModel->
                Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                Message primaryMsg secondaryMsg->
                (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg), Maybe busMsg)
updateFromMsg model updater msg  =
    case msg of
      Primary primaryMsg ->
        let
          (updatePrimary, cmd, outMsg) = updater.primaryUpdate primaryMsg model.primary
          toBusMsg outMsg = Maybe.map (\f-> f outMsg) updater.primaryOutToBus
        in
          ({model|primary=updatePrimary}, Cmd.map Primary cmd, toBusMsg outMsg)
      Secondary secondaryMsg ->
        let
          (updateSecondary,cmd, outMsg) = updater.secondaryUpdate secondaryMsg model.secondary
          toBusMsg outMsg = Maybe.map (\f-> f outMsg) updater.secondaryOutToBus
        in
          ({model|secondary=updateSecondary}, Cmd.map Secondary cmd, toBusMsg outMsg)
      MouseDown me->
        let
          splitter = model.splitter
          updatedSplitter = {splitter|resizing=True}
        in
          ({model|splitter = updatedSplitter}, Cmd.none, Nothing)
      MouseUp me->
        let
          splitter = model.splitter
          updatedSplitter = {splitter|resizing=False}
        in
          ({model|splitter = updatedSplitter}, Cmd.none, Nothing)
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
          ({model|splitter=updatedSplitter}, Cmd.none, Nothing)
          
updateFromBus :Message primaryMsg secondaryMsg->
                Update primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg),Maybe busMsg)->
                (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg), outMsg)
updateFromBus msg updater (model, cmd, mBusMsg) =
  let        
    (primaryUpdatedModel, primaryCmd, primaryBusMsg) = maybeApply updater.busToPrimary mBusMsg
                                                     |> Maybe.map (\x->updateFromMsg model updater (Primary x))
                                                     |> Maybe.withDefault (model, Cmd.none, Nothing)
                                         
    (secondaryUpdatedModel, secondaryCmd, secondaryBusMsg) = maybeApply updater.busToSecondary mBusMsg
                                                           |> Maybe.map (\x->updateFromMsg primaryUpdatedModel updater (Secondary x))
                                                           |> Maybe.withDefault (primaryUpdatedModel, Cmd.none, Nothing)

  in
    (secondaryUpdatedModel, Cmd.batch [cmd, primaryCmd, secondaryCmd], updater.toOutMsg primaryBusMsg secondaryBusMsg)
             
maybeApply mf mx =
  case (mf, mx) of
     (Just f, Just x) -> f x
     _ -> Nothing
           
