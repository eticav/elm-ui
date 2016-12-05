module SplittedPanes.Models exposing (..)

import Mdl.SplittedPanes.Models as SplittedPanes

type PrimaryModel = PrimaryModel
type SecondaryModel = SecondaryModel

type alias Model  = { splittedPanes : SplittedPanes.Model PrimaryModel SecondaryModel
                    }

initialModel : Model
initialModel = { splittedPanes = SplittedPanes.initialModel PrimaryModel SecondaryModel
               }
