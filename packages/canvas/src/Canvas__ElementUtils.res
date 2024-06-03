open Canvas__Models
open Canvas__Constants
module SelectionUtils = Canvas__SelectionUtils

// Getters for shared properties
let getElementId = (element: element<'meta>) =>
  switch element {
  | Line({id}) | Rect({id}) => id
  }

let getElementZIndex = (element: element<'meta>) =>
  switch element {
  | Line({zIndex}) | Rect({zIndex}) => zIndex
  }

let getToolId = (element: element<'meta>) =>
  switch element {
  | Line({toolId}) | Rect({toolId}) => toolId
  }

let updateElementAtPosition = (~elements, ~position, ~element) => {
  let copy = elements->Array.copy
  copy->Array.setUnsafe(position, element)
  copy
}

let isSelected = (elementId: string, selectedElementIds: array<string>) =>
  selectedElementIds->Array.some(selectedElementId => selectedElementId === elementId)

let intersectsSelection = (element: element<'meta>, selection) => {
  switch element {
  | Line(line) => SelectionUtils.lineIntersectsSelection(line, selection, tolerance)
  | Rect(rect) => SelectionUtils.rectIntersectsSelection(rect, selection)
  }
}

let getElementAtPoint = (elements, clientX, clientY, ~tolerance as givenTolerance=?) => {
  // Sort elements by zIndex in descending order
  let sortedElements = elements->Utils.Array.toSorted((a, b) => {
    getElementZIndex(b) -. getElementZIndex(a)
  })

  // Iterate over the sorted elements array
  sortedElements->Array.find(element => {
    switch element {
    | Rect({x, y, width, height, _}) =>
      // Normalize the selection so that this function can be used
      // regardless of the direction the rectangle was drawn
      let normalizedSelection = SelectionUtils.normalizeSelection({x, y, width, height})
      SelectionUtils.isPointInsideSelection(
        normalizedSelection,
        clientX,
        clientY,
        ~tolerance=?givenTolerance,
      )
    // Line need tolerance always because it's hard to click on a line
    | Line(line) => SelectionUtils.isPointNearLine(clientX, clientY, line, tolerance)
    }
  })
}

let getElementAtPointWithTolerance = (elements, clientX, clientY) =>
  getElementAtPoint(elements, clientX, clientY, ~tolerance)

let moveSelectedElements = (
  elements,
  ~move: Selection.move,
  ~selectedElementIds,
  ~clientX,
  ~clientY,
) =>
  elements->Array.map(element => {
    let id = getElementId(element)
    if isSelected(id, selectedElementIds) {
      switch element {
      | Line(line) =>
        let {start, end} = line
        Line({
          ...line,
          start: {
            x: start.x +. clientX -. move.target.x,
            y: start.y +. clientY -. move.target.y,
          },
          end: {
            x: end.x +. clientX -. move.target.x,
            y: end.y +. clientY -. move.target.y,
          },
        })
      | Rect(rect) =>
        let {x, y} = rect
        Rect({
          ...rect,
          x: x +. clientX -. move.target.x,
          y: y +. clientY -. move.target.y,
        })
      }
    } else {
      element
    }
  })

let isElementSelected = (element, ~selectedElementIds) =>
  selectedElementIds->Array.some(selectedElementId => selectedElementId === element->getElementId)

let getFirstElementId = elements => elements->Array.getUnsafe(0)->getElementId

let resizeLineInElements = (elements: array<element<'meta>>, resizedLine: Line.t<'meta>) => {
  elements->Array.map(element =>
    if resizedLine.id === element->getElementId {
      Line(resizedLine)
    } else {
      element
    }
  )
}

let resizeRectInElements = (elements: array<element<'meta>>, resizedRect: Rect.t<'meta>) => {
  elements->Array.map(element =>
    if resizedRect.id === element->getElementId {
      Rect(resizedRect)
    } else {
      element
    }
  )
}

@module("./utils")
external measureTextSize: (~text: string, ~font: string) => Size.t = "measureTextSize"

let getLineCenter = ({start, end}: Line.t<'meta>): Vec.t => {
  x: (start.x +. end.x) /. 2.,
  y: (start.y +. end.y) /. 2.,
}

let getLineCenterForText = (line: Line.t<'meta>, ~text, ~font): Vec.t => {
  let {x, y} = getLineCenter(line)
  let {width, height} = measureTextSize(~text, ~font)

  {
    x: x -. width /. 2.,
    y: y +. height /. 3.,
  }
}

let getRectCenter = ({x, y, width, height}: Rect.t<'meta>): Vec.t => {
  x: x +. width /. 2.,
  y: y +. height /. 2.,
}

let getRectCenterForText = (rect: Rect.t<'meta>, ~text, ~font): Vec.t => {
  let {x, y} = getRectCenter(rect)
  let {width, height} = measureTextSize(~text, ~font)

  {
    x: x -. width /. 2.,
    y: y +. height /. 3.,
  }
}

let updateElementLabel = (elements: array<element<'meta>>, ~id: string, ~label: option<string>) => {
  elements->Array.map(element =>
    if element->getElementId === id {
      switch element {
      | Line(line) => Line({...line, label})
      | Rect(rect) => Rect({...rect, label})
      }
    } else {
      element
    }
  )
}

let invokeOnDoubleClick = (
  ~clientX,
  ~clientY,
  ~tools: array<Tool.t<'meta>>,
  ~target,
  ~updateStore,
  ~store: Store.t<'meta>,
) => {
  let clickedElement = getElementAtPointWithTolerance(store.elements, clientX, clientY)
  clickedElement->Option.forEach(clickedElement => {
    let clickedTool = tools->Array.find(tool => tool.toolId === clickedElement->getToolId)
    switch clickedTool {
    | Some({onDoubleClick: ?Some(onDoubleClick)}) =>
      onDoubleClick({
        tools,
        target,
        clickedElement,
        store,
        updateStore,
      })
    | Some({onDoubleClick: ?None})
    | None => ()
    }
  })
}

// 3, ~gridSize=5 => 5; 2, ~gridSize=5 => 0
let roundNumberBySnapGridSize = (number: float, ~gridSize: float) => {
  let remainder = Float.mod(number, gridSize)
  if remainder < gridSize /. 2. {
    number -. remainder
  } else {
    number +. gridSize -. remainder
  }
}

let snapElementToGrid = (element: element<'meta>, ~gridSize: float) => {
  switch element {
  | Line(line) =>
    Line({
      ...line,
      start: {
        x: roundNumberBySnapGridSize(line.start.x, ~gridSize),
        y: roundNumberBySnapGridSize(line.start.y, ~gridSize),
      },
      end: {
        x: roundNumberBySnapGridSize(line.end.x, ~gridSize),
        y: roundNumberBySnapGridSize(line.end.y, ~gridSize),
      },
    })
  | Rect(rect) =>
    Rect({
      ...rect,
      x: roundNumberBySnapGridSize(rect.x, ~gridSize),
      y: roundNumberBySnapGridSize(rect.y, ~gridSize),
      width: roundNumberBySnapGridSize(rect.width, ~gridSize),
      height: roundNumberBySnapGridSize(rect.height, ~gridSize),
    })
  }
}
