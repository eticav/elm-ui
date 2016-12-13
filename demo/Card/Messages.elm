module Card.Messages exposing (..)

import Mdl.Card.Messages as MdlCard
import Card.Models as Models

type Message header image content footer =
  Card (MdlCard.Message header image content footer)


