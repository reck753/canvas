open Canvas.Models
module Document = RescriptGlobal.Document
module ElementUtils = Canvas.ElementUtils
module StateUtils = Canvas.StateUtils
module ToolUtils = Canvas.ToolUtils
module CanvasStyle = Canvas.Style
module Tools = Canvas.Tools
module Events = Canvas.Events

// Accept through props instead
let tools: array<Tool.t> = [
  Tools.Selection.tool,
  Tools.Rect.tool,
  Tools.Line.tool,
  {
    ...Tools.Line.tool,
    toolId: "line1",
    engine: Line({
      canResizeStart: false,
      canResizeEnd: false,
      lineWidth: 4.,
    }),
  },
  {
    toolId: "rect1",
    engine: Rect({
      canResizeVertically: false,
      canResizeHorizontally: false,
    }),
    onStart: ({
      clientX,
      clientY,
      store: {selectedToolId, state, snapToGrid},
      nextIndex,
      target,
      updateStore,
    }) => {
      let state = StateUtils.getRectState(state)
      let size = 40.

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
          x: x -. size /. 2.,
          y: y -. size /. 2.,
          width: size,
          height: size,
          label: None,
        })
        target.style.cursor = "default"
        updateStore(prev => {
          ...prev,
          selectedToolId: "selection",
          state: Selection(Idle),
          elements: prev.elements->Array.concat([element]),
        })
      }
    },
    onMove: _ => (),
    onEnd: _ => (),
    onDoubleClick: ({clickedElement}) => {
      Console.log3(
        "onDoubleClick",
        clickedElement->ElementUtils.getToolId,
        clickedElement->ElementUtils.getElementId,
      )
    },
  },
]

// Accept these values through props instead
let offsetX = 100.
let offsetY = 100.

@react.component
let make = () => {
  let (store, setStore) = React.useState(() => {
    Store.state: Selection(Idle),
    snapToGrid: Yes(10.),
    selectedToolId: "selection",
    selectedElementIds: [],
    elements: [],
  })

  React.useLayoutEffect(() => {
    let canvas = Document.init->Document.getElementById("canvas")->Nullable.toOption
    let ctx =
      canvas->Option.flatMap(canvas => canvas->Document.Element.getContext("2d")->Nullable.toOption)

    switch ctx {
    | Some(ctx) =>
      let canvas: Document.Element.t = canvas->Option.getExn
      let font = CanvasStyle.font
      // Clear the canvas
      ctx.clearRect(~x=0., ~y=0., ~width=canvas.width, ~height=canvas.height)

      // Draw the elements
      ctx.strokeStyle = CanvasStyle.elementStroke
      store.elements->Array.forEach(element => {
        let elementTool = tools->Array.find(tool => tool.toolId === element->ElementUtils.getToolId)
        let isSelected = ElementUtils.isSelected(
          ElementUtils.getElementId(element),
          store.selectedElementIds,
        )
        let style = ToolUtils.getOptStyleWithDefaults(elementTool)
        ctx.lineWidth = ToolUtils.getLineWidth(style)
        if isSelected {
          ctx.strokeStyle = CanvasStyle.selectedElementStroke
        } else {
          ctx.strokeStyle = CanvasStyle.elementStroke
        }
        switch element {
        | Line(line) =>
          let {start, end, zIndex, label} = line
          ctx.beginPath()
          ctx.moveTo(~x=start.x, ~y=start.y)
          ctx.lineTo(~x=end.x, ~y=end.y)
          ctx.stroke()

          // TODO Remove this when you're done with testing
          ctx.font = font
          if isSelected {
            ctx.fillStyle = CanvasStyle.selectedElementStroke
          } else {
            ctx.fillStyle = "black"
          }
          let text = label->Option.getOr(zIndex->Float.toString)
          let lineCenter = ElementUtils.getLineCenterForText(line, ~text, ~font)
          ctx.fillText(~text, ~x=lineCenter.x, ~y=lineCenter.y)
        | Rect(rect) =>
          let {x, y, width, height, zIndex, label} = rect
          if isSelected {
            ctx.fillStyle = CanvasStyle.selectedRectFill
          } else {
            ctx.fillStyle = CanvasStyle.rectFill
          }
          ctx.strokeRect(~x, ~y, ~width, ~height)
          ctx.fillRect(~x, ~y, ~width, ~height)

          // TODO Remove this when you're done with testing
          ctx.font = font
          if isSelected {
            ctx.fillStyle = CanvasStyle.selectedElementStroke
          } else {
            ctx.fillStyle = "black"
          }
          let text = label->Option.getOr(zIndex->Float.toString)
          let rectCenter = ElementUtils.getRectCenterForText(rect, ~text, ~font)
          ctx.fillText(~text, ~x=rectCenter.x, ~y=rectCenter.y)
        }
      })
      switch store.state {
      | Selection(Selecting({x, y, width, height})) =>
        ctx.strokeStyle = CanvasStyle.selectionBoxStroke
        ctx.fillStyle = CanvasStyle.selectionBoxFill
        ctx.lineWidth = CanvasStyle.selectionBoxLineWidth
        ctx.strokeRect(~x, ~y, ~width, ~height)
        ctx.fillRect(~x, ~y, ~width, ~height)
      | _ => ()
      }
    | None => ()
    }

    None
  }, [store])

  let handleMouseDown = (e: JsxEvent.Mouse.t) => {
    e->Events.OnMouseDown.handler(~offsetX, ~offsetY, ~store, ~tools, ~updateStore=setStore)
  }

  let handleMouseMove = (e: JsxEvent.Mouse.t) => {
    e->Events.OnMouseMove.handler(~offsetX, ~offsetY, ~store, ~tools, ~updateStore=setStore)
  }

  let handleMouseUp = (e: JsxEvent.Mouse.t) => {
    e->Events.OnMouseUp.handler(~offsetX, ~offsetY, ~store, ~tools, ~updateStore=setStore)
  }

  <div>
    <canvas
      id="canvas"
      className="border border-black w-[700px] h-[500px] bg-white"
      width="700px"
      height="500px"
      onMouseDown=handleMouseDown
      onMouseMove=handleMouseMove
      onMouseUp=handleMouseUp>
      {"Canvas is not supported in your browser."->React.string}
    </canvas>
    <div className="flex gap-2 pt-2 px-2 justify-between w-[700px]">
      <div className="flex gap-2">
        {tools
        ->Array.map(tool => {
          <button
            key=tool.toolId
            onClick={_e =>
              setStore(prev => {
                ...prev,
                selectedToolId: tool.toolId,
                selectedElementIds: [],
                state: switch tool.engine {
                | Selection => Selection(Idle)
                | Rect(_) => Rect(Idle)
                | Line(_) => Line(Idle)
                },
              })}
            className={TailwindUtils.cn([
              "size-10 flex justify-center items-center border rounded",
              store.selectedToolId === tool.toolId ? "bg-white text-black" : "bg-black text-white",
            ])}>
            {(tool.toolId->String.charAt(0)->String.toUpperCase ++
              tool.toolId
              ->String.charAt(tool.toolId->String.length - 1)
              ->String.toUpperCase)->React.string}
          </button>
        })
        ->React.array}
      </div>
      <button
        className="size-10 flex justify-center items-center border rounded"
        onClick={_e => {
          // Remove selected elements from the elements array
          setStore(prev => {
            ...prev,
            selectedElementIds: [],
            elements: prev.elements->Array.filter(element => {
              let id = ElementUtils.getElementId(element)
              !ElementUtils.isSelected(id, prev.selectedElementIds)
            }),
          })
        }}>
        {"X"->React.string}
      </button>
    </div>
    <span>
      {switch store.state {
      | Selection(Selecting(_)) => "Selecting"
      | Selection(Moving(_)) => "Moving"
      | Selection(Resizing(_)) => "Resizing"
      | Rect(Drawing) => "Drawing a rectangle"
      | Line(Drawing) => "Drawing a line"
      | Selection(Idle) => "Selection Idle"
      | Rect(Idle) => "Rect Idle"
      | Line(Idle) => "Line Idle"
      }->React.string}
    </span>
    {switch store.selectedElementIds->Array.length {
    | 1 =>
      let selectedElement = store.elements->Array.find(element => {
        ElementUtils.getElementId(element) === store.selectedElementIds->Array.getUnsafe(0)
      })
      switch selectedElement {
      | None => React.null
      | Some(Line({id, zIndex, label}))
      | Some(Rect({id, zIndex, label})) =>
        <div className="flex flex-col gap-2">
          <span>
            {("Selected element: " ++ label->Option.getOr(zIndex->Float.toString))->React.string}
          </span>
          <input
            placeholder="Label"
            value={label->Option.getOr("")}
            onChange={e => {
              e->JsxEvent.Form.preventDefault
              let value = (e->JsxEvent.Form.target)["value"]
              let label = value === "" ? None : Some(value)
              setStore(prev => {
                ...prev,
                elements: prev.elements->ElementUtils.updateElementLabel(~id, ~label),
              })
            }}
            className="max-w-[400px] border rounded p-2 h-10"
          />
        </div>
      }
    | _ => React.null
    }}
  </div>
}
