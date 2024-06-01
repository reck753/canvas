let normalizeRect: Canvas__Models.Rect.t => Canvas__Models.Rect.t
let normalizeSelection: Canvas__Models.Selection.t => Canvas__Models.Selection.t
let expandSelectionBox: (Canvas__Models.Selection.t, float) => Canvas__Models.Selection.t
let isPointInsideSelection: (Canvas__Models.Selection.t, float, float, ~tolerance: float=?) => bool
let onSegment: (float, float, float, float, float, float) => bool
let orientation: (float, float, float, float, float, float) => int
let doIntersect: (float, float, float, float, float, float, float, float) => bool
let sqr: float => float
let dist2: (float, float, float, float) => float
let distToLineSegmentSquared: (float, float, float, float, float, float) => float
let isPointNearLine: (float, float, Canvas__Models.Line.t, float) => bool
let lineIntersectsSelection: (Canvas__Models.Line.t, Canvas__Models.Selection.t, float) => bool
let rectIntersectsSelection: (Canvas__Models.Rect.t, Canvas__Models.Selection.t) => bool
let isClick: (Canvas__Models.Selection.t, float) => bool
let didMove: Canvas__Models.Selection.move => bool
let isPointNearPoint: (float, float, float, float, float) => bool
let getRectCorner: (
  float,
  float,
  Canvas__Models.Rect.t,
  array<Canvas__Models.Tool.t>,
) => option<Canvas__Models.Corner.t>
let getLineCorner: (
  float,
  float,
  Canvas__Models.Line.t,
  array<Canvas__Models.Tool.t>,
) => option<Canvas__Models.Corner.t>
let getRectCursor: (
  float,
  float,
  Canvas__Models.Rect.t,
  array<Canvas__Models.Tool.t>,
) => Canvas__Models.Cursor.t
let getLineCursor: (
  float,
  float,
  Canvas__Models.Line.t,
  array<Canvas__Models.Tool.t>,
) => Canvas__Models.Cursor.t
let getElementCorner: (
  float,
  float,
  Canvas__Models.element,
  array<Canvas__Models.Tool.t>,
) => option<Canvas__Models.Corner.t>
let getCursorType: Canvas__Models.Cursor.t => string
let resizeRect: (
  Canvas__Models.Rect.t,
  float,
  float,
  Canvas__Models.Corner.t,
) => Canvas__Models.Rect.t
let resizeLine: (
  Canvas__Models.Line.t,
  float,
  float,
  Canvas__Models.Corner.t,
) => Canvas__Models.Line.t
