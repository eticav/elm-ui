module Mdl.SplittedPanes.Subscriptions exposing (..)

import Platform.Sub as Sub
import Mdl.SplittedPanes.Messages exposing (Message(..))
import Mdl.SplittedPanes.Models exposing (Model)

type alias Subscription primaryMsg primaryModel secondaryMsg secondaryModel =
  { primarySub : Maybe (primaryModel->Sub primaryMsg)
  , secondarySub : Maybe (secondaryModel->Sub secondaryMsg)
  }

{-| subscriber function
-}
subscriber : Subscription primaryMsg primaryModel secondaryMsg secondaryModel
subscriber =
  { primarySub = Nothing
  , secondarySub = Nothing
  }

{-| secondary function
-}
secondary : (secondaryModel->Sub secondaryMsg)->
         Subscription primaryMsg primaryModel secondaryMsg secondaryModel->
         Subscription primaryMsg primaryModel secondaryMsg secondaryModel
secondary secondarySub subscriber =
  { subscriber| secondarySub = Just secondarySub}

{-| primary function
-}
primary : (primaryModel->Sub primaryMsg)->
         Subscription primaryMsg primaryModel secondaryMsg secondaryModel->
         Subscription primaryMsg primaryModel secondaryMsg secondaryModel
primary primarySub subscriber =
  { subscriber| primarySub = Just primarySub}

{-| subscriptions function
-}
subscriptions : Model primaryModel secondaryModel->
                Subscription primaryMsg primaryModel secondaryMsg secondaryModel->
                Sub (Message primaryMsg secondaryMsg)
subscriptions model subscription= 
  let
    primarySub =
      Maybe.map (\sub->Sub.map Primary (sub model.primary)) subscription.primarySub
        |> Maybe.withDefault Sub.none
           
    secondarySub =
      Maybe.map (\sub->Sub.map Secondary (sub model.secondary)) subscription.secondarySub
        |> Maybe.withDefault Sub.none                   
  in
    Sub.batch [ secondarySub
              , primarySub
              ]
