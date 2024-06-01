module Vec = {
  type t = {x: float, y: float}
}

module Size = {
  type t = {width: float, height: float}
}

module Element = {
  type t = {id: string, toolId: string, zIndex: float, label: option<string>}
}

module Rect = {
  type t = {
    ...Element.t,
    ...Vec.t,
    ...Size.t,
  }
  @tag("type")
  type state = Idle | Drawing
}

module Line = {
  type t = {
    ...Element.t,
    start: Vec.t,
    end: Vec.t,
  }
  @tag("type")
  type state = Idle | Drawing
}

@tag("type")
type element = Line(Line.t) | Rect(Rect.t)

module Corner = {
  type t = Start | End | TopLeft | TopRight | BottomLeft | BottomRight | Top | Bottom | Left | Right
}

module Selection = {
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

module State = {
  @tag("type")
  type t = Selection(Selection.state) | Rect(Rect.state) | Line(Line.state)
}

module Store = {
  @tag("type")
  type snapToGrid = No | Yes(float)
  type t = {
    state: State.t,
    snapToGrid: snapToGrid,
    selectedToolId: string,
    selectedElementIds: array<string>,
    elements: array<element>,
  }
}

module Tool = {
  type sharedCallbackArguments<'tool> = {
    clientX: float,
    clientY: float,
    store: Store.t,
    updateStore: (Store.t => Store.t) => unit,
    target: Canvas__CanvasUtils.JsxEventFixed.Mouse.target,
    tools: array<'tool>,
  }
  type onStartArguments<'tool> = {
    ...sharedCallbackArguments<'tool>,
    nextIndex: float,
  }
  type onMoveArguments<'tool> = {
    ...sharedCallbackArguments<'tool>,
  }
  type onEndArguments<'tool> = {
    ...sharedCallbackArguments<'tool>,
  }
  type onDoubleClickArguments<'tool> = {
    tools: array<'tool>,
    clickedElement: element,
    store: Store.t,
    updateStore: (Store.t => Store.t) => unit,
    target: Canvas__CanvasUtils.JsxEventFixed.Mouse.target,
  }
  type style = {lineWidth?: float}
  type rectSettings = {...style, canResizeVertically?: bool, canResizeHorizontally?: bool}
  type lineSettings = {...style, canResizeStart?: bool, canResizeEnd?: bool}
  @tag("type")
  type engine =
    | Selection
    | Rect(rectSettings)
    | Line(lineSettings)
  type rec t = {
    toolId: string,
    engine: engine,
    onStart: onStartArguments<t> => unit,
    onMove: onMoveArguments<t> => unit,
    onEnd: onEndArguments<t> => unit,
    onDoubleClick?: onDoubleClickArguments<t> => unit,
  }
}

module Cursor = {
  type t = Default | NESWResize | NWSEResize | Grab | NSResize | EWResize
}
