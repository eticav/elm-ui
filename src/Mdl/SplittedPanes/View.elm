module Mdl.SplittedPanes.View exposing (..)

import Mdl.SplittedPanes.Models exposing (Model,Splitter,Orientation(..))
import Mdl.SplittedPanes.Messages exposing (Message(..))
import MouseEvents

import Html exposing (Html,div,text,button, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Json

type alias Config = { headerCls : String
                    , primaryCls : String
                    , secondaryCls : String
                    , splitterCls : String
                    , splitterSize : Float                  
                    }

view : Config->
       (primaryModel->Html primaryMsg)->
       (secondaryModel->Html secondaryMsg)->
       Model primaryModel secondaryModel -> Html (Message primaryMsg secondaryMsg)
view config primaryView secondaryView model =
  container config model
    [ header config model [Html.text "f"]
    , content config model
        [ pane config.primaryCls config model model.splitter.primaryRatio
            [ Html.map Primary (primaryView model.primary) ] 
        , splitter config model []
        , pane config.secondaryCls config model model.splitter.secondaryRatio
            [ Html.map Secondary (secondaryView model.secondary) ]
        ]          
    ]

container : Config->Model primaryModel secondaryModel->List (Html (Message primaryMsg secondaryMsg))->Html (Message primaryMsg secondaryMsg)
container config model =
  let
    commonStyles = [ ( "display", "flex" )
                   , ( "display", "-webkit-flex" )
                   , ( "height", "100%" )
                   , ( "height", "100vh" )
                   , ("flex-direction", "column")
                   , ("-webkit-flex-direction", "column")
                   ]
    styles = case model.orientation of
               Horizontal -> commonStyles
               Vertical -> ( "width", "100%" ) :: commonStyles
  in
    Html.div [ Attributes.style styles ]

header : Config->Model primaryModel secondaryModel->List (Html (Message primaryMsg secondaryMsg))->Html (Message primaryMsg secondaryMsg)
header config model =
  Html.div [ Attributes.style [ ("flex","1")
                              , ("-web-kit-flex","1")
                              ]
           , Attributes.class config.headerCls
           ]

content : Config->Model primaryModel secondaryModel->List (Html (Message primaryMsg secondaryMsg))->Html (Message primaryMsg secondaryMsg)
content config model =
  let
    orientation = case model.orientation of
                    Vertical -> "row"
                    Horizontal -> "column"
    styles = Attributes.style [ ("flex","2")
                              , ("-web-kit-flex","2")
                              , ("display", "flex" )
                              , ("display", "-webkit-flex" )
                              , ("flex-direction", orientation)
                              , ("-webkit-flex-direction", orientation)
                              ]
  in
    case model.splitter.resizing of
      True->
        Html.div
              [ styles
              , MouseEvents.onMouseMove Move
              , MouseEvents.onMouseUp MouseUp
              ]
      False->
        Html.div
              [ styles
              ]
  
pane : String->Config->Model primaryModel secondaryModel->Int->List (Html (Message primaryMsg secondaryMsg))->Html (Message primaryMsg secondaryMsg)
pane class config model ratio =
  let 
    styles = case model.orientation of
               Horizontal ->
                 Attributes.style [ ("flex-grow", toString ratio)
                                  , ("-web-kit-flex-grow", toString ratio)                                  
                                  , ("flex-basis", "0px")
                                  , ("-web-kit-flex-basis", "0px")
                                  , ("overflow-y","scroll")
                                  , ("height", "100%")
                                  , ("boxSizing", "border-box")
                                  ]
               Vertical ->
                 Attributes.style [ ("flex-grow", toString ratio)
                                  , ("-web-kit-flex-grow", toString ratio)                                  
                                  , ("flex-basis", "0px")
                                  , ("-web-kit-flex-basis", "0px")
                                  , ("overflow-x","scroll")
                                  , ("width", "100%")                                      
                                  , ("boxSizing", "border-box")                                  
                                  ]
  in
    Html.div [ styles
             , Attributes.class class
             ]

splitter : Config->Model primaryModel secondaryModel->List (Html (Message primaryMsg secondaryMsg))-> Html (Message primaryMsg secondaryMsg)
splitter config model =
  let
    size = (toString (2*config.splitterSize)) ++ "px"
    styles = case model.orientation of
               Horizontal ->
                 Attributes.style  [ ( "height", size )
                                   , ( "min-height", size )
                                   , ( "max-height", size )
                                   , ( "cursor", "row-resize" )
                                   , ("overflow","hidden")
                                   , ("flex", toString (2*config.splitterSize))
                                   , ("-web-kit-flex", toString (2*config.splitterSize))
                                   , ("backgroundColor","lightgrey")
                                   ]
               Vertical ->
                 Attributes.style  [ ( "width", size )
                                   , ( "min-width", size )
                                   , ( "max-width", size )
                                   , ( "cursor", "col-resize" )
                                   , ("overflow","hidden")
                                   , ("flex", toString (2*config.splitterSize))
                                   , ("-web-kit-flex", toString (2*config.splitterSize))
                                   , ("background-color","rgb(121,85,72)")
                                   , ("boxSizing", "border-box")                                  
                                   ]
  in
    case model.splitter.resizing of
      True->
        Html.div
              [ styles
              , Attributes.class config.splitterCls
              ]
      False->
        Html.div
              [ styles
              , Attributes.class config.splitterCls
              , MouseEvents.onMouseDown MouseDown
              ]
