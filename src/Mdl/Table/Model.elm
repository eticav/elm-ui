module Mdl.Table.Model exposing (..)

import Date exposing (Date)

type alias Model data = { sortBy : List (ColumnOrder data)
                        }
                 
type alias Column data = { name : String
                         , accessor : Accessor data
                         }

type Accessor data = Integer (data->Int)
                   | Float (data->Float)
                   | AlphaNumeric (data->String)
                   | Date (data->Date)
          
type ColumnOrder data = Increasing (Column data)
                      | Decreasing (Column data)

toggle : Maybe (ColumnOrder data)->Column data->Maybe (ColumnOrder data)
toggle colOrder default=
  case colOrder of
    Just val -> case val of 
                  Increasing col -> Just (Decreasing col)
                  Decreasing col -> Nothing
    Nothing -> Just (Increasing default)
    
                      
exactCol : Column data -> ColumnOrder data -> Bool
exactCol col colOrder =
  case colOrder of
    Increasing x -> col.name == x.name
    Decreasing x -> col.name == x.name

isNumeric : Column data -> Bool
isNumeric col =
  case col.accessor of
    Integer _->True
    Float _->True
    AlphaNumeric _->False
    Date _->False
        
initialModel : Model data
initialModel = { sortBy = []
               }
