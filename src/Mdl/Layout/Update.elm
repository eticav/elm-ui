module Mdl.Layout.Update exposing ( update
                                  , mapDrawerMsg
                                  , drawerUpdate
                                  , updater)


{-| Layout update functions

@docs update, mapDrawerMsg, drawerUpdate, updater

-}

import Mdl.Layout.Models as Models exposing (Model)
import Mdl.Layout.Message exposing (Message(..))

type alias Update contentMsg contentModel drawerMsg drawerModel =
  { contentUpdate : (contentMsg->contentModel->(contentModel,Cmd contentMsg))
  , drawerUpdate : Maybe (drawerMsg->drawerModel->(drawerModel,Cmd drawerMsg))
  , mapDrawerMsg : Maybe (drawerMsg->contentMsg)
  }
                                                                
{-| updater function
-}
updater : (contentMsg->contentModel->(contentModel,Cmd contentMsg)) ->
          Update contentMsg contentModel drawerMsg drawerModel        
updater contentUpdate = { contentUpdate = contentUpdate
                        , drawerUpdate = Nothing
                        , mapDrawerMsg = Nothing
                        }

{-| drawerUpdate function
-}
drawerUpdate : (drawerMsg->drawerModel->(drawerModel,Cmd drawerMsg)) ->
               Update contentMsg contentModel drawerMsg drawerModel ->
               Update contentMsg contentModel drawerMsg drawerModel
drawerUpdate drawerUpdate updater =
  {updater|drawerUpdate=Just drawerUpdate}
    
{-| mapDrawerMsg function
-}
mapDrawerMsg : (drawerMsg->contentMsg)->
               Update contentMsg contentModel drawerMsg drawerModel ->
               Update contentMsg contentModel drawerMsg drawerModel
mapDrawerMsg mapDrawerMsg updater =
  {updater|mapDrawerMsg=Just mapDrawerMsg}
    
{-| update function
-}
update : Message contentMsg drawerMsg->
         Model contentModel drawerModel->
         Update contentMsg contentModel drawerMsg drawerModel->
         (Model contentModel drawerModel, Cmd (Message contentMsg drawerMsg))
update msg  model updater =
  case msg of
    Content contentMsg ->
      let
        (updateContent,cmd) = updater.contentUpdate contentMsg model.content
      in
        ({model|content=updateContent}, Cmd.map Content cmd)
    Drawer drawerMsg ->
      case (model.drawer, updater.drawerUpdate) of
        (Just drawerModel, Just drawerUpdate)-> 
          let
            (updatedDrawer,cmdDrawer) = drawerUpdate drawerMsg drawerModel
          in
            case updater.mapDrawerMsg of
              Just map ->
                let
                  (updatedContent,cmdContent)=updater.contentUpdate (map drawerMsg) model.content
                  updatedModel = {model|drawer=Just updatedDrawer, content = updatedContent}
                in
                  ( Models.setIsDrawerOpen (not (Models.isDrawerOpen model)) updatedModel
                  , Cmd.batch [(Cmd.map Drawer cmdDrawer), (Cmd.map Content cmdContent)]
                  )
              Nothing ->                             
                ({model|drawer=Just updatedDrawer}, Cmd.map Drawer cmdDrawer)
        (_,_) -> (model, Cmd.none)
    ToggleDrawer->
      (Models.setIsDrawerOpen (not (Models.isDrawerOpen model)) model, Cmd.none)
      
    ScrollContent offset ->
        (Models.setIsScrolled (0.0 < offset) model, Cmd.none)
