module Card.Models exposing (..)

import Mdl.Card.Models as MdlCard

type alias Model = { card : MdlCard.Model Person                  
                   }

type alias Person = { id : Int
                    , name : String
                    , age : Int
                    , adresse : String
                    }

initialModel : Model
initialModel = { card = MdlCard.initialModel
                          (Person 1 "Etienne" 44 "La chauveliere")
               }
