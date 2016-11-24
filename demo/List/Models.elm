module List.Models exposing (..)

import Mdl.List.Model as MdlList

type alias Model  = { table : MdlList.Model
                    , list : List Person
                    }

type alias Person = { name : String
                    , age : Int
                    , adresse : String
                    }

initialModel : Model
initialModel = { table = MdlList.initialModel
               , list = initialList
               }

initialList : List Person
initialList  =
  [ Person "Etienne" 44 "La chauveliere"
  , Person "Etienne" 44 "La chauveliere2"
  , Person "Etienne" 44 "La chauveliere1"
  , Person "Etienne" 45 "La chauveliere"
  , Person "Etienne" 43 "La chauveliere"
  , Person "Elodie" 35 "La chauveliere"
  , Person "Antoine" 6 "La chauveliere"
  , Person "Manon" 3 "La chauveliere"
  ]
