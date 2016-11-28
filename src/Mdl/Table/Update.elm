module Mdl.Table.Update exposing (..)

import Mdl.Table.Messages exposing (Message(..),OutMessage(..))
import Mdl.Table.Model exposing (Model, ColumnOrder(..), exactCol, toggle)
import List

getAndRemove : (a -> Bool) -> List a -> (Maybe a, List a)
getAndRemove predicate list =
  let 
    (result, newList) = List.partition predicate list
  in 
    case result of
      r::tail->(Just r, newList)
      []->(Nothing, newList)

updateWithOut : Message data-> Model data-> (Model data , Cmd (Message data), OutMessage data)
updateWithOut msg model =
  case msg of
    Sort col->
      let
        exact x = exactCol col x
        (item, list)=getAndRemove (\x->exact x) model.sortBy
        updatedSortBy = case toggle item col of
                          Just i-> i :: list
                          Nothing -> list
      in
        ({model|sortBy = updatedSortBy}, Cmd.none, OutNothing)
    Current data ->
      ({model|current =Just data}, Cmd.none, OutCurrent data)
        
update : Message data-> Model data-> (Model data , Cmd (Message data))
update msg model =
  let 
    (outModel,outCmd,outMsg)=updateWithOut msg model
  in
    (outModel,outCmd)
