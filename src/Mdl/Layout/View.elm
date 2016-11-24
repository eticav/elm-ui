module Mdl.Layout.View exposing (..)

import Helpers.HtmlNode as HtmlNode exposing (..)
import Html exposing (label,input,div,text,Html,Attribute)
import Helpers.ComponentCom exposing (..)
import Mdl.Icon as Icon
import Mdl.Layout.Models as Models exposing (Model, Mode(..))
import Mdl.Layout.Message exposing (Message(..))

navigationNode : Model contentModel drawerModel-> Html (Message contentMsg drawerMsg)        
navigationNode model =
  let
    navItem nav = (initialSummary
                |> addClass "mdl-navigation__link" True
                |> href "javascript:void(0);"
                |> apply Html.a)
               [text nav.label]
  in 
    (initialSummary
    |> addClass "mdl-navigation" True
    |> apply Html.nav)
    (List.map navItem model.navs) 
    
layoutNode model =
  let
    layoutContainerNode x = (initialSummary
                 |> addClass "mdl-layout__container" True
                 |> apply Html.div) [x]
                    
    layout = initialSummary
           |> addClass "mdl-layout" True
           |> addClass "mdl-js-layout" True
           |> addClass "mdl-layout--fixed-header" True
           |> apply Html.div
  in
    layoutContainerNode << layout
                    
headerNode model = initialSummary
                 |> addClass "mdl-layout__header" True
                 |> addClass "mdl-layout__header--scroll" (model.config.mode == Scrolling)
                 |> addClass "mdl-layout__header--seamed" (model.config.mode == Seamed) -- header without shadow
                 |> addClass "mdl-layout__header--waterfall" (model.config.mode == Waterfall True)
                 |> addClass "mdl-layout__header--waterfall-hide-top" (model.config.mode == Waterfall False)
                 |> addClass "is-casting-shadow" (Models.isCastingShadow model) -- show shadow
                 --|> addClass "is-animating" False --?
                 |> addClass "is-compact" (Models.isCompact model) -- petit header
                 |> addClass "mdl-layout__header--transparent" False --header disparait
                 |> addClass "transitionend" False
                 |> apply Html.header

drawerButton model = (initialSummary
                     |> addClass "mdl-layout__drawer-button" True
                     |> ariaExpanded (Models.isDrawerOpen model)
                     |> role "button"
                     |> tabIndex 0
                     |> onClick ToggleDrawer
                     |> apply Html.div)                     
                     [ Icon.i "menu" ]
                       
obfuscatorNode model = initialSummary
                     |> addClass "is-visible" (Models.isDrawerOpen model)
                     |> addClass "mdl-layout__obfuscator" True                     
                     |> onClick ToggleDrawer
                     |> apply Html.div

drawerNode model dreawerView =
  case model.drawer of
    Just drawer->(initialSummary
                 |> addClass "mdl-layout__drawer" True
                 |> addClass "is-visible" (Models.isDrawerOpen model)
                 |> ariaHidden (not (Models.isDrawerOpen model))
                 |> apply Html.div)
                 [Html.map Drawer (dreawerView drawer)]
    Nothing-> nothing
                              
iconNode model = initialSummary
               |> addClass "mdl-layout-icon" True
               |> apply Html.div

topHeaderRowNode model = initialSummary
                       |> addClass "mdl-layout__header-row" True
                       |> apply Html.div
                          
titleNode model = (initialSummary
                |> addClass "mdl-layout-title" True
                |> apply Html.span)
            ( Maybe.map (\x->[text x]) model.config.title
            |> Maybe.withDefault []
            )
                 
spacerNode model = initialSummary
                 |> addClass "mdl-layout-spacer" True
                 |> apply Html.div

lowerHeaderRowNode model = initialSummary
                         |> addClass "mdl-layout__header-row" True
                         |> apply Html.div
                         
view : Model contentModel drawerModel->
       (contentModel -> Html contentMsg)->
       (drawerModel -> Html drawerMsg)->
        Html (Message contentMsg drawerMsg)             
view model contentView drawerView =
  let
    mainNode model = initialSummary
                   |> addClass "mdl-layout__content" True
                   |> onScroll ScrollContent (Models.isScrollable model)
                   |> apply Html.span
  in           
    layoutNode model
      [  headerNode model
           [ --iconNode model [text "ICON"]
             drawerButton model
           , topHeaderRowNode model
               [ titleNode model
               , spacerNode model []
               ]
           , lowerHeaderRowNode model
               [
                spacerNode model []
               , navigationNode model 
               ]
           , obfuscatorNode model []
           ]
      , drawerNode model drawerView
      , mainNode model
           [ Html.map Content (contentView model.content)]
      ]


