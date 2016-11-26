module Mdl.List.View exposing (..)

import Mdl.List.Model as Models
import Mdl.List.Messages as Messages exposing (Message)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Date exposing (Date)
import FunFolding

--type alias Content data = { field : Models.Fields data
  --                        }

type alias Primary data = { content : Models.Fields data
                          , sub : Maybe (Models.Fields data)
                          , icon : Maybe (Models.Fields data)
                          }

type alias Secondary data = { icon : Models.Fields data
                            , info : Maybe (Models.Fields data)
                            }

type alias Config data = { primary : Primary data
                         , secondary : Maybe (Secondary data)
                         , classes : Classes
                         }

type alias Classes = { list : String
                     , item : String
                     , primary : String
                     , primaryContent : String
                     , primaryIcon : String
                     , primarySub : String
                     , secondary : String
                     , secondaryIcon : String
                     , secondaryInfo : String
                     }

initialClassesMdl = { list = "mdl-list mdl-shadow--2dp"
                    , item = "mdl-list__item mdl-list__item--two-line"
                    , primary = "mdl-list__item-primary-content"
                    , primaryContent = ""
                    , primaryIcon = "material-icons mdl-list__item-icon"
                    , primarySub = "mdl-list__item-sub-title"
                    , secondary = "mdl-list__item-secondary-content"
                    , secondaryIcon = "material-icons"
                    , secondaryInfo = "mdl-list__item-secondary-info"
                    }

setSecondaryIcon : (Models.Fields data)->Config data->Config data
setSecondaryIcon icon config =
  let
    newSecondary = Secondary icon Nothing
  in    
    {config|secondary=Just newSecondary}

setSecondaryInfo : (Models.Fields data)->Config data->Config data
setSecondaryInfo info config =
  let
    updatedSecondary = Maybe.map (\x->{x|info=Just info}) config.secondary
  in
    
    {config|secondary=updatedSecondary}
    
config : Models.Fields data->Config data
config primaryContent  = { primary = Primary primaryContent Nothing Nothing
                         , secondary = Nothing
                         , classes = initialClassesMdl
                         }

setPrimaryIcon : (Models.Fields data)->Config data->Config data
setPrimaryIcon icon config =
  let
    primary = config.primary    
  in
    {config|primary={primary|icon=Just icon}}

setPrimarySub : (Models.Fields data)->Config data->Config data
setPrimarySub sub config =
  let
    primary = config.primary 
  in
    {config|primary={primary|sub=Just sub}}

access : Models.Fields data->data->String
access col data =
  case col.accessor of
    Models.Integer accessor-> toString (accessor data)
    Models.Float accessor-> toString (accessor data)
    Models.AlphaNumeric accessor-> accessor data
    Models.Date accessor-> toString (accessor data)

iconView : String->Models.Fields data->data->Html (Message data)
iconView class icon data=
  Html.i
        [ Attributes.class class ]
        [ Html.text (access icon data)]

contentView : String->Models.Fields data->data->Html (Message data)
contentView class sub data =
    Html.span
          [ Attributes.class class ]
          [ Html.text (access sub data)]

subView : String->Models.Fields data->data->Html (Message data)
subView  = contentView

infoView : String->Models.Fields data->data->Html (Message data)
infoView  = contentView
      
primaryView : Classes->Primary data->data->Html (Message data)
primaryView classes primary data =
  let
    primarySpan body = Html.span
                  [ Attributes.classList [(classes.primary,True)]
                  ,  Events.onClick (Messages.Primary data)
                  ]
                  body
  in
    case (primary.content, primary.sub, primary.icon) of
    (content, Just sub, Nothing)->
      primarySpan [ contentView classes.primaryContent content data
                  , subView classes.primarySub sub data
                  ]
    (content, Nothing, Just icon)->
      primarySpan [ iconView classes.primaryIcon icon data
                  , contentView classes.primaryContent content data
                  ]
    (content, Just sub, Just icon)->
      primarySpan [ iconView classes.primaryIcon icon data
                  , contentView classes.primaryContent content data
                  , subView classes.primarySub sub data
                  ]
    (content, Nothing, Nothing)->
      primarySpan [ contentView classes.primaryContent content data
                  ]

secondaryView : Classes->Secondary data -> data -> Html (Message data)
secondaryView classes secondary data =
  let
    secondarySpan body = Html.span
                  [ Attributes.classList [(classes.secondary,True)]
                  , Events.onClick (Messages.Secondary data)
                  ]
                  body
  in
    case secondary.info of
      Just info -> secondarySpan [ infoView classes.secondaryInfo info data
                                 , iconView classes.secondaryIcon secondary.icon data
                                 ]
      Nothing -> secondarySpan [ iconView classes.secondaryIcon secondary.icon data
                               ]
      
view : Config data->List data->Models.Model-> Html (Message data)
view config list model =
  let
    sortedList = list
    item data =
      case config.secondary of
        Just secondary->
          Html.li
                [ Attributes.classList [(config.classes.item,True)]]
                [ primaryView config.classes config.primary data
                , secondaryView config.classes secondary data
                ]                  
        Nothing->
          Html.li
                [ Attributes.classList [(config.classes.item,True)]]              
                [ primaryView config.classes config.primary data
                ]
  in
    Html.ul [ Attributes.classList [(config.classes.list,True)]] (List.map (\i->item i) sortedList)
