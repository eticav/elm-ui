module Mdl.Card.View exposing (..)

import Mdl.Card.Models as Models
import Mdl.Card.Messages as Messages exposing (Message(..))
import Mdl.Card.Css as CardCss
import Html.CssHelpers
import Css exposing (..)
import HelpersList exposing (..)

import Html exposing (Html,Attribute)

type alias Config = { classes : Classes
                    }
                  
mdlCardConfig = { classes = Classes
                }

type  Classes = Classes

stylesheet =
  let 
    {css, warnings} = Css.compile [CardCss.css]
  in
    Html.CssHelpers.style css

node : (List (Attribute msg)->List (Html msg)->Html msg)->
              List (Attribute msg)->
              List (Attribute msg)->
              List (Html msg)->
              Html msg
node fnode attrs divAttrs  =
  fnode (List.concat [attrs, divAttrs])

maybeDiv1 : (a -> msg)->List (Attribute msg)-> (model->Html a)-> (model->Html msg)
maybeDiv1 map attr view =
  let 
    g model = Html.div attr [(Html.map map (view model))] 
  in
    g
  
maybeDiv : (a -> msg)->List (Attribute msg)->Maybe (model->Html a)->Maybe (model->Html msg)
maybeDiv map attr view=
  Maybe.map (maybeDiv1 map attr ) view
  
view : Config->
       Maybe (data->Html (header))->
       Maybe (data->Html (image))->
       Maybe (data->Html (content))->
       Maybe (data->Html (footer))->
       Models.Model data->Html (Message header image content footer)
view config headerView imageView contentView footerView  model =
  let
    { id, class,  classList} =
      Html.CssHelpers.withNamespace "powet"
          
    mCardNode = functionFilterFold
               (node Html.div [class [CardCss.Card]] [])
                 [ maybeDiv Header [class [CardCss.CardItem, CardCss.CardHeader]] headerView
                 , maybeDiv Image [class [CardCss.CardItem, CardCss.CardImage]] imageView
                 , (Just (\_->Html.div [] [])) 
                 , maybeDiv Content [class [CardCss.CardItem, CardCss.CardContent]] contentView
                 , maybeDiv Footer [class [CardCss.CardItem, CardCss.CardFooter]] footerView                 
                 ]    
  in
    case mCardNode of
      Just cardNode ->
        cardNode model.data
      Nothing->
        Html.div
          []
          []
