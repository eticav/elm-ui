module Card.Messages exposing (..)

import Mdl.Card.Messages as MdlCard
import Card.Models as Models

type ContentMessage = ContentClick String
                    
type Message header image footer =
  Card (MdlCard.Message header image ContentMessage footer)

type MessageOut = NoOutMsg
                | OutContentClick String
