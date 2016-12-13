module Mdl.Card.Messages exposing (..)

type Message header image content footer = Header header
                                         | Image image
                                         | Content content
                                         | Footer footer                                                                                               
