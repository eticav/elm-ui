module Table.Messages exposing (..)

import Mdl.Table.Messages as Table
import Table.Models as Models

type Message = Table (Table.Message Models.Person)
