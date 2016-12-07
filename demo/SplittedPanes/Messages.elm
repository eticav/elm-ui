module SplittedPanes.Messages exposing (..)

import Mdl.SplittedPanes.Messages as SplittedPanes
import SplittedPanes.Models as Models

type HeaderMessage = HeaderMessage
type PrimaryMessage = PrimaryMessage
type SecondaryMessage = SecondaryMessage

type Message = SplittedPanes (SplittedPanes.Message HeaderMessage PrimaryMessage SecondaryMessage)


