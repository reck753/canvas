let getClientX: JsxEvent.Mouse.t => float
let getClientY: JsxEvent.Mouse.t => float
let normalizeClientX: (float, float) => float
let normalizeClientY: (float, float) => float
module JsxEventFixed: {
  module Mouse: {
    type style = {mutable cursor: string}
    @genType
    type target = {style: style}
    external target: {..} => target = "%identity"
    @get external detail: JsxEvent.Mouse.t => int = "detail"
  }
}
