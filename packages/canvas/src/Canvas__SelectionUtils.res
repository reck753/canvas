open Canvas__Models
open Canvas__Constants

let normalizeRect = (rect: Rect.t): Rect.t => {
  let x = rect.width >= 0. ? rect.x : rect.x +. rect.width
  let y = rect.height >= 0. ? rect.y : rect.y +. rect.height
  let width = Math.abs(rect.width)
  let height = Math.abs(rect.height)
  {...rect, x, y, width, height}
}

let normalizeSelection = (selection: Selection.t): Selection.t => {
  let x = selection.width >= 0. ? selection.x : selection.x +. selection.width
  let y = selection.height >= 0. ? selection.y : selection.y +. selection.height
  let width = Math.abs(selection.width)
  let height = Math.abs(selection.height)
  {x, y, width, height}
}

// Expand the selection box by the tolerance value on all sides
let expandSelectionBox = (selection: Selection.t, tolerance): Selection.t => {
  x: selection.x -. tolerance,
  y: selection.y -. tolerance,
  width: selection.width +. 2. *. tolerance,
  height: selection.height +. 2. *. tolerance,
}

let isPointInsideSelection = (selection: Selection.t, x, y, ~tolerance=0.) =>
  x >= selection.x -. tolerance &&
  x <= selection.x +. selection.width +. tolerance &&
  y >= selection.y -. tolerance &&
  y <= selection.y +. selection.height +. tolerance

// onSegment checks if the point (qx, qy) lies on the line segment
// defined by (px, py) and (rx, ry).
// It does this by checking if the point is within the bounding box
// of the line segment and if the area formed by the triangle defined
// by the three points is zero.
let onSegment = (px, py, qx, qy, rx, ry) => {
  if (
    qx <= Math.max(px, rx) &&
    qx >= Math.min(px, rx) &&
    qy <= Math.max(py, ry) &&
    qy >= Math.min(py, ry)
  ) {
    let area = px *. (qy -. ry) +. qx *. (ry -. py) +. rx *. (py -. qy)
    area == 0.
  } else {
    false
  }
}

// orientation returns 0 if the points are collinear, 1 if they are
// clockwise, and 2 if they are counterclockwise.
let epsilon = 1e-10 // Adjust based on required precision

let orientation = (px, py, qx, qy, rx, ry) => {
  let val = (qy -. py) *. (rx -. qx) -. (qx -. px) *. (ry -. qy)

  if Math.abs(val) < epsilon {
    0 // Collinear
  } else if val > 0. {
    2 // Counterclockwise, considering y-axis inversion
  } else {
    1 // Clockwise, considering y-axis inversion
  }
}

// doIntersect checks if the line segment defined by (p1x, p1y) and (q1x, q1y)
// intersects the line segment defined by (p2x, p2y) and (q2x, q2y).
let doIntersect = (p1x, p1y, q1x, q1y, p2x, p2y, q2x, q2y) => {
  let o1 = orientation(p1x, p1y, q1x, q1y, p2x, p2y)
  let o2 = orientation(p1x, p1y, q1x, q1y, q2x, q2y)
  let o3 = orientation(p2x, p2y, q2x, q2y, p1x, p1y)
  let o4 = orientation(p2x, p2y, q2x, q2y, q1x, q1y)

  if o1 != o2 && o3 != o4 {
    true
  } else if o1 == 0 && onSegment(p1x, p1y, p2x, p2y, q1x, q1y) {
    true
  } else if o2 == 0 && onSegment(p1x, p1y, q2x, q2y, q1x, q1y) {
    true
  } else if o3 == 0 && onSegment(p2x, p2y, p1x, p1y, q2x, q2y) {
    true
  } else if o4 == 0 && onSegment(p2x, p2y, q1x, q1y, q2x, q2y) {
    true
  } else {
    false
  }
}

// sqr and dist2 are utility functions for squaring a value and
// calculating the squared distance between two points, respectively.
let sqr = x => x *. x
let dist2 = (vx, vy, wx, wy) => sqr(vx -. wx) +. sqr(vy -. wy)

// distToLineSegmentSquared calculates the squared distance from
// a point (px, py) to the line segment defined by (x1, y1) and (x2, y2).
// It finds the point on the line segment closest to (px, py) and
// calculates the squared distance to this point.
let distToLineSegmentSquared = (px, py, x1, y1, x2, y2) => {
  let l2 = dist2(x1, y1, x2, y2)
  if l2 == 0. {
    dist2(px, py, x1, y1)
  } else {
    let t = Math.max(0., Math.min(1., ((px -. x1) *. (x2 -. x1) +. (py -. y1) *. (y2 -. y1)) /. l2))
    dist2(px, py, x1 +. t *. (x2 -. x1), y1 +. t *. (y2 -. y1))
  }
}

// isPointNearLine checks if the point defined by (px, py) is within
// a certain tolerance distance from the line segment.
// It uses distToLineSegmentSquared and compares the result against
// the squared tolerance to avoid unnecessary square root calculations.
let isPointNearLine = (px, py, line: Line.t, tolerance) => {
  let distanceSquared = distToLineSegmentSquared(
    px,
    py,
    line.start.x,
    line.start.y,
    line.end.x,
    line.end.y,
  )
  distanceSquared <= sqr(tolerance)
}

let lineIntersectsSelection = (line: Line.t, selection: Selection.t, tolerance) => {
  let normalizedSelection = normalizeSelection(selection)
  let expandedSelection = expandSelectionBox(normalizedSelection, tolerance)
  let selection = expandedSelection

  // Check if line endpoints are within the selection
  if (
    isPointInsideSelection(selection, line.start.x, line.start.y) ||
    isPointInsideSelection(selection, line.end.x, line.end.y)
  ) {
    true
  } else {
    // Check if the line intersects any of the selection's edges
    let left = selection.x
    let right = selection.x +. selection.width
    let top = selection.y
    let bottom = selection.y +. selection.height

    // Check each of the four edges of the selection
    doIntersect(line.start.x, line.start.y, line.end.x, line.end.y, left, top, right, top) ||
    doIntersect(line.start.x, line.start.y, line.end.x, line.end.y, left, bottom, right, bottom) ||
    doIntersect(line.start.x, line.start.y, line.end.x, line.end.y, left, top, left, bottom) ||
    doIntersect(line.start.x, line.start.y, line.end.x, line.end.y, right, top, right, bottom)
  }
}

let rectIntersectsSelection = (rect: Rect.t, selection: Selection.t) => {
  let normalizedRect = normalizeRect(rect)
  let normalizedSelection = normalizeSelection(selection)

  // Check if rect is to the left of selection or vice versa
  let noHorizontalOverlap =
    normalizedRect.x +. normalizedRect.width < normalizedSelection.x ||
      normalizedSelection.x +. normalizedSelection.width < normalizedRect.x

  // Check if rect is above selection or vice versa
  let noVerticalOverlap =
    normalizedRect.y +. normalizedRect.height < normalizedSelection.y ||
      normalizedSelection.y +. normalizedSelection.height < normalizedRect.y

  // If there's no horizontal or vertical overlap, the rectangle doesn't intersect the selection
  !(noHorizontalOverlap || noVerticalOverlap)
}

let isClick = (selection, tolerance) => {
  let normalizedSelection = normalizeSelection(selection)
  normalizedSelection.width < tolerance && normalizedSelection.height < tolerance
}

let didMove = ({origin, target}: Selection.move) => {
  origin.x !== target.x || origin.y !== target.y
}

// isPointNearPoint checks if the point defined by (px, py) is within
// a certain tolerance distance from another point (qx, qy).
let isPointNearPoint = (px, py, qx, qy, tolerance) => {
  px >= qx -. tolerance && px <= qx +. tolerance && py >= qy -. tolerance && py <= qy +. tolerance
}

let getRectCorner = (
  clientX,
  clientY,
  {x, y, width, height, toolId}: Rect.t,
  tools: array<Tool.t>,
): option<Corner.t> => {
  let elementTool = tools->Array.find(tool => tool.toolId === toolId)
  let (canResizeHorizontally, canResizeVertically) = switch elementTool->Option.map(tool =>
    tool.engine
  ) {
  | Some(Rect({?canResizeHorizontally, ?canResizeVertically})) => (
      canResizeHorizontally->Option.getOr(true),
      canResizeVertically->Option.getOr(true),
    )
  | _ => (true, true)
  }

  let corner: option<Corner.t> = if isPointNearPoint(clientX, clientY, x, y, tolerance) {
    Some(TopLeft)
  } else if isPointNearPoint(clientX, clientY, x +. width, y, tolerance) {
    Some(TopRight)
  } else if isPointNearPoint(clientX, clientY, x, y +. height, tolerance) {
    Some(BottomLeft)
  } else if isPointNearPoint(clientX, clientY, x +. width, y +. height, tolerance) {
    Some(BottomRight)
  } else if clientX >= x +. tolerance && clientX <= x +. width -. tolerance {
    if clientY >= y -. tolerance && clientY <= y +. tolerance {
      Some(Top)
    } else if clientY >= y +. height -. tolerance && clientY <= y +. height +. tolerance {
      Some(Bottom)
    } else {
      None
    }
  } else if clientY >= y +. tolerance && clientY <= y +. height -. tolerance {
    if clientX >= x -. tolerance && clientX <= x +. tolerance {
      Some(Left)
    } else if clientX >= x +. width -. tolerance && clientX <= x +. width +. tolerance {
      Some(Right)
    } else {
      None
    }
  } else {
    None
  }

  switch (corner, canResizeHorizontally, canResizeVertically) {
  | (Some(TopLeft), true, true) => Some(TopLeft)
  | (Some(TopRight), true, true) => Some(TopRight)
  | (Some(BottomLeft), true, true) => Some(BottomLeft)
  | (Some(BottomRight), true, true) => Some(BottomRight)
  | (Some(Top), _, true) => Some(Top)
  | (Some(Bottom), _, true) => Some(Bottom)
  | (Some(Left), true, _) => Some(Left)
  | (Some(Right), true, _) => Some(Right)
  | (Some(TopLeft), false, true) => Some(Top)
  | (Some(TopRight), false, true) => Some(Top)
  | (Some(BottomLeft), false, true) => Some(Bottom)
  | (Some(BottomRight), false, true) => Some(Bottom)
  | (Some(TopLeft), true, false) => Some(Left)
  | (Some(TopRight), true, false) => Some(Right)
  | (Some(BottomLeft), true, false) => Some(Left)
  | (Some(BottomRight), true, false) => Some(Right)
  // Not resizable
  | (Some(TopLeft), false, false) => None
  | (Some(TopRight), false, false) => None
  | (Some(BottomLeft), false, false) => None
  | (Some(BottomRight), false, false) => None
  | (Some(Top), _, false) => None
  | (Some(Bottom), _, false) => None
  | (Some(Left), false, _) => None
  | (Some(Right), false, _) => None
  | (None, _, _) => None
  | (Some(Start), _, _) => None
  | (Some(End), _, _) => None
  }
}

let getLineCorner = (clientX, clientY, {start, end, toolId}: Line.t, tools: array<Tool.t>): option<
  Corner.t,
> => {
  let elementTool = tools->Array.find(tool => tool.toolId === toolId)
  let (canResizeStart, canResizeEnd) = switch elementTool->Option.map(tool => tool.engine) {
  | Some(Line({?canResizeStart, ?canResizeEnd})) => (
      canResizeStart->Option.getOr(true),
      canResizeEnd->Option.getOr(true),
    )
  | _ => (true, true)
  }
  let corner: option<Corner.t> = if (
    isPointNearPoint(clientX, clientY, start.x, start.y, tolerance)
  ) {
    Some(Start)
  } else if isPointNearPoint(clientX, clientY, end.x, end.y, tolerance) {
    Some(End)
  } else {
    None
  }

  switch (corner, canResizeStart, canResizeEnd) {
  | (Some(Start), true, _) => Some(Start)
  | (Some(End), _, true) => Some(End)
  | (None, _, _) => None
  | (Some(_), _, _) => None
  }
}

let getRectCursor = (clientX, clientY, rect: Rect.t, tools): Cursor.t => {
  let corner = getRectCorner(clientX, clientY, normalizeRect(rect), tools)

  switch corner {
  | Some(TopLeft) | Some(BottomRight) => NWSEResize
  | Some(TopRight) | Some(BottomLeft) => NESWResize
  | Some(Top) | Some(Bottom) => NSResize
  | Some(Left) | Some(Right) => EWResize
  | _ => Default
  }
}

let getLineCursor = (clientX, clientY, line: Line.t, tools: array<Tool.t>): Cursor.t => {
  let corner = getLineCorner(clientX, clientY, line, tools)

  switch corner {
  | Some(Start) | Some(End) => Grab
  | _ => Default
  }
}

let getElementCorner = (clientX, clientY, element: element, tools: array<Tool.t>): option<
  Corner.t,
> =>
  switch element {
  | Rect(rect) => getRectCorner(clientX, clientY, rect, tools)
  | Line(line) => getLineCorner(clientX, clientY, line, tools)
  }

let getCursorType = (cursor: Cursor.t) => {
  switch cursor {
  | Default => "default"
  | NESWResize => "nesw-resize"
  | NWSEResize => "nwse-resize"
  | NSResize => "ns-resize"
  | EWResize => "ew-resize"
  | Grab => "grab"
  }
}

let resizeRect = (rect: Rect.t, clientX, clientY, corner: Corner.t): Rect.t => {
  switch corner {
  | TopLeft => {
      ...rect,
      x: clientX,
      y: clientY,
      width: rect.x +. rect.width -. clientX,
      height: rect.y +. rect.height -. clientY,
    }
  | TopRight => {
      ...rect,
      y: clientY,
      width: clientX -. rect.x,
      height: rect.y +. rect.height -. clientY,
    }
  | BottomLeft => {
      ...rect,
      x: clientX,
      width: rect.x +. rect.width -. clientX,
      height: clientY -. rect.y,
    }
  | BottomRight => {
      ...rect,
      width: clientX -. rect.x,
      height: clientY -. rect.y,
    }
  | Top => {
      ...rect,
      y: clientY,
      height: rect.y +. rect.height -. clientY,
    }
  | Bottom => {
      ...rect,
      height: clientY -. rect.y,
    }
  | Left => {
      ...rect,
      x: clientX,
      width: rect.x +. rect.width -. clientX,
    }
  | Right => {
      ...rect,
      width: clientX -. rect.x,
    }
  | _ => rect
  }
}

let resizeLine = (line: Line.t, clientX, clientY, corner: Corner.t): Line.t => {
  switch corner {
  | Start => {...line, start: {x: clientX, y: clientY}}
  | End => {...line, end: {x: clientX, y: clientY}}
  | _ => line
  }
}
