module SplittedPanes.View exposing (..)

import SplittedPanes.Models exposing (..)
import SplittedPanes.Messages exposing (..)
import Html exposing (Html)
import Mdl.SplittedPanes.Models as SplittedPanes
import Mdl.SplittedPanes.View as SplittedPanesView

import Helpers.HtmlNode

view : Model->Html (Message)
view model =
  let
    div  = Helpers.HtmlNode.apply Html.div Helpers.HtmlNode.initialSummary
    mdl = "https://code.getmdl.io/1.2.1/material.brown-orange.min.css"
    icons = "https://fonts.googleapis.com/icon?family=Material+Icons"
    config = SplittedPanesView.Config
             "headerCls"
             "primaryCls"
             "secondaryCls"
             "splitterCls"
             2.5
  in
    div
      [ Helpers.HtmlNode.stylesheet mdl
      , Helpers.HtmlNode.stylesheet icons
      , div
          [           
           Html.map SplittedPanes (SplittedPanesView.view config
                                     (\x->Html.div
                                        []
                                        [ Html.text "primary"
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]                                              
                                        ])
                                     (\x->Html.div
                                        []
                                        [ Html.text "primary"
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]
                                        , Html.div [] [Html.text "space"]                                              
                                        ])
                                     model.splittedPanes)
          ]
      ]


