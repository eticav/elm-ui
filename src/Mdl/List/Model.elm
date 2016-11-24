module Mdl.List.Model exposing (..)

import Date exposing (Date)
type Model = Model

           
type alias Fields data = { name : String
                         , accessor : Accessor data
                         }

type Accessor data = Integer (data->Int)
                   | Float (data->Float)
                   | AlphaNumeric (data->String)
                   | Date (data->Date)

initialModel : Model
initialModel = Model
