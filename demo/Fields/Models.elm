module Fields.Models exposing (..)

import Mdl.TextField.TextField as TextField

type alias Model = { textField : TextField.Model
                   }

initialModel : Model
initialModel = { textField = TextField.initialModel
               }
