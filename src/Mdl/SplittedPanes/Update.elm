module Mdl.SplittedPanes.Update exposing (..)

import Mdl.SplittedPanes.Models exposing (Model, Orientation(..))
import Mdl.SplittedPanes.Messages exposing (Message(..))

import MouseEvents

type alias Update primaryMsg primaryModel secondaryMsg secondaryModel =
  { primaryUpdate : (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg))
  , secondaryUpdate : (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg))
  }

updater : (primaryMsg->primaryModel->(primaryModel,Cmd primaryMsg))->
          (secondaryMsg->secondaryModel->(secondaryModel,Cmd secondaryMsg))->
          Update primaryMsg primaryModel secondaryMsg secondaryModel        
updater primaryUpdate secondaryUpdate = { primaryUpdate = primaryUpdate
                        , secondaryUpdate = secondaryUpdate
                        }

update : Message primaryMsg secondaryMsg->
         Model primaryModel secondaryModel->
         Update primaryMsg primaryModel secondaryMsg secondaryModel->
         (Model primaryModel secondaryModel, Cmd (Message primaryMsg secondaryMsg))
update msg model updater =
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
        _=Debug.log "down" me
        splitter = model.splitter
        updatedSplitter = {splitter|resizing=True}
      in
        ({model|splitter = updatedSplitter}, Cmd.none)
    MouseUp me->
      let
        _=Debug.log "up" me
        splitter = model.splitter
        updatedSplitter = {splitter|resizing=False}
      in
        ({model|splitter = updatedSplitter}, Cmd.none)
    Move me->
      let
        _=Debug.log "move" me
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
