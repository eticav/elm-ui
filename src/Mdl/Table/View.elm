module Mdl.Table.View exposing (..)


import Mdl.Table.Model exposing (..)
import Mdl.Table.Messages exposing (Message(..))

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events

import Date exposing (Date)
import FunFolding

type alias Config data = { columns : List (Column data)
                         , exact : (data->data->Bool)
                         , tableCls : String
                         , nonNumericCls : String
                         , ascendinCls  : String
                         , descendingCls : String
                         , isSelectedCls : String
                         }

notOrder : Order->Order
notOrder order =
  case order of
    LT->GT
    GT->LT
    EQ->EQ
         
compare : ColumnOrder data->data->data->Order
compare colO x y =
  let
    notComp x y = notOrder (Basics.compare x y)
    (col, comp ) = case colO of
                     Increasing col-> (col, Basics.compare)
                     Decreasing col ->(col, notComp)
  in
    case col.accessor of
      Integer accessor-> comp (accessor x) (accessor y)
      Float accessor-> comp (accessor x) (accessor y)
      AlphaNumeric accessor-> comp (accessor x) (accessor y)
      Date accessor-> comp (toString (accessor x)) (toString (accessor y))

compareList : Model data->List(data->data->Order)
compareList model =
  List.map compare model.sortBy
  
access : Column data->data->String
access col data =
  case col.accessor of
    Integer accessor-> toString (accessor data)
    Float accessor-> toString (accessor data)
    AlphaNumeric accessor-> accessor data
    Date accessor-> toString (accessor data)
                    
find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just first
            else
                find predicate rest
    
view : Config data->List data->Model data-> Html (Message data)
view config list model =
  let
    exactCurrent = case model.current of
                     Just current-> config.exact current
                     Nothing ->(\x->False)
                               
    sort = FunFolding.compareN (compareList model)
    sortedList = List.sortWith sort list
    
    table = Html.table
            [ Attributes.classList [(config.tableCls,True)]
            ]             

    thead head = Html.thead
                 []
                 [ Html.tr
                     []
                     head
                 ]
     
    arrows model col =
      let
        mcolO = find (\x->exactCol col x) model.sortBy
      in
        case mcolO of
          Just colO-> case colO of
                        Increasing _-> Just config.ascendinCls
                        Decreasing _ -> Just config.descendingCls
          Nothing -> Nothing
                            
    th model col =
      let
        inOrDec = arrows model col        
      in
        Html.th
              [ Events.onClick (Sort col)
              , Attributes.classList [ (Maybe.withDefault "" inOrDec, (Maybe.map (\x->True) inOrDec) |> Maybe.withDefault False)
                                     , (config.nonNumericCls, not (isNumeric col))
                                     ]
              ]
              [Html.text col.name]       

    tr row = 
      Html.tr
            [Events.onClick (Current row)
            , Attributes.classList [ (config.isSelectedCls, exactCurrent row)
                                   ]
            ]
            (List.map (\column->td column row) config.columns)
             
    td column row =
      Html.td
          [ Attributes.classList [ (config.nonNumericCls,(not (isNumeric column)))
                                 ]
          ]
        [Html.text (access column row)]
  in
    table [(thead (List.map (\x->th model x) config.columns))
          , Html.tbody
             []
             (List.map (\row->tr row) sortedList)]
