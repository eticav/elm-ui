module SplittedPanes.Messages exposing (..)

import Mdl.SplittedPanes.Messages as SplittedPanes
import SplittedPanes.Models as Models

type PrimaryMessage = PrimaryMessage
type SecondaryMessage = SecondaryMessage

type Message = SplittedPanes (SplittedPanes.Message PrimaryMessage SecondaryMessage)


