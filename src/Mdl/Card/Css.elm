module Mdl.Card.Css exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li, img)
import Css.Namespace exposing (namespace)
import Html.CssHelpers
import Html exposing (Html)

type CssClasses
    = Card
    | CardItem
    | CardContent
    | CardImage
    | CardHeader
    | CardFooter
    | CardSplitter
    | CardGrid
      
type CssIds
    = Page

prefProp1 : String->{a|value:String}->Maybe String->Mixin
prefProp1 key arg prefix =
    Maybe.map (\pf->property (pf++key) arg.value) prefix
      |> Maybe.withDefault (property key arg.value)
 
prefFlexDirection : {a|value:String}->Maybe String->Mixin
prefFlexDirection  =
  prefProp1 "flex-direction"
  
vendorsFlexDirection : {a|value:String}->Mixin
vendorsFlexDirection  value =
  mixin [ prefFlexDirection value Nothing
        , prefFlexDirection value (Just "-webkit-")
        , prefFlexDirection value (Just "-ms-")
        ]
    
vendorsDisplayFlex : Mixin
vendorsDisplayFlex =
  mixin [ displayFlex
        , property "display" "-webkit-flex"
        , property "display" "-ms-flexbox"
        ]

compiledStylesheet : Html msg
compiledStylesheet =
  let 
    {css, warnings} = Css.compile [cssDefinition]
  in
    Html.CssHelpers.style css

cssDefinition : Stylesheet
cssDefinition =
  let
    radiusSize = px 2
    cardWidth = 200
    cardHeight = 200
    itemHeight = 40
    imageHeight = cardHeight-(itemHeight*3)
    bgColor = (rgba 10 10 74 0.1)
    splitterColor = (rgba 0 0 0 0.1)
  in
    (stylesheet << namespace "powet")
      
      [ (.) CardGrid
          [ vendorsDisplayFlex
          , vendorsFlexDirection row
          ]
      , (.) Card
          [ boxShadow5 (px 1) (px 1) (px 10) (px 1)(rgba 0 0 0 0.53)
          , color (rgb 74 74 74)
          , width  (px cardWidth)
          , height (px cardHeight)
          , borderRadius (radiusSize)
          , vendorsDisplayFlex
          , vendorsFlexDirection column
          , alignItems stretch
          , flex (int 1)
          ]
      , (.) CardItem
          [ backgroundColor bgColor
          , position relative
          , width  auto
          , height auto
          , minHeight (px itemHeight)
          , borderTop3 (px 1) solid splitterColor
          , firstOfType [ borderRadius4 radiusSize radiusSize (px 0) (px 0)
                        , borderTop (px 0)
                        ]
          , lastOfType [ borderRadius4 (px 0) (px 0) radiusSize radiusSize
                       ]          
          ]             
      , (.) CardHeader
          [ flex (int 0)                 
          ]
      , (.) CardContent
          [ flex (int 1)
          ]
      , (.) CardFooter
          [ flex (int 0)
          ]
      , (.) CardImage
          [ minHeight (px imageHeight)
          , vendorsDisplayFlex
          , vendorsFlexDirection row
          , property "z-index" "-1"
          , property "align-items" "center"
          , property "justify-content" "center"
          , overflow hidden
          , flex (int 1)
          , firstOfType [ children [ img [ borderRadius4 radiusSize radiusSize (px 0) (px 0)
                                         ]
                                   ]                    
                        ]
          , lastOfType [ children [ img [ borderRadius4 (px 0) (px 0) radiusSize radiusSize
                                        ]
                                  ]                    
                       ]
          , children [ img [ width (pct 100)
                           , height (pct 100)
              
                           ]
                     ]
          ]
      ]
      
