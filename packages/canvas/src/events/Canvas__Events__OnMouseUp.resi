@genType
let handler: (
  JsxEvent.Mouse.t,
  ~offsetX: float,
  ~offsetY: float,
  ~store: Canvas__Models.Store.t,
  ~tools: array<Canvas__Models.Tool.t>,
  ~updateStore: (Canvas__Models.Store.t => Canvas__Models.Store.t) => unit,
) => unit
