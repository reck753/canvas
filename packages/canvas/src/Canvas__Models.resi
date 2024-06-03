module Vec: {
  type t = {x: float, y: float}
}

module Size: {
  type t = {width: float, height: float}
}

module Element: {
  type t<'meta> = {
    id: string,
    toolId: string,
    zIndex: float,
    label: option<string>,
    metadata?: 'meta,
  }
}

module Rect: {
  type t<'meta> = {
    ...Element.t<'meta>,
    ...Vec.t,
    ...Size.t,
  }
  @tag("type")
  type state = Idle | Drawing
}

module Line: {
  type t<'meta> = {
    ...Element.t<'meta>,
    start: Vec.t,
    end: Vec.t,
  }
  @tag("type")
  type state = Idle | Drawing
}

@tag("type")
type element<'meta> = Line(Line.t<'meta>) | Rect(Rect.t<'meta>)

module Corner: {
  type t = Start | End | TopLeft | TopRight | BottomLeft | BottomRight | Top | Bottom | Left | Right
}

module Selection: {
  type t = {
    ...Vec.t,
    ...Size.t,
  }

  type move = {
    origin: Vec.t,
    target: Vec.t,
  }

  @tag("type")
  type state = Idle | Selecting(t) | Moving(move) | Resizing(Corner.t)
}

module State: {
  @tag("type")
  type t = Selection(Selection.state) | Rect(Rect.state) | Line(Line.state)
}

module Store: {
  @tag("type")
  type snapToGrid = No | Yes(float)
  @genType
  type t<'meta> = {
    state: State.t,
    snapToGrid: snapToGrid,
    selectedToolId: string,
    selectedElementIds: array<string>,
    elements: array<element<'meta>>,
  }
}

module Tool: {
  type sharedCallbackArguments<'tool, 'meta> = {
    clientX: float,
    clientY: float,
    store: Store.t<'meta>,
    updateStore: (Store.t<'meta> => Store.t<'meta>) => unit,
    target: Canvas__CanvasUtils.JsxEventFixed.Mouse.target,
    tools: array<'tool>,
  }
  type onStartArguments<'tool, 'meta> = {
    ...sharedCallbackArguments<'tool, 'meta>,
    nextIndex: float,
  }
  type onMoveArguments<'tool, 'meta> = {
    ...sharedCallbackArguments<'tool, 'meta>,
  }
  type onEndArguments<'tool, 'meta> = {
    ...sharedCallbackArguments<'tool, 'meta>,
  }
  type onDoubleClickArguments<'tool, 'meta> = {
    tools: array<'tool>,
    clickedElement: element<'meta>,
    store: Store.t<'meta>,
    updateStore: (Store.t<'meta> => Store.t<'meta>) => unit,
    target: Canvas__CanvasUtils.JsxEventFixed.Mouse.target,
  }
  @genType
  type style = {lineWidth?: float}
  type rectSettings = {...style, canResizeVertically?: bool, canResizeHorizontally?: bool}
  type lineSettings = {...style, canResizeStart?: bool, canResizeEnd?: bool}
  @tag("type")
  type engine =
    | Selection
    | Rect(rectSettings)
    | Line(lineSettings)
  @genType
  type rec t<'meta> = {
    toolId: string,
    engine: engine,
    onStart: onStartArguments<t<'meta>, 'meta> => unit,
    onMove: onMoveArguments<t<'meta>, 'meta> => unit,
    onEnd: onEndArguments<t<'meta>, 'meta> => unit,
    onDoubleClick?: onDoubleClickArguments<t<'meta>, 'meta> => unit,
  }
}

module Cursor: {
  type t = Default | NESWResize | NWSEResize | Grab | NSResize | EWResize
}
