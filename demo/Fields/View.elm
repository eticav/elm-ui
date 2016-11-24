module Fields.View exposing (..)

import Fields.Models exposing (..)
import Fields.Messages as Message exposing (..)
import Mdl.TextField.TextField as TextField
import Html exposing (Html)

import Helpers.HtmlNode

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
      , div [ Html.map Message.TextField (TextField.view model.textField)
            ]
      ]
