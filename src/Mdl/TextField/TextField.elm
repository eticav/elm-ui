module Mdl.TextField.TextField exposing (..)

import Helpers.HtmlNode as HtmlNode exposing (..)
import Html exposing (label,input,div,text,Html,Attribute)
import Regex

type alias Model = { name : String
                   , label : Maybe String
                   , pattern : Maybe String
                   , errMsg : Maybe String
                   , defaultValue : Maybe String
                   , value : Maybe String
                   , kind : Kind
                   , isFocused : Bool               
                   , isDisabled : Bool
                   , isLabelFloat : Bool
                   , isAutofocus : Bool
                   }
                 
type Kind = SingleLine
          | MultiLine Int Int
            
patternFloat : String
patternFloat = "^[-+]?([0-9]*\\.[0-9]+|[0-9]+)$"
          
initialModel : Model
initialModel = { name = "1"
               , label = Just "Label"
               , pattern = Just patternFloat
               , errMsg = Nothing
               , defaultValue = Nothing
               , value = Nothing
               , kind = MultiLine 5 10
               , isFocused = False
               , isDisabled = False
               , isLabelFloat = True
               , isAutofocus= False
               }

type Message = Input String
             | Blur
             | Focus

type OutMessage = OutNothing
                | OutInput (Maybe String)
                | OutBlur (Maybe String)
                | OutFocus (Maybe String)

view : Model -> Html Message
view model =
  let
    divNode = initialSummary
              |> addClass "mdl-textfield" True
              |> addClass "mdl-js-textfield" True                 
              |> addClass "mdl-textfield--floating-label" model.isLabelFloat
              |> addClass "is-upgraded" True 
              |> addClass "is-focused" model.isFocused
              |> addClass "is-dirty" (isDirty model)
              |> addClass "is-disabled" model.isDisabled
              |> addClass "is-invalid" (not (isValid model))
              |> apply Html.div

    labelNode = initialSummary 
              |> addClass "mdl-textfield__label" True
              |> for "yam"
              |> apply Html.label
                 
    inputNode = initialSummary
              |> addClass "mdl-textfield__input" True
              |> id "yam"
              |> value model.value
              |> onInput Input
              |> onFocus Focus
              |> onBlur Blur
              |> autofocus model.isAutofocus
              |> disabled model.isDisabled
              |> HtmlNode.rows (rows model)
              |> HtmlNode.cols (cols model)
              |> apply (inputNodeKind model)
              
    errorNode = initialSummary
              |> addClass "mdl-textfield__error" True
              |> apply Html.span

                 
    labelText label = Maybe.map (\x-> [text x]) label
                    |> Maybe.withDefault [] 
  in
    divNode
      [ inputNode []
      , labelNode (labelText model.label)
      , errorNode (labelText model.errMsg)
      ]

update : Message -> Model -> (Model, Cmd Message, OutMessage)
update msg model =
  updateValue msg model
    |> updateFocused msg
    |> messageOut msg

  
updateValue : Message -> Model -> Model
updateValue msg model =
  case msg of
    Input str ->
      case str of
        "" -> {model|value=Nothing}
        _-> {model|value=Just str}
    _ -> model

updateFocused : Message -> Model -> Model
updateFocused msg model =
  case msg of
    Input str -> {model|isFocused=True}
    Blur ->  {model|isFocused=False}
    Focus -> {model|isFocused=True}

messageOut : Message -> Model -> (Model, Cmd Message, OutMessage)
messageOut msg model =
  case msg of
    Input _ -> (model, Cmd.none, OutInput model.value)
    Blur -> (model, Cmd.none, OutBlur model.value)
    Focus -> (model, Cmd.none, OutFocus model.value)
    
isDirty : Model -> Bool
isDirty model =
  case model.value of 
    Just _ -> True
    Nothing-> False

isValid : Model -> Bool
isValid model =
  case (model.pattern, model.value) of 
    (Just pattern, Just value) ->
      let 
        regex = Regex.regex pattern
        check x = Regex.contains regex x
      in
        check value
    (Just pattern, Nothing) -> True
    _-> True

rows : Model -> Maybe Int
rows model =
  case model.kind of 
    MultiLine rows cols-> Just rows
    _-> Nothing

cols : Model -> Maybe Int
cols model =
  case model.kind of 
    MultiLine rows cols-> Just cols
    _-> Nothing
    
inputNodeKind model a b =
  case model.kind of
    SingleLine-> Html.input  a b
    MultiLine _ _ -> Html.textarea a b

                     
    
