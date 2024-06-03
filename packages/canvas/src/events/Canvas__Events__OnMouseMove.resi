@genType
let handler: (
  JsxEvent.Mouse.t,
  ~offsetX: float,
  ~offsetY: float,
  ~store: Canvas__Models.Store.t<'meta>,
  ~tools: array<Canvas__Models.Tool.t<'meta>>,
  ~updateStore: (Canvas__Models.Store.t<'meta> => Canvas__Models.Store.t<'meta>) => unit,
) => unit
