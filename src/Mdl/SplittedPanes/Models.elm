module Mdl.SplittedPanes.Models exposing (..)

type alias Splitter = { primaryRatio : Int
                      , secondaryRatio : Int
                      , resizing : Bool
                      }

type Orientation = Horizontal
                 | Vertical
                    
type alias Model headerModel primaryModel secondaryModel = { header : headerModel
                                                           , primary : primaryModel
                                                           , secondary : secondaryModel
                                                           , splitter : Splitter
                                                           , orientation : Orientation
                                                           }

initialModel : headerModel->primaryModel->secondaryModel->Model headerModel primaryModel secondaryModel
initialModel header primary secondary = { header=header
                                        , primary = primary
                                        , secondary = secondary
                                        , splitter = Splitter 1000 1000 False
                                        , orientation = Vertical
                                        }
