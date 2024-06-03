@genType
let getElementId: Canvas__Models.element<'meta> => string
let getElementZIndex: Canvas__Models.element<'meta> => float
let getToolId: Canvas__Models.element<'meta> => string
let updateElementAtPosition: (
  ~elements: array<Canvas__Models.element<'meta>>,
  ~position: int,
  ~element: Canvas__Models.element<'meta>,
) => array<Canvas__Models.element<'meta>>
@genType
let isSelected: (string, array<string>) => bool
let intersectsSelection: (Canvas__Models.element<'meta>, Canvas__Models.Selection.t) => bool
let getElementAtPoint: (
  array<Canvas__Models.element<'meta>>,
  float,
  float,
  ~tolerance: float=?,
) => option<Canvas__Models.element<'meta>>
let getElementAtPointWithTolerance: (
  array<Canvas__Models.element<'meta>>,
  float,
  float,
) => option<Canvas__Models.element<'meta>>
let moveSelectedElements: (
  array<Canvas__Models.element<'meta>>,
  ~move: Canvas__Models.Selection.move,
  ~selectedElementIds: array<string>,
  ~clientX: float,
  ~clientY: float,
) => array<Canvas__Models.element<'meta>>
let isElementSelected: (Canvas__Models.element<'meta>, ~selectedElementIds: array<string>) => bool
let getFirstElementId: array<Canvas__Models.element<'meta>> => string
let resizeLineInElements: (
  array<Canvas__Models.element<'meta>>,
  Canvas__Models.Line.t<'meta>,
) => array<Canvas__Models.element<'meta>>
let resizeRectInElements: (
  array<Canvas__Models.element<'meta>>,
  Canvas__Models.Rect.t<'meta>,
) => array<Canvas__Models.element<'meta>>
let measureTextSize: (~text: string, ~font: string) => Canvas__Models.Size.t
let getLineCenter: Canvas__Models.Line.t<'meta> => Canvas__Models.Vec.t
@genType
let getLineCenterForText: (
  Canvas__Models.Line.t<'meta>,
  ~text: string,
  ~font: string,
) => Canvas__Models.Vec.t
let getRectCenter: Canvas__Models.Rect.t<'meta> => Canvas__Models.Vec.t
@genType
let getRectCenterForText: (
  Canvas__Models.Rect.t<'meta>,
  ~text: string,
  ~font: string,
) => Canvas__Models.Vec.t
@genType
let updateElementLabel: (
  array<Canvas__Models.element<'meta>>,
  ~id: string,
  ~label: option<string>,
) => array<Canvas__Models.element<'meta>>
let invokeOnDoubleClick: (
  ~clientX: float,
  ~clientY: float,
  ~tools: array<Canvas__Models.Tool.t<'meta>>,
  ~target: Canvas__CanvasUtils.JsxEventFixed.Mouse.target,
  ~updateStore: (Canvas__Models.Store.t<'meta> => Canvas__Models.Store.t<'meta>) => unit,
  ~store: Canvas__Models.Store.t<'meta>,
) => unit
@genType
let roundNumberBySnapGridSize: (float, ~gridSize: float) => float
let snapElementToGrid: (
  Canvas__Models.element<'meta>,
  ~gridSize: float,
) => Canvas__Models.element<'meta>
