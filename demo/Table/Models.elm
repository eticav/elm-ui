module Table.Models exposing (..)

import Mdl.Table.Model as Table

type alias Model  = { table : Table.Model Person
                    , list : List Person
                    }

type alias Person = { id : Int
                    , name : String
                    , age : Int
                    , adresse : String
                    }

exact : Person->Person->Bool
exact a b =
      a.id == b.id

initialModel : Model
initialModel = { table = Table.initialModel
               , list = initialList
               }

initialList : List Person
initialList  =
  [ Person 1 "Etienne" 44 "La chauveliere"
  , Person 2 "Etienne" 44 "La chauveliere2"
  , Person 3 "Etienne" 44 "La chauveliere1"
  , Person 4 "Etienne" 45 "La chauveliere"
  , Person 5 "Etienne" 43 "La chauveliere"
  , Person 6 "Elodie" 35 "La chauveliere"
  , Person 7 "Antoine" 6 "La chauveliere"
  , Person 8 "Manon" 3 "La chauveliere"
  ]
