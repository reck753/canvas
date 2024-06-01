open Canvas__Models
module CanvasUtils = Canvas__CanvasUtils

let handler = (
  e: JsxEvent.Mouse.t,
  ~offsetX,
  ~offsetY,
  ~store: Store.t,
  ~tools: array<Tool.t>,
  ~updateStore,
) => {
  let target = e->PervasivesU.JsxEvent.Mouse.target->CanvasUtils.JsxEventFixed.Mouse.target
  let clientX = e->CanvasUtils.getClientX->CanvasUtils.normalizeClientX(offsetX)
  let clientY = e->CanvasUtils.getClientY->CanvasUtils.normalizeClientY(offsetY)
  let selectedTool = tools->Array.find(tool => tool.toolId === store.selectedToolId)

  selectedTool->Option.forEach(selectedTool => {
    selectedTool.onEnd({
      clientX,
      clientY,
      store,
      updateStore,
      target,
      tools,
    })
  })
}
