module Table.View exposing (..)

import Table.Models exposing (..)
import Table.Messages exposing (..)
import Html exposing (Html)
import Mdl.Table.Model as Table
import Mdl.Table.View as TableView

import Helpers.HtmlNode

view : Model -> Html Message
view model =
  let
    div  = Helpers.HtmlNode.apply Html.div Helpers.HtmlNode.initialSummary
    mdl = "https://code.getmdl.io/1.2.1/material.brown-orange.min.css"
    icons = "https://fonts.googleapis.com/icon?family=Material+Icons"
    config = TableView.Config
                [ Table.Column "name" (Table.AlphaNumeric .name)
                , Table.Column "age" (Table.Integer (\x->x.age))
                , Table.Column "adresse" (Table.AlphaNumeric .adresse)
                ]
             exact
             "mdl-data-table mdl-shadow--2dp"
             "mdl-data-table__cell--non-numeric"
             "mdl-data-table__header--sorted-ascending"
             "mdl-data-table__header--sorted-descending"
             "is-selected" 
  in
    div
      [ Helpers.HtmlNode.stylesheet mdl
      , Helpers.HtmlNode.stylesheet icons
      , div
          [           
           Html.map Table (TableView.view config model.list model.table)
          ]
      ]
