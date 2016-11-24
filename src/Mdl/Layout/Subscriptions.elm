module Mdl.Layout.Subscriptions exposing ( subscriptions
                                         , content
                                         , drawer
                                         , subscriber
                                         )

{-| Layout subscriptions functions

@docs subscriptions, content, drawer, subscriber


-}

import Platform.Sub as Sub
import Mdl.Layout.Message exposing (Message(..))
import Mdl.Layout.Models exposing (Model)

type alias Subscription contentMsg contentModel drawerMsg drawerModel =
  { contentSub : Maybe (contentModel->Sub contentMsg)
  , drawerSub : Maybe (drawerModel->Sub drawerMsg)
  }

{-| subscriber function
-}
subscriber : Subscription contentMsg contentModel drawerMsg drawerModel
subscriber =
  { contentSub = Nothing
  , drawerSub = Nothing
  }

{-| drawer function
-}
drawer : (drawerModel->Sub drawerMsg)->
         Subscription contentMsg contentModel drawerMsg drawerModel->
         Subscription contentMsg contentModel drawerMsg drawerModel
drawer drawerSub subscriber =
  { subscriber| drawerSub = Just drawerSub}

{-| content function
-}
content : (contentModel->Sub contentMsg)->
         Subscription contentMsg contentModel drawerMsg drawerModel->
         Subscription contentMsg contentModel drawerMsg drawerModel
content contentSub subscriber =
  { subscriber| contentSub = Just contentSub}

{-| subscriptions function
-}
subscriptions : Model contentModel drawerModel->
                Subscription contentMsg contentModel drawerMsg drawerModel->
                Sub (Message contentMsg drawerMsg)
subscriptions model subscription= 
  let
    
    drawerSub = Maybe.map2 (\sub drawer->Sub.map Drawer (sub drawer)) subscription.drawerSub model.drawer
                |> Maybe.withDefault Sub.none
                   
    contentSub = Maybe.map (\sub->Sub.map Content (sub model.content)) subscription.contentSub
                |> Maybe.withDefault Sub.none
  in
    Sub.batch [ drawerSub
              , contentSub
              ]
