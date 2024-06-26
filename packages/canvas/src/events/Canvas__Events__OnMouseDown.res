open Canvas__Models
module CanvasUtils = Canvas__CanvasUtils
module ElementUtils = Canvas__ElementUtils

let handler = (
  e: JsxEvent.Mouse.t,
  ~offsetX,
  ~offsetY,
  ~store: Store.t<'meta>,
  ~tools: array<Tool.t<'meta>>,
  ~updateStore,
) => {
  // Default is prevented so that mouse events wouldn't interact
  // with the outside world (e.g. selecting text on double click)
  e->PervasivesU.JsxEvent.Mouse.preventDefault
  let target = e->PervasivesU.JsxEvent.Mouse.target->CanvasUtils.JsxEventFixed.Mouse.target
  let clientX = e->CanvasUtils.getClientX->CanvasUtils.normalizeClientX(offsetX)
  let clientY = e->CanvasUtils.getClientY->CanvasUtils.normalizeClientY(offsetY)
  let highestZIndex = store.elements->Array.reduce(0., (acc, element: element<'meta>) =>
    switch element {
    | Line({zIndex}) | Rect({zIndex}) => Math.max(acc, zIndex)
    }
  )
  let nextZIndex = highestZIndex +. 1.

  if e->CanvasUtils.JsxEventFixed.Mouse.detail === 2 {
    ElementUtils.invokeOnDoubleClick(~clientX, ~clientY, ~store, ~tools, ~target, ~updateStore)
  } else {
    let selectedTool = tools->Array.find(tool => tool.toolId === store.selectedToolId)
    selectedTool->Option.forEach(selectedTool => {
      selectedTool.onStart({
        clientX,
        clientY,
        store,
        nextIndex: nextZIndex,
        updateStore,
        target,
        tools,
      })
    })
  }
}
