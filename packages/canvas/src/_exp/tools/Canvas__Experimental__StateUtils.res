open Canvas__Experimental__Models

let getSelectionState: State.t => option<Selection.state> = state =>
  switch state {
  | Selection(state) => Some(state)
  | Rect(_) => None
  | Line(_) => None
  }

let getRectState: State.t => option<Rect.state> = state =>
  switch state {
  | Rect(state) => Some(state)
  | Selection(_) => None
  | Line(_) => None
  }

let getLineState: State.t => option<Line.state> = state =>
  switch state {
  | Line(state) => Some(state)
  | Selection(_) => None
  | Rect(_) => None
  }
