module SplittedPanes.Models exposing (..)

import Mdl.SplittedPanes.Models as SplittedPanes

type HeaderModel = HeaderModel
type PrimaryModel = PrimaryModel
type SecondaryModel = SecondaryModel

type alias Model  = { splittedPanes : SplittedPanes.Model HeaderModel PrimaryModel SecondaryModel
                    }

initialModel : Model
initialModel = { splittedPanes = SplittedPanes.initialModel HeaderModel PrimaryModel SecondaryModel
               }
