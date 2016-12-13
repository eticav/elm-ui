module Mdl.Card.Css exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li, img)
import Css.Namespace exposing (namespace)


type CssClasses
    = Card
    | CardItem
    | CardContent
    | CardImage
    | CardHeader
    | CardFooter
    | CardSplitter
      
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
  
css =
  let
    radiusSize = px 5
    cardWidth = px 200
    cardHeight = 302
    itemHeight = 40
    imageHeight = cardHeight-(itemHeight*3)
  in
    (stylesheet << namespace "powet")
      [ (.) Card
          [ boxShadow5 (px 4) (px 4) (px 8) (px 1)(rgba 0 0 0 0.53)
          , color (rgb 74 74 74)
          , width  cardWidth
          , height (px cardHeight)
          , borderRadius (px 5)
          , vendorsDisplayFlex
          , vendorsFlexDirection column
          , alignItems stretch            
          ]
      , (.) CardItem
          [ position relative
          , width  auto 
          , height auto
          , minHeight (px itemHeight)
          , firstOfType [ borderRadius4 radiusSize radiusSize (px 0) (px 0)
                        ]
          , lastOfType [ borderRadius4 (px 0) (px 0) radiusSize radiusSize
                       ] 
          ]             
      , (.) CardHeader
          [ backgroundColor (rgb 30 10 30)
          ]
      , (.) CardContent
          [ backgroundColor (rgb 10 10 74)
          --, maxHeight (px 500)
          ]
      , (.) CardFooter
          [ backgroundColor (rgb 30 10 30)
          ]
      , (.) CardSplitter
          [ backgroundColor (rgb 211 211 211)
          , minHeight (px 10)
          , width  auto 
          ]        
      , (.) CardImage
          [ backgroundColor (rgb 0 0 0 )
          , minHeight (px imageHeight)
          , maxHeight (px imageHeight)
          , vendorsDisplayFlex
          , vendorsFlexDirection row
          , property "z-index" "-1"
          , property "align-items" "center"
          , property "justify-content" "center"
          , overflow hidden
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
                           , flex (int 1)
                           ]
                     ]
          ]
      ]
      
