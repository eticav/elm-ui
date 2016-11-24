module Helpers.ComponentCom exposing (..)

import Task exposing (Task)

message : msg -> Cmd msg
message x =
  Task.perform identity (Task.succeed x)
      
mapComponent : (component->model
               )->(component, cmd, msg)->(model, cmd, msg)
mapComponent f (model, cmd, msg)=
  (f model, cmd, msg)

mapCmd : (childmsg -> parentmsg) -> ( a, Cmd childmsg, c ) -> ( a, Cmd parentmsg, c )
mapCmd f ( x, cmd, z ) =
    ( x, Cmd.map f cmd, z )

mapCmdNone : ( a, Cmd childmsg, c ) -> ( a, Cmd parentmsg, c )
mapCmdNone ( x, cmd, z ) =
    ( x, Cmd.none, z )
      
evaluate : (outMsg->model->(model,Cmd cmd))->( model, Cmd cmd, outMsg )->(model,Cmd cmd)
evaluate f ( model, cmd, outMsg ) =
  let 
    (newModel,newCmd)=f outMsg model
  in
    (newModel, Cmd.batch [cmd, newCmd])

evaluateWithOut : (outMsg->model->(model,Cmd cmd,c))->( model, Cmd cmd, outMsg )->(model,Cmd cmd, c)
evaluateWithOut f ( model, cmd, outMsg ) =
  let 
    (newModel,newCmd, newOut)=f outMsg model
  in
    (newModel, Cmd.batch [cmd, newCmd], newOut)

---------------------
type alias Com model childModel msg message childOutMessage outMessage =
  { model : model
  , childModel : Maybe childModel
  , msg : msg
  , cmd : Cmd message
  , childOutMessage : Maybe childOutMessage
  , outMessage : outMessage
  }

-- UNDO MARK 

do : msg->model->outMessage-> Com model childModel msg message childOutMessage outMessage
do msg imodel outMessage =
  { model = imodel
  , childModel = Nothing
  , msg = msg
  , cmd = Cmd.none
  , childOutMessage = Nothing
  , outMessage = outMessage
  }

callChild : (childMessage->childModel->(childModel, Cmd childMessage, childOutMessage))
            ->(msg->childMessage)
            ->(model->childModel)
            ->(childMessage-> message)
            ->Com model childModel msg message childOutMessage outMessage
            ->Com model childModel msg message childOutMessage outMessage
callChild update toChildMsg toChildModel mapCmd com =
  let
    (updatedModel, newCmd, outMsg) = update (toChildMsg com.msg ) (toChildModel com.model)
    batchedCmd = Cmd.batch [com.cmd, Cmd.map (mapCmd) newCmd]
  in
    { model = com.model
    , childModel = Just updatedModel
    , msg = com.msg
    , cmd = batchedCmd
    , childOutMessage = Just outMsg
    , outMessage = com.outMessage
    }    

save : (model->childModel ->model)->
       Com model childModel msg message childOutMessage outMessage->
       Com model childModel msg message childOutMessage outMessage
save saver com =
  let
    updatedModel = case com.childModel of
                     Just cModel-> saver com.model cModel
                     _ -> com.model
  in
    { model = updatedModel
    , childModel = com.childModel
    , msg = com.msg
    , cmd = com.cmd
    , childOutMessage = com.childOutMessage
    , outMessage = com.outMessage
    }

receive : (model->childOutMessage->(model, Cmd message))->
          Com model childModel msg message childOutMessage outMessage->
          Com model childModel msg message childOutMessage outMessage
receive receiver com=
  let
    (updatedModel,newCmd)=case com.childOutMessage of
                            Just oMsg -> receiver com.model oMsg
                            Nothing -> (com.model, Cmd.none)
  in
    { model = updatedModel
    , childModel = com.childModel
    , msg = com.msg
    , cmd = Cmd.batch [com.cmd, newCmd]
    , childOutMessage = com.childOutMessage
    , outMessage = com.outMessage
    }

send : (model->childOutMessage->outMessage)->
       Com model childModel msg message childOutMessage outMessage->
       Com model childModel msg message childOutMessage outMessage
send sender com =
  let 
    newParentMsg =case com.childOutMessage of
                    Just childOut -> sender com.model childOut
                    Nothing-> com.outMessage
  in
    { model = com.model
    , childModel = com.childModel
    , msg = com.msg
    , cmd = com.cmd
    , childOutMessage = com.childOutMessage
    , outMessage = newParentMsg
    }

andThen : Com model bchildModel msg message bchildOutMessage outMessage->
          (Com model achildModel msg message achildOutMessage outMessage->Com model achildModel msg message achildOutMessage outMessage)->
          Com model achildModel msg message achildOutMessage outMessage
andThen com f =
  f { model = com.model
    , childModel = Nothing
    , msg = com.msg
    , cmd = com.cmd
    , childOutMessage = Nothing
    , outMessage = com.outMessage
    }
           

return : Com model childModel msg message childOutMessage outMessage->
      (model, Cmd message, outMessage)
return com =
  (com.model, com.cmd, com.outMessage)
