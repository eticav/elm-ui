module List.View exposing (..)

import List.Models exposing (..)
import List.Messages exposing (..)
import Html exposing (Html)
import Mdl.List.Model as MdlList
import Mdl.List.View as ListView

import Helpers.HtmlNode

view : Model -> Html Message
view model =
  let
    div  = Helpers.HtmlNode.apply Html.div Helpers.HtmlNode.initialSummary
    mdl = "https://code.getmdl.io/1.2.1/material.brown-orange.min.css"
    icons = "https://fonts.googleapis.com/icon?family=Material+Icons"
    primaryContent = MdlList.Fields "name" (MdlList.AlphaNumeric .name)
    primarySub = MdlList.Fields "name" (MdlList.AlphaNumeric .name)
    icon = MdlList.Fields "icon" (MdlList.AlphaNumeric (\x->"person"))
    secondaryIcon = MdlList.Fields "tel" (MdlList.AlphaNumeric (\x->"telephone"))
    secondaryInfo = MdlList.Fields "info" (MdlList.AlphaNumeric .name)
    config = (ListView.config
             primaryContent)
            |> ListView.setPrimaryIcon icon
            |> ListView.setPrimarySub primarySub       
            |> ListView.setSecondaryIcon secondaryIcon
            |> ListView.setSecondaryInfo secondaryInfo               
  in
    div
      [ Helpers.HtmlNode.stylesheet mdl
      , Helpers.HtmlNode.stylesheet icons
      , div
          [           
           Html.map List (ListView.view config model.list model.table)
          ]
      ]
