module Mdl.Card.Models exposing (..)

type alias Model data= { data : data
                       }
  
initialModel : data->Model data
initialModel data = { data = data
                    }


