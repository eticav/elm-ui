module Layout.Models exposing (..)

import Fields.Models as Fields
import Mdl.Layout.Models as Layout

type alias Model  = { layout : Layout.Model Fields.Model  Layout.NoModel
                    }

initialModel : Model
initialModel = { layout =  Layout.initialModel  Fields.initialModel
                           |> Layout.setDrawer (Just ())
                           |> Layout.addNavigation "Link1"
                           |> Layout.addNavigation "Link2"
                           |> Layout.addNavigation "Link3"
               }
