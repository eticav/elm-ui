module HelpersList exposing (..)

functionCons : (x->z->z)->(m->x)->(m->z)->m->z
functionCons cons fun acc m =
  cons (fun m) (acc m)

functionFilterCons : (x->z->z)->(m->z)->Maybe (m->x)->Maybe(m->z)->Maybe(m->z)
functionFilterCons cons default mf mAcc =
  let        
    construct : (m->x)->Maybe(m->z)->Maybe (m->z)
    construct fun mAcc =
      case  mAcc of
        Nothing-> Just (functionCons cons fun default)
        Just acc-> Just (functionCons cons fun acc)
  in
    case mf of
      Nothing->mAcc
      Just fun->construct fun mAcc
  
functionFilterMap : List(Maybe (m-> x))->Maybe (m->List x)
functionFilterMap list =
  List.foldr (functionFilterCons (::) (\_->[]) ) Nothing list

functionFilterFold : (List x->x)->
             List (Maybe (m->x))->
             Maybe (m->x)
functionFilterFold fold list =
  case functionFilterMap list of
    Nothing-> Nothing
    Just f -> Just (fold << f)

foldFunctions : (List x->x)->
                List (m->x)->
                (m->x)
foldFunctions node list =
  let
    makeList : List (m->x)->m->List x
    makeList list model = List.map (\f->f model) list

    makeNode : List (m->x)->m->x
    makeNode list model = node ((makeList list) model)
  in
    makeNode list
