module Mdl.Button.View exposing (..)

import Mdl.Button.Model as Models
import Mdl.Button.Messages as Messages exposing (Message)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events

type alias Config = { classes : Classes                    
                    }

type alias Classes = { button : String
                     , kind : String
                     , color : String
                     , icon : Maybe String
                     }

buttonClasses button kind color = { button = button
                                  , kind = kind
                                  , color = color
                                  , icon = Nothing
                                  }

iconClasses button kind color icon = { button = button
                                     , kind = kind
                                     , color = color
                                     , icon = Just icon
                                     }

buttonConfig button kind color= { classes = buttonClasses button kind color
                                }

mdlButtonConfig = buttonConfig "mdl-button" "mdl-button--raised"  "mdl-button--colored" 

iconConfig button kind color icon = { classes = iconClasses button kind color icon
                                    }
mdlIconConfig = iconConfig "mdl-button" "mdl-button--icon"  "mdl-button--colored"  "material-icons"
  
icon : Config->String->Models.Model->Html (Message)
icon config name model =
  Html.i
        [ Attributes.class (Maybe.withDefault "" config.classes.icon)
        ]
        [Html.text name]

view : Config->String->Models.Model->Html (Message)
view config name model =
  Html.button
        [Attributes.classList [ (config.classes.button,True)
                              , (config.classes.kind,True)
                              , (config.classes.color,True)
                              ]
        ]
        [ case config.classes.icon of
            Just _-> icon config name model
            Nothing->Html.text name
        ]
