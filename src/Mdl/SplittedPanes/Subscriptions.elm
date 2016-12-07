module Mdl.SplittedPanes.Subscriptions exposing (..)

import Platform.Sub as Sub
import Mdl.SplittedPanes.Messages exposing (Message(..))
import Mdl.SplittedPanes.Models exposing (Model)

type alias Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel =
  { headerSub : Maybe (headerModel->Sub headerMsg)
  , primarySub : Maybe (primaryModel->Sub primaryMsg)
  , secondarySub : Maybe (secondaryModel->Sub secondaryMsg)
  }

subscriber : Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel
subscriber =
  { headerSub = Nothing
  , primarySub = Nothing
  , secondarySub = Nothing
  }

header : (headerModel->Sub headerMsg)->
         Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel->
         Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel
header headerSub subscriber =
  { subscriber| headerSub = Just headerSub}

primary : (primaryModel->Sub primaryMsg)->
         Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel->
         Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel
primary primarySub subscriber =
  { subscriber| primarySub = Just primarySub}

secondary : (secondaryModel->Sub secondaryMsg)->
         Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel->
         Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel
secondary secondarySub subscriber =
  { subscriber| secondarySub = Just secondarySub}

subscriptions : Model headerModel primaryModel secondaryModel->
                Subscription headerMsg headerModel primaryMsg primaryModel secondaryMsg secondaryModel->
                Sub (Message headerMsg primaryMsg secondaryMsg)
subscriptions model subscription= 
  let
    headerSub =
      Maybe.map (\sub->Sub.map Header (sub model.header)) subscription.headerSub
        |> Maybe.withDefault Sub.none
           
    primarySub =
      Maybe.map (\sub->Sub.map Primary (sub model.primary)) subscription.primarySub
        |> Maybe.withDefault Sub.none
           
    secondarySub =
      Maybe.map (\sub->Sub.map Secondary (sub model.secondary)) subscription.secondarySub
        |> Maybe.withDefault Sub.none                   
  in
    Sub.batch [ headerSub
              , primarySub
              , secondarySub
              ]
