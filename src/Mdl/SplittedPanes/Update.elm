module Mdl.SplittedPanes.Update exposing (..)

import Mdl.SplittedPanes.Models exposing (Model, Orientation(..))
import Mdl.SplittedPanes.Messages exposing (Message(..))

import MouseEvents

type alias Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg =
  { headerUpdate : (headerMsg->headerModel->(headerModel,Cmd headerMsg, headerOutMsg))
  , primaryUpdate : (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg, primaryOutMsg))
  , secondaryUpdate : (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg, secondaryOutMsg))
  , headerOutToBus : Maybe (headerOutMsg->busMsg)
  , primaryOutToBus : Maybe (primaryOutMsg->busMsg)
  , secondaryOutToBus : Maybe (secondaryOutMsg->busMsg)
  , busToHeader : Maybe (busMsg->Maybe headerMsg)
  , busToPrimary : Maybe (busMsg->Maybe primaryMsg)
  , busToSecondary : Maybe (busMsg->Maybe secondaryMsg)
  , toOutMsg : Maybe busMsg->Maybe busMsg->Maybe busMsg->outMsg
  }

updater : (headerMsg->headerModel->(headerModel,Cmd headerMsg,headerOutMsg))->
          (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg,primaryOutMsg))->
          (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg,secondaryOutMsg))->
          (Maybe busMsg->Maybe busMsg->Maybe busMsg->outMsg)-> 
          Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
updater headerUpdate primaryUpdate secondaryUpdate toOutMsg = { headerUpdate = headerUpdate
                                                              , primaryUpdate = primaryUpdate
                                                              , secondaryUpdate = secondaryUpdate
                                                              , headerOutToBus = Nothing
                                                              , primaryOutToBus = Nothing
                                                              , secondaryOutToBus = Nothing
                                                              , busToHeader = Nothing
                                                              , busToPrimary = Nothing
                                                              , busToSecondary = Nothing
                                                              , toOutMsg=toOutMsg
                                                              }

headerOutToBus : (headerOutMsg->busMsg)->
                 Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                 Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
headerOutToBus f updater = 
  {updater|headerOutToBus=Just f}
  
primaryOutToBus : (primaryOutMsg->busMsg)->
                  Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                    Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
primaryOutToBus f updater = 
  {updater|primaryOutToBus=Just f}

secondaryOutToBus : (secondaryOutMsg->busMsg)->
                    Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                    Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
secondaryOutToBus f updater = 
  {updater|secondaryOutToBus=Just f}

busToPrimary : (busMsg->Maybe primaryMsg)->
                 Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                 Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
busToPrimary f updater = 
  {updater|busToPrimary=Just f}
  
busToSecondary : (busMsg->Maybe secondaryMsg)->
                 Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                 Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg
busToSecondary f updater = 
  {updater|busToSecondary=Just f}
  
  
update : Message headerMsg primaryMsg secondaryMsg->
         Model headerModel primaryModel secondaryModel->
         Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
         (Model headerModel primaryModel secondaryModel, Cmd (Message headerMsg primaryMsg secondaryMsg),outMsg)
update msg model updater =
    (updateFromMsg model updater msg)
      |> updateFromBus msg updater
  
updateFromMsg : Model headerModel primaryModel secondaryModel->
                Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                Message headerMsg primaryMsg secondaryMsg->
                (Model headerModel primaryModel secondaryModel, Cmd (Message headerMsg primaryMsg secondaryMsg), Maybe busMsg)
updateFromMsg model updater msg  =
    case msg of
      Header headerMsg ->
        let
          (updateHeader, cmd, outMsg) = updater.headerUpdate headerMsg model.header
          toBusMsg outMsg = Maybe.map (\f-> f outMsg) updater.headerOutToBus
        in
          ({model|header=updateHeader}, Cmd.map Header cmd, toBusMsg outMsg)
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
          
updateFromBus :Message headerMsg primaryMsg secondaryMsg->
                Update headerMsg headerModel headerOutMsg primaryMsg primaryModel primaryOutMsg secondaryMsg secondaryModel secondaryOutMsg busMsg outMsg->
                (Model headerModel primaryModel secondaryModel, Cmd (Message headerMsg primaryMsg secondaryMsg),Maybe busMsg)->
                (Model headerModel primaryModel secondaryModel, Cmd (Message headerMsg primaryMsg secondaryMsg), outMsg)
updateFromBus msg updater (model, cmd, mBusMsg) =
  let
    (headerUpdatedModel, headerCmd, headerBusMsg) = maybeApply updater.busToHeader mBusMsg
                                                     |> Maybe.map (\x->updateFromMsg model updater (Header x))
                                                     |> Maybe.withDefault (model, Cmd.none, Nothing)
    
    (primaryUpdatedModel, primaryCmd, primaryBusMsg) = maybeApply updater.busToPrimary mBusMsg
                                                     |> Maybe.map (\x->updateFromMsg headerUpdatedModel updater (Primary x))
                                                     |> Maybe.withDefault (model, Cmd.none, Nothing)
                                         
    (secondaryUpdatedModel, secondaryCmd, secondaryBusMsg) = maybeApply updater.busToSecondary mBusMsg
                                                           |> Maybe.map (\x->updateFromMsg primaryUpdatedModel updater (Secondary x))
                                                           |> Maybe.withDefault (primaryUpdatedModel, Cmd.none, Nothing)

  in
    (secondaryUpdatedModel, Cmd.batch [cmd, headerCmd, primaryCmd, secondaryCmd], updater.toOutMsg headerBusMsg primaryBusMsg secondaryBusMsg)
             
maybeApply mf mx =
  case (mf, mx) of
     (Just f, Just x) -> f x
     _ -> Nothing
           
