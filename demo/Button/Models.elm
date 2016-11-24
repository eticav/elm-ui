module Button.Models exposing (..)

import Mdl.Button.Model as MdlButton

type alias Model ={ button : MdlButton.Model
                  }
                  
initialModel : Model
initialModel = { button = MdlButton.initialModel
               }
