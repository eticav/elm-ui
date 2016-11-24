module Mdl.Icon exposing (..)

import Helpers.HtmlNode as HtmlNode exposing (..)
import Html exposing (Html)

view : String-> HtmlNode.Summary m -> Html m
view name summary =
  let
    yo = summary
       |> addClass "material-icons" True
       |> apply Html.i
  in
    yo [Html.text name]

i : String -> Html m
i name = view name HtmlNode.initialSummary


                                           
