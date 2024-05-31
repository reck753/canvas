let getClientX = (e: JsxEvent.Mouse.t) => e->PervasivesU.JsxEvent.Mouse.clientX->Int.toFloat
let getClientY = (e: JsxEvent.Mouse.t) => e->PervasivesU.JsxEvent.Mouse.clientY->Int.toFloat

let normalizeClientX = (clientX: float, offsetX: float) => clientX -. offsetX
let normalizeClientY = (clientY: float, offsetY: float) => clientY -. offsetY

module JsxEventFixed = {
  module Mouse = {
    type style = {mutable cursor: string}
    type target = {style: style}

    external target: {..} => target = "%identity"
    @get external detail: JsxEvent.Mouse.t => int = "detail"
  }
}
