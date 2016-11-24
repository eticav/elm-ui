module Layout.Messages exposing (..)

import Mdl.Layout.Message as Layout
import Fields.Messages as FieldsMessages

type Message = Layout (Layout.Message FieldsMessages.Message ())
