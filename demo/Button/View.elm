module Button.View exposing (..)

import Button.Models exposing (..)
import Button.Messages exposing (..)
import Html exposing (Html)
import Mdl.Button.Model as MdlButton
import Mdl.Button.View as ButtonView

import Helpers.HtmlNode

view : Model -> Html Message
view model =
  let
    div  = Helpers.HtmlNode.apply Html.div Helpers.HtmlNode.initialSummary
    mdl = "https://code.getmdl.io/1.2.1/material.brown-orange.min.css"
    icons = "https://fonts.googleapis.com/icon?family=Material+Icons"
    config = ButtonView.mdlButtonConfig
            
  in
    div
      [ Helpers.HtmlNode.stylesheet mdl
      , Helpers.HtmlNode.stylesheet icons
      , div
          [           
           Html.map Button (ButtonView.view config "person" model.button)
          ]
      ]
