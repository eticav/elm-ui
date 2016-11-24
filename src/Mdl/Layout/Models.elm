module Mdl.Layout.Models exposing (..)

type alias Navigation = { label : String
  }

type alias NoModel = ()

noUpdate : msg->model ->(model, Cmd msg)
noUpdate msg model = (model, Cmd.none)

type alias Model contentModel drawerModel = { content: contentModel
                                            , drawer : Maybe drawerModel
                                            , navs : List Navigation
                                            , config : Config
                                            }
type Mode = Standard
          | Seamed
          | Scrolling
          | Waterfall Bool
            
type alias State  = { isScrolled : Bool
                    , isDrawerOpen : Bool
                    }



initialState : State
initialState = { isScrolled = False
               , isDrawerOpen = False
               }

initialMode : Mode
initialMode = Waterfall True

type alias Config = { mode : Mode
                    , state : State
                    , title : Maybe String
                    }
                  
initialConfig : Config
initialConfig = { mode = initialMode
                , state = initialState
                , title = Nothing
                }
                  
initialModel : contentModel-> Model contentModel drawerModel
initialModel initialContentModel = { content = initialContentModel
                                   , drawer = Nothing--Just (div [] [text "hell"])
                                   , navs = []
                                   , config = initialConfig  
                                   }

  
addNavigation : String -> Model contentModel drawerModel -> Model contentModel drawerModel
addNavigation str model =
 {model | navs=(Navigation str)::model.navs}


  
onStateSet : (val->State->State)->val->Model contentModel drawerModel->Model contentModel drawerModel
onStateSet f val model =
  let
    state = model.config.state
    config = model.config
    updatedState = f val state
    updatedConfig = {config| state = updatedState} 
  in
    {model|config=updatedConfig}

onConfigSet : (val->Config->Config)->val->Model contentModel drawerModel->Model contentModel drawerModel
onConfigSet f val model =
    {model|config=f val model.config}

      
setDrawer : Maybe drawerModel -> Model contentModel drawerModel -> Model contentModel drawerModel
setDrawer drawer model =
  {model | drawer=drawer}

    
setIsScrolled : Bool->Model contentModel drawerModel->Model contentModel drawerModel
setIsScrolled val model =
  onStateSet (\val state->{state|isScrolled = val}) val model

setIsDrawerOpen : Bool->Model contentModel drawerModel->Model contentModel drawerModel
setIsDrawerOpen val model =
  onStateSet (\val state->{state|isDrawerOpen = val}) val model             

setTitle : String->Model contentModel drawerModel->Model contentModel drawerModel
setTitle title model =
  onConfigSet (\x config->{config|title=Just title}) title model         
  
isCompact : Model contentModel drawerModel-> Bool
isCompact model =
  model.config.state.isScrolled

isDrawerOpen : Model contentModel drawerModel-> Bool
isDrawerOpen model =
  model.config.state.isDrawerOpen
  
isCastingShadow : Model contentModel drawerModel-> Bool
isCastingShadow model =
  case (model.config.mode, isCompact model)  of
    (Standard, _)->True
    (Seamed, _) ->False
    (Scrolling, _)->False
    (Waterfall bool, True)->False
    (Waterfall bool, False)-> True
                              
isScrollable : Model contentModel drawerModel->Bool
isScrollable model =
  case model.config.mode of
    Waterfall _ -> True
    _ -> False         
