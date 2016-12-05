module Mdl.SplittedPanes.Models exposing (..)

type alias Splitter = { primaryRatio : Int
                      , secondaryRatio : Int
                      , resizing : Bool
                      }

type Orientation = Horizontal
                 | Vertical
                    
type alias Model primaryModel secondaryModel = { primary : primaryModel
                                               , secondary : secondaryModel
                                               , splitter : Splitter
                                               , orientation : Orientation
                                               }

initialModel : primaryModel->secondaryModel->Model primaryModel secondaryModel
initialModel primary secondary = { primary = primary
                                 , secondary = secondary
                                 , splitter = Splitter 1000 1000 False
                                 , orientation = Vertical
                                 }
