open Canvas__Models
module ElementUtils = Canvas__ElementUtils
module SelectionUtils = Canvas__SelectionUtils
module StateUtils = Canvas__StateUtils

let tool: Tool.t = {
  toolId: "selection",
  engine: Selection,
  onStart: ({
    clientX,
    clientY,
    store: {state, elements, selectedElementIds, snapToGrid},
    updateStore,
    target,
    tools,
  }) => {
    let state = StateUtils.getSelectionState(state)
    switch state {
    | None => ()
    | Some(Selecting(_)) => ()
    | Some(Moving(_)) => ()
    | Some(Resizing(_)) => ()
    | Some(Idle) =>
      // Check if an element is under the mouse click
      let clickedElement = ElementUtils.getElementAtPointWithTolerance(elements, clientX, clientY)
      switch clickedElement {
      | Some(clickedElement) =>
        let (moveX, moveY) = switch snapToGrid {
        | No => (clientX, clientY)
        | Yes(gridSize) => (
            ElementUtils.roundNumberBySnapGridSize(clientX, ~gridSize),
            ElementUtils.roundNumberBySnapGridSize(clientY, ~gridSize),
          )
        }
        let initialMove: Selection.move = {
          origin: {x: moveX, y: moveY},
          target: {x: moveX, y: moveY},
        }
        switch selectedElementIds->Array.length {
        | 0 =>
          updateStore(prev => {
            ...prev,
            state: Selection(Moving(initialMove)),
            selectedElementIds: [ElementUtils.getElementId(clickedElement)],
          })
        | 1
          if selectedElementIds->Array.getUnsafe(0) === clickedElement->ElementUtils.getElementId =>
          let corner = SelectionUtils.getElementCorner(clientX, clientY, clickedElement, tools)
          switch corner {
          | Some(corner) =>
            // get clicked element tool so that we can get the
            // Line settings and determine if we should show the
            // grabbing cursor
            let clickedElementTool =
              tools->Array.find(tool => tool.toolId === clickedElement->ElementUtils.getToolId)
            switch clickedElementTool->Option.map(tool => tool.engine) {
            | Some(Line({?canResizeStart, ?canResizeEnd})) =>
              let canResizeStart = canResizeStart->Option.getOr(true)
              let canResizeEnd = canResizeEnd->Option.getOr(true)
              if (corner === Start && canResizeStart) || (corner === End && canResizeEnd) {
                target.style.cursor = "grabbing"
              }
            | Some(Rect(_))
            | Some(Selection)
            | None => ()
            }
            updateStore(prev => {
              ...prev,
              state: Selection(Resizing(corner)),
            })
          | None =>
            updateStore(prev => {
              ...prev,
              state: Selection(Moving(initialMove)),
            })
          }
        | 1
          if selectedElementIds->Array.getUnsafe(0) !== clickedElement->ElementUtils.getElementId =>
          // Update this as needed, e.g., to support multi-selection
          // when the shift key is pressed
          updateStore(prev => {
            ...prev,
            state: Selection(Moving(initialMove)),
            selectedElementIds: [ElementUtils.getElementId(clickedElement)],
          })
        | _ =>
          // Update this as needed, e.g., to support multi-selection
          // when the shift key is pressed
          let isClickedElementAlreadySelected =
            clickedElement->ElementUtils.isElementSelected(~selectedElementIds)
          if isClickedElementAlreadySelected {
            updateStore(prev => {
              ...prev,
              state: Selection(Moving(initialMove)),
            })
          } else {
            updateStore(prev => {
              ...prev,
              state: Selection(Moving(initialMove)),
              selectedElementIds: [ElementUtils.getElementId(clickedElement)],
            })
          }
        }
      | None =>
        updateStore(prev => {
          ...prev,
          state: Selection(Selecting({x: clientX, y: clientY, width: 0., height: 0.})),
          selectedElementIds: [],
        })
      }
    }
  },
  onMove: ({
    clientX,
    clientY,
    store: {state, selectedElementIds, elements, snapToGrid},
    target,
    updateStore,
    tools,
  }) => {
    let state = StateUtils.getSelectionState(state)

    switch state {
    | None => ()
    | Some(Idle) =>
      target.style.cursor = "default"
      switch selectedElementIds->Array.length {
      | 1 =>
        let selectedElementId = selectedElementIds->Array.getUnsafe(0)
        let selectedElement =
          elements->Array.find(element => ElementUtils.getElementId(element) === selectedElementId)

        let cursor = selectedElement->Option.map(selectedElement => {
          switch selectedElement {
          | Line(line) => SelectionUtils.getLineCursor(clientX, clientY, line, tools)
          | Rect(rect) => SelectionUtils.getRectCursor(clientX, clientY, rect, tools)
          }
        })
        cursor->Option.forEach(cursor => {
          target.style.cursor = SelectionUtils.getCursorType(cursor)
        })
      | _ => ()
      }
    | Some(Moving(move)) =>
      target.style.cursor = "move"
      let (clientX, clientY) = switch snapToGrid {
      | No => (clientX, clientY)
      | Yes(gridSize) => (
          ElementUtils.roundNumberBySnapGridSize(clientX, ~gridSize),
          ElementUtils.roundNumberBySnapGridSize(clientY, ~gridSize),
        )
      }
      updateStore(prev => {
        ...prev,
        state: Selection(Moving({origin: move.origin, target: {x: clientX, y: clientY}})),
        elements: prev.elements->ElementUtils.moveSelectedElements(
          ~move,
          ~selectedElementIds=prev.selectedElementIds,
          ~clientX,
          ~clientY,
        ),
      })
    | Some(Resizing(corner)) =>
      switch selectedElementIds->Array.length {
      | 1 =>
        let selectedElementId = selectedElementIds->Array.getUnsafe(0)
        let selectedElement =
          elements->Array.find(element => ElementUtils.getElementId(element) === selectedElementId)
        let (clientX, clientY) = switch snapToGrid {
        | No => (clientX, clientY)
        | Yes(gridSize) => (
            ElementUtils.roundNumberBySnapGridSize(clientX, ~gridSize),
            ElementUtils.roundNumberBySnapGridSize(clientY, ~gridSize),
          )
        }
        selectedElement->Option.forEach(selectedElement =>
          switch selectedElement {
          | Rect(rect) =>
            let resizedRect = rect->SelectionUtils.resizeRect(clientX, clientY, corner)
            // Set the cursor based on the corner
            let cursor = SelectionUtils.getRectCursor(clientX, clientY, resizedRect, tools)
            target.style.cursor = SelectionUtils.getCursorType(cursor)
            updateStore(prev => {
              ...prev,
              elements: prev.elements->ElementUtils.resizeRectInElements(resizedRect),
            })
          | Line(line) =>
            let resizedLine = line->SelectionUtils.resizeLine(clientX, clientY, corner)
            updateStore(prev => {
              ...prev,
              elements: prev.elements->ElementUtils.resizeLineInElements(resizedLine),
            })
          }
        )
      | _ => ()
      }
    | Some(Selecting(selection)) =>
      let selectedElements =
        elements->Array.filter(element => ElementUtils.intersectsSelection(element, selection))
      let {x, y} = selection
      updateStore(prev => {
        ...prev,
        state: Selection(Selecting({x, y, width: clientX -. x, height: clientY -. y})),
        selectedElementIds: selectedElements->Array.map(ElementUtils.getElementId),
      })
    }
  },
  onEnd: ({target, store: {state}, updateStore}) => {
    let state = StateUtils.getSelectionState(state)

    switch state {
    | None => ()
    | Some(Idle) =>
      updateStore(prev => {
        ...prev,
        state: Selection(Idle),
      })
    | Some(Resizing(Start | End)) =>
      target.style.cursor = "grab"
      updateStore(prev => {
        ...prev,
        state: Selection(Idle),
      })
    | Some(Resizing(_)) =>
      updateStore(prev => {
        ...prev,
        state: Selection(Idle),
      })
    | Some(Moving(move)) =>
      target.style.cursor = "default"
      if SelectionUtils.didMove(move) {
        // If the user moved the selection and released the mouse,
        // the selection tool should go back to idle, keeping the
        // selected elements
        updateStore(prev => {...prev, state: Selection(Idle)})
      } else {
        // If the user didn't move the selection, check if they clicked
        // on an element and if so, select it, otherwise go back to idle
        // without changing the selected elements
        updateStore(prev => {
          let clickedElement = ElementUtils.getElementAtPoint(
            prev.elements,
            move.target.x,
            move.target.y,
          )
          switch clickedElement {
          | Some(clickedElement)
            if clickedElement->ElementUtils.isElementSelected(
              ~selectedElementIds=prev.selectedElementIds,
            ) => {
              ...prev,
              state: Selection(Idle),
              selectedElementIds: [ElementUtils.getElementId(clickedElement)],
            }
          | Some(_) | None => {...prev, state: Selection(Idle)}
          }
        })
      }
    | Some(Selecting(selection)) =>
      // Check if the user's intention was to click or drag
      // with a tolerance of 2 pixels
      if SelectionUtils.isClick(selection, 2.) {
        updateStore(prev => {...prev, state: Selection(Idle)})
      } else {
        updateStore(prev => {
          let selectedElements =
            prev.elements->Array.filter(element =>
              ElementUtils.intersectsSelection(element, selection)
            )
          {
            ...prev,
            state: Selection(Idle),
            selectedElementIds: selectedElements->Array.map(ElementUtils.getElementId),
          }
        })
      }
    }
  },
}
