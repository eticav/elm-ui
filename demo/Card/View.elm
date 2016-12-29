module Card.View exposing (..)

import Card.Models exposing (..)
import Card.Messages exposing (..)
import Html exposing (Html)
import Html.Attributes as Attribute

import Mdl.Card.Models as MdlCard
import Mdl.Card.View as CardView
import Mdl.Card.Css as CardCss

import Helpers.HtmlNode
import Css exposing (..)

import Html.CssHelpers

viewImage : Person -> Html image
viewImage model =
  Html.img
      [ Attribute.src "http://68.media.tumblr.com/tumblr_llfl0zHJoG1qho7cqo1_500.jpg"
      ]
      [ ]
        
view : Model->Html (Message header image content footer)
view model =
  let    
    config = CardView.mdlCardConfig            
  in
    Html.body
          [ ]
          [ CardCss.compiledStylesheet
          , Html.div
              [ ]
              [ Html.map Card (CardView.view config
                                 Nothing--(Just (\m->Html.text "Header"))
                                 Nothing--(Just viewImage)                                 
                                 (Just (\m->Html.text "Content"))
                                 (Just (\m->Html.text "Footer"))
                                 model.card)
              ]
          ]
