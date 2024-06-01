@genType
let getElementId: Canvas__Models.element => string
let getElementZIndex: Canvas__Models.element => float
let getToolId: Canvas__Models.element => string
let updateElementAtPosition: (~elements: array<'a>, ~position: int, ~element: 'a) => array<'a>
@genType
let isSelected: (string, array<string>) => bool
let intersectsSelection: (Canvas__Models.element, Canvas__Models.Selection.t) => bool
let getElementAtPoint: (
  array<Canvas__Models.element>,
  float,
  float,
  ~tolerance: float=?,
) => option<Canvas__Models.element>
let getElementAtPointWithTolerance: (
  array<Canvas__Models.element>,
  float,
  float,
) => option<Canvas__Models.element>
let moveSelectedElements: (
  array<Canvas__Models.element>,
  ~move: Canvas__Models.Selection.move,
  ~selectedElementIds: array<string>,
  ~clientX: float,
  ~clientY: float,
) => array<Canvas__Models.element>
let isElementSelected: (Canvas__Models.element, ~selectedElementIds: array<string>) => bool
let getFirstElementId: array<Canvas__Models.element> => string
let resizeLineInElements: (
  array<Canvas__Models.element>,
  Canvas__Models.Line.t,
) => array<Canvas__Models.element>
let resizeRectInElements: (
  array<Canvas__Models.element>,
  Canvas__Models.Rect.t,
) => array<Canvas__Models.element>
let measureTextSize: (~text: string, ~font: string) => Canvas__Models.Size.t
let getLineCenter: Canvas__Models.Line.t => Canvas__Models.Vec.t
@genType
let getLineCenterForText: (
  Canvas__Models.Line.t,
  ~text: string,
  ~font: string,
) => Canvas__Models.Vec.t
let getRectCenter: Canvas__Models.Rect.t => Canvas__Models.Vec.t
@genType
let getRectCenterForText: (
  Canvas__Models.Rect.t,
  ~text: string,
  ~font: string,
) => Canvas__Models.Vec.t
@genType
let updateElementLabel: (
  array<Canvas__Models.element>,
  ~id: string,
  ~label: option<string>,
) => array<Canvas__Models.element>
let invokeOnDoubleClick: (
  ~clientX: float,
  ~clientY: float,
  ~tools: array<Canvas__Models.Tool.t>,
  ~target: Canvas__CanvasUtils.JsxEventFixed.Mouse.target,
  ~updateStore: (Canvas__Models.Store.t => Canvas__Models.Store.t) => unit,
  ~store: Canvas__Models.Store.t,
) => unit
@genType
let roundNumberBySnapGridSize: (float, ~gridSize: float) => float
let snapElementToGrid: (Canvas__Models.element, ~gridSize: float) => Canvas__Models.element
