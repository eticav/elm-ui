module Mdl.Table.Messages exposing (..)

import Mdl.Table.Model exposing (Column)

type Message data = Sort (Column data)

