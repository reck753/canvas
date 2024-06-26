open Canvas__Models
module ElementUtils = Canvas__ElementUtils
module StateUtils = Canvas__StateUtils

let tool: Tool.t<unit> = {
  toolId: "line",
  engine: Line({
    canResizeStart: true,
    canResizeEnd: true,
  }),
  onStart: ({
    clientX,
    clientY,
    store: {selectedToolId, state, snapToGrid},
    nextIndex,
    updateStore,
  }) => {
    let state = StateUtils.getLineState(state)

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
      let element: element<'meta> = Line({
        id: RescriptUuid.make(),
        toolId: selectedToolId,
        zIndex: nextIndex,
        start: {x, y},
        end: {x, y},
        label: None,
      })
      updateStore(prev => {
        ...prev,
        state: Line(Drawing),
        elements: prev.elements->Array.concat([element]),
      })
    }
  },
  onMove: ({clientX, clientY, store: {state, elements}, target, updateStore}) => {
    let state = StateUtils.getLineState(state)
    let position = elements->Array.length - 1
    let element = elements->Array.get(position)

    switch state {
    | None => ()
    | Some(Idle) => target.style.cursor = "crosshair"
    | Some(Drawing) =>
      switch element {
      | Some(Line(line)) =>
        let element: element<'meta> = Line({
          ...line,
          end: {x: clientX, y: clientY},
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
    let state = StateUtils.getLineState(state)
    switch state {
    | Some(Idle)
    | Some(Drawing) =>
      switch snapToGrid {
      | No => updateStore(prev => {...prev, state: Line(Idle), selectedElementIds: []})
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
            state: Line(Idle),
            selectedElementIds: [],
          })
        | None => updateStore(prev => {...prev, state: Rect(Idle), selectedElementIds: []})
        }
      }
    | None => ()
    }
  },
}
