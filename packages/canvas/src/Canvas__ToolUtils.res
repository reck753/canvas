open Canvas__Models
module CanvasStyle = Canvas__Style

let defaultStyle: Tool.style = {lineWidth: CanvasStyle.elementLineWidth}

let getStyle: Tool.t<'meta> => option<Tool.style> = tool =>
  switch tool.engine {
  | Rect({?lineWidth}) => Some({lineWidth: ?lineWidth})
  | Line({?lineWidth}) => Some({lineWidth: ?lineWidth})
  | Selection => None
  }

let getOptStyleWithDefaults: option<Tool.t<'meta>> => Tool.style = tool =>
  switch tool->Option.flatMap(getStyle) {
  | Some(style) => style
  | None => defaultStyle
  }

let getLineWidth: Tool.style => float = style =>
  style.lineWidth->Option.getOr(CanvasStyle.elementLineWidth)
