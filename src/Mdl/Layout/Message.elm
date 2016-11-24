module Mdl.Layout.Message exposing (..)

type Message contentMsg drawerMsg = Content contentMsg
                                  | Drawer drawerMsg
                                  | ScrollContent Float
                                  | ToggleDrawer



