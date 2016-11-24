module Helpers.HtmlNode exposing (..)

import Html.Events
import Html.Attributes exposing (..)
import Html exposing (label,input,div,text,Html,Attribute)
import Json.Decode as Json



type alias Summary msg = 
  { classes : List (String,Bool)
  , attributes : List (Html.Attribute msg)
  }

stylesheet : String -> Html msg
stylesheet href=
  let
    attrs =
      [ Html.Attributes.attribute "rel" "stylesheet"
      , Html.Attributes.attribute "href" href
      ]
  in 
    Html.node "link" attrs []

initialSummary : Summary msg
initialSummary =
  { classes = []
  , attributes = []
  }

addClass : String->Bool->Summary msg->Summary msg
addClass class trigger sumy =
  {sumy|classes = (class,trigger)::sumy.classes}

addAttribute : Html.Attribute msg ->Summary msg->Summary msg
addAttribute attr sumy =
  {sumy|attributes = attr::sumy.attributes}

addAttributes : List (Html.Attribute msg) ->Summary msg->Summary msg
addAttributes attrs sumy = 
  {sumy|attributes = List.concat [attrs, sumy.attributes]}

onClick : msg->Summary msg->Summary msg
onClick msg sumy =
  addAttribute (Html.Events.onClick msg) sumy

tabIndex : Int->Summary msg->Summary msg
tabIndex val sumy =  
  addAttribute (Html.Attributes.tabindex val) sumy

role : String->Summary msg->Summary msg
role role sumy =
  addAttribute (Html.Attributes.attribute "role" role) sumy

style : List (String, String)->Summary msg->Summary msg
style styles sumy =
  addAttribute (Html.Attributes.style styles) sumy
  
onInput : (String->msg)->Summary msg->Summary msg
onInput msg sumy =
  addAttribute (Html.Events.onInput msg) sumy

id : String->Summary msg->Summary msg
id str sumy =
  addAttribute (Html.Attributes.id str) sumy

value : (Maybe String)->Summary msg->Summary msg
value str sumy =
  let
    add x = addAttribute (Html.Attributes.value x) sumy
  in 
    Maybe.map add str
      |> Maybe.withDefault sumy

for : String->Summary msg->Summary msg
for str sumy =
  addAttribute (Html.Attributes.for str) sumy

href : String->Summary msg->Summary msg
href str sumy =
  addAttribute (Html.Attributes.href str) sumy

disabled : Bool->Summary msg->Summary msg
disabled val sumy =
  addAttribute (Html.Attributes.disabled val) sumy
  
autofocus : Bool->Summary msg->Summary msg
autofocus val sumy =
  addAttribute (Html.Attributes.autofocus val) sumy

ariaExpanded : Bool->Summary msg->Summary msg
ariaExpanded val sumy =
  addAttribute (attribute "aria-expanded" (toString val)) sumy

ariaHidden : Bool->Summary msg->Summary msg
ariaHidden val sumy =
  addAttribute (attribute "aria-hidden" (toString val)) sumy

rows : Maybe Int->Summary msg->Summary msg
rows val sumy =
  case val of
    Just x->addAttribute (Html.Attributes.rows x) sumy
    Nothing-> sumy
            
cols : Maybe Int->Summary msg->Summary msg
cols val sumy =
  case val of
    Just x ->addAttribute (Html.Attributes.cols x) sumy
    Nothing-> sumy  
  
onFocus : msg->Summary msg->Summary msg
onFocus msg sumy =
  addAttribute (Html.Events.onFocus msg) sumy

onScroll : (Float -> msg) ->Bool->Summary msg->Summary msg
onScroll msg trigger sumy =
  case trigger of
    True ->  addAttribute (onScroll2 msg) sumy
    False -> sumy

onScroll2 : (Float -> msg) -> Attribute msg
onScroll2 tagger =
  Html.Events.on "scroll" (Json.map tagger targetScrollTop)
      
onBlur : msg->Summary msg->Summary msg
onBlur msg sumy =
  addAttribute (Html.Events.onBlur msg) sumy
  
apply :(List (Html.Attribute msg) -> List (Html msg) -> Html msg) ->(Summary msg) ->(List (Html msg) -> Html msg)
apply node sumy =
  let
    attrs = List.concat [[classList sumy.classes], sumy.attributes]
  in
    node attrs

targetScrollTop : Json.Decoder Float
targetScrollTop =
  Json.at ["target", "scrollTop"] Json.float


nothing : Html a
nothing =
  Html.node "noscript" [] []
