module Mdl.SplittedPanes.Messages exposing (..)

import Json.Decode as Json

import MouseEvents exposing (MouseEvent)



type Message primaryMsg secondaryMsg = Primary primaryMsg
                                     | Secondary secondaryMsg
                                     | MouseDown MouseEvent
                                     | MouseUp MouseEvent
                                     | Move MouseEvent


