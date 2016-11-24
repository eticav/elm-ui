module List.Messages exposing (..)

import Mdl.List.Messages as MdlList
import List.Models as Models

type Message = List (MdlList.Message Models.Person)
