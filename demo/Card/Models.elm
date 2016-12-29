module Card.Models exposing (..)

type alias Model = { card : Person                  
                   }

type alias Person = { id : Int
                    , name : String
                    , age : Int
                    , adresse : String
                    }

initialModel : Model
initialModel = { card = (Person 1 "Etienne" 44 "La chauveliere")
               }
