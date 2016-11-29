module Mdl.Table.Messages exposing (..)

import Mdl.Table.Model exposing (Column)

type Message data = Sort (Column data)
                  | Current data

type OutMessage data = OutCurrent data
                     | OutNothing
