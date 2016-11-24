module Layout.View exposing (..)

import Layout.Models exposing (..)
import Layout.Messages exposing (..)
import Html exposing (Html)

import Helpers.HtmlNode
import Mdl.Layout.View as Layout

view : Model -> Html Message
view model =
  let
    div  = Helpers.HtmlNode.apply Html.div Helpers.HtmlNode.initialSummary
    mdl = "https://code.getmdl.io/1.2.1/material.brown-orange.min.css"
    icons = "https://fonts.googleapis.com/icon?family=Material+Icons"
  in
    div
      [ Helpers.HtmlNode.stylesheet mdl
      , Helpers.HtmlNode.stylesheet icons
      , div
          [ Html.map Layout ( Layout.view
                                model.layout
                                (\x->Html.div [][Html.text "content"])
                                (\x->Html.div [][Html.text "hey!"])
                                
                            )
          ]
      ]
