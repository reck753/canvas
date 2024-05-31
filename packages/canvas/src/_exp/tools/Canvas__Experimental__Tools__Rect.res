open Canvas__Experimental__Models
module ElementUtils = Canvas__Experimental__ElementUtils
module SelectionUtils = Canvas__Experimental__SelectionUtils
module StateUtils = Canvas__Experimental__StateUtils

let tool: Tool.t = {
  toolId: "rect",
  engine: Rect({
    canResizeVertically: true,
    canResizeHorizontally: true,
  }),
  onStart: ({
    clientX,
    clientY,
    store: {selectedToolId, state, snapToGrid},
    nextIndex,
    updateStore,
  }) => {
    let state = StateUtils.getRectState(state)

    let (x, y) = switch snapToGrid {
    | No => (clientX, clientY)
    | Yes(gridSize) => (
        ElementUtils.roundNumberBySnapGridSize(clientX, ~gridSize),
        ElementUtils.roundNumberBySnapGridSize(clientY, ~gridSize),
      )
    }

    switch state {
    | None => ()
    | Some(Drawing) => ()
    | Some(Idle) =>
      let element: element = Rect({
        id: RescriptUuid.make(),
        zIndex: nextIndex,
        toolId: selectedToolId,
        x,
        y,
        width: 0.,
        height: 0.,
        label: None,
      })
      updateStore(prev => {
        ...prev,
        state: Rect(Drawing),
        elements: prev.elements->Array.concat([element]),
      })
    }
  },
  onMove: ({clientX, clientY, store: {state, elements}, target, updateStore}) => {
    let state = StateUtils.getRectState(state)
    let position = elements->Array.length - 1
    let element = elements->Array.get(position)

    switch state {
    | None => ()
    | Some(Idle) => target.style.cursor = "crosshair"
    | Some(Drawing) =>
      switch element {
      | Some(Rect(rect)) =>
        let element: element = Rect({
          ...rect,
          width: clientX -. rect.x,
          height: clientY -. rect.y,
        })
        updateStore(prev => {
          ...prev,
          elements: ElementUtils.updateElementAtPosition(
            ~elements=prev.elements,
            ~position,
            ~element,
          ),
        })
      | Some(_) => ()
      | None => ()
      }
    }
  },
  onEnd: ({store: {state, snapToGrid, elements}, updateStore}) => {
    let state = StateUtils.getRectState(state)
    switch state {
    | Some(Idle)
    | Some(Drawing) =>
      // This snapping logic is redundant because the element should have already
      // been snapped to the grid in the onStart handler. Keeping just in case.
      switch snapToGrid {
      | No => updateStore(prev => {...prev, state: Rect(Idle), selectedElementIds: []})
      | Yes(gridSize) =>
        let position = elements->Array.length - 1
        let element = elements->Array.get(position)
        switch element {
        | Some(element) =>
          let element = ElementUtils.snapElementToGrid(element, ~gridSize)
          updateStore(prev => {
            ...prev,
            elements: ElementUtils.updateElementAtPosition(
              ~elements=prev.elements,
              ~position,
              ~element,
            ),
            state: Rect(Idle),
            selectedElementIds: [],
          })
        | None => updateStore(prev => {...prev, state: Rect(Idle), selectedElementIds: []})
        }
      }
    | None => ()
    }
  },
}
