import { useLayoutEffect, useState } from "react";
import { cn } from "@canvas/tailwind-utils/src";
import { Store, Tool, State, Element } from "@canvas/canvas/src/models";
import {
  getElementId,
  getLineCenterForText,
  getRectCenterForText,
  isSelected,
  roundNumberBySnapGridSize,
  updateElementLabel,
} from "@canvas/canvas/src/element_utils";
import {
  onMouseDownHandler,
  onMouseMoveHandler,
  onMouseUpHandler,
} from "@canvas/canvas/src/events/events";
import CanvasStyle from "@canvas/canvas/src/style";
import {
  getOptStyleWithDefaults,
  getLineWidth,
} from "@canvas/canvas/src/tool-utils";
import { defaultTools } from "@canvas/canvas/src/tools/tools";
import { getRectState } from "@canvas/canvas/src/state-utils";
import { v4 } from "uuid";

const getActiveStateDisplay = (state: State) => {
  if (state.type === "Selection") {
    if (state._0 === "Idle") {
      return "Selection Idle";
    } else if (state._0.type === "Selecting") {
      return "Selecting";
    } else if (state._0.type === "Moving") {
      return "Moving";
      // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
    } else if (state._0.type === "Resizing") {
      return "Resizing";
    }
    return "Unknown Selection State";
  } else if (state.type === "Rect") {
    if (state._0 === "Idle") {
      return "Rect Idle";
      // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
    } else if (state._0 === "Drawing") {
      return "Drawing a rectangle";
    }
    return "Unknown Rect State";
    // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
  } else if (state.type === "Line") {
    if (state._0 === "Idle") {
      return "Line Idle";
      // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
    } else if (state._0 === "Drawing") {
      return "Drawing a line";
    }
    return "Unknown Line State";
  }
};

const SelectedElementEditor = ({
  selectedElement,
  onUpdateElementLabel,
}: {
  selectedElement: Element | undefined;
  onUpdateElementLabel: (id: string, label: string | undefined) => void;
}) => {
  if (selectedElement === undefined) {
    return null;
  }

  const label = selectedElement._0.label;
  const zIndex = selectedElement._0.zIndex;
  const id = selectedElement._0.id;

  return (
    <div className="flex flex-col gap-2">
      <span>{"Selected element: " + (label ?? zIndex)}</span>
      <input
        placeholder="Label"
        value={label ?? ""}
        onChange={e => {
          e.preventDefault();
          const value = e.target.value;
          const label = value === "" ? undefined : value;
          onUpdateElementLabel(id, label);
        }}
        className="max-w-[400px] border rounded p-2 h-10"
      />
    </div>
  );
};

const tools: Tool[] = [
  ...defaultTools,
  {
    toolId: "square4",
    engine: {
      type: "Rect",
      _0: { canResizeVertically: false, canResizeHorizontally: false },
    },
    onMove: () => {},
    onEnd: () => {},
    onStart: ({
      clientX,
      clientY,
      store: { selectedToolId, state, snapToGrid },
      nextIndex,
      target,
      updateStore,
    }) => {
      const rectState = getRectState(state);
      const size = 40;

      const { x, y } =
        snapToGrid === "No"
          ? { x: clientX, y: clientY }
          : {
              x: roundNumberBySnapGridSize(clientX, snapToGrid._0),
              y: roundNumberBySnapGridSize(clientY, snapToGrid._0),
            };

      if (rectState === "Idle") {
        const element: Element = {
          type: "Rect",
          _0: {
            id: v4(),
            zIndex: nextIndex,
            toolId: selectedToolId,
            x: x - size / 2,
            y: y - size / 2,
            width: size,
            height: size,
            label: undefined,
          },
        };
        target.style.cursor = "default";
        updateStore(prev => ({
          ...prev,
          selectedToolId: "selection",
          state: { type: "Selection", _0: "Idle" },
          elements: prev.elements.concat([element]),
        }));
      }
    },
    onDoubleClick: ({ clickedElement }) => {
      console.log(
        "onDoubleClick",
        clickedElement._0.toolId,
        clickedElement._0.id
      );
    },
  },
];

const offsetX = 100;
const offsetY = 100;

export const TypescriptExample = () => {
  const [store, setStore] = useState<Store>({
    state: { type: "Selection", _0: "Idle" },
    snapToGrid: { type: "Yes", _0: 10.0 },
    selectedToolId: "selection",
    selectedElementIds: [],
    elements: [],
  });

  useLayoutEffect(() => {
    const canvas = document.getElementById(
      "canvas"
    ) as HTMLCanvasElement | null;
    const ctx = canvas?.getContext("2d") || null;

    if (ctx && canvas) {
      const font = CanvasStyle.font;

      // Clear the canvas
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      // Draw the elements
      ctx.strokeStyle = CanvasStyle.elementStroke;
      store.elements.forEach(element => {
        const elementTool = tools.find(
          tool => tool.toolId === element._0.toolId
        );
        const selected = isSelected(element._0.id, store.selectedElementIds);
        const style = getOptStyleWithDefaults(elementTool);
        ctx.lineWidth = getLineWidth(style);
        ctx.strokeStyle = selected
          ? CanvasStyle.selectedElementStroke
          : CanvasStyle.elementStroke;

        if (element.type === "Line") {
          const { start, end, zIndex, label } = element._0;
          ctx.beginPath();
          ctx.moveTo(start.x, start.y);
          ctx.lineTo(end.x, end.y);
          ctx.stroke();

          // TODO Remove this when you're done with testing
          ctx.font = font;
          ctx.fillStyle = selected
            ? CanvasStyle.selectedElementStroke
            : "black";
          const text = label ?? zIndex.toString();
          const lineCenter = getLineCenterForText(element._0, text, font);
          ctx.fillText(text, lineCenter.x, lineCenter.y);
          // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
        } else if (element.type === "Rect") {
          const { x, y, width, height, zIndex, label } = element._0;
          ctx.fillStyle = selected
            ? CanvasStyle.selectedRectFill
            : CanvasStyle.rectFill;
          ctx.strokeRect(x, y, width, height);
          ctx.fillRect(x, y, width, height);

          // TODO Remove this when you're done with testing
          ctx.font = font;
          ctx.fillStyle = selected
            ? CanvasStyle.selectedElementStroke
            : "black";
          const text = label ?? zIndex.toString();
          const rectCenter = getRectCenterForText(element._0, text, font);
          ctx.fillText(text, rectCenter.x, rectCenter.y);
        }
      });

      if (store.state.type === "Selection") {
        if (store.state._0 !== "Idle") {
          if (store.state._0.type === "Selecting") {
            const { x, y, width, height } = store.state._0._0;
            ctx.strokeStyle = CanvasStyle.selectionBoxStroke;
            ctx.fillStyle = CanvasStyle.selectionBoxFill;
            ctx.lineWidth = CanvasStyle.selectionBoxLineWidth;
            ctx.strokeRect(x, y, width, height);
            ctx.fillRect(x, y, width, height);
          }
        }
      }
    }

    return undefined;
  }, [store]);

  const handleMouseDown = (e: React.MouseEvent<HTMLCanvasElement>) => {
    onMouseDownHandler(e, offsetX, offsetY, store, tools, setStore);
  };

  const handleMouseMove = (e: React.MouseEvent<HTMLCanvasElement>) => {
    onMouseMoveHandler(e, offsetX, offsetY, store, tools, setStore);
  };

  const handleMouseUp = (e: React.MouseEvent<HTMLCanvasElement>) => {
    onMouseUpHandler(e, offsetX, offsetY, store, tools, setStore);
  };

  return (
    <div>
      <canvas
        id="canvas"
        className="border border-black w-[700px] h-[500px] bg-white"
        width="700px"
        height="500px"
        onMouseDown={handleMouseDown}
        onMouseMove={handleMouseMove}
        onMouseUp={handleMouseUp}
      >
        Canvas is not supported in your browser.
      </canvas>
      <div className="flex gap-2 pt-2 px-2 justify-between w-[700px]">
        <div className="flex gap-2">
          {tools.map(tool => {
            return (
              <button
                key={tool.toolId}
                onClick={_e => {
                  setStore(prev => ({
                    ...prev,
                    selectedToolId: tool.toolId,
                    selectedElementIds: [],
                    state:
                      tool.engine === "Selection"
                        ? { type: "Selection", _0: "Idle" }
                        : tool.engine.type === "Rect"
                        ? { type: "Rect", _0: "Idle" }
                        : { type: "Line", _0: "Idle" },
                  }));
                }}
                className={cn(
                  "size-10 flex justify-center items-center border rounded",
                  store.selectedToolId === tool.toolId
                    ? "bg-white text-black"
                    : "bg-black text-white"
                )}
              >
                {tool.toolId.charAt(0).toUpperCase() +
                  tool.toolId.charAt(tool.toolId.length - 1).toUpperCase()}
              </button>
            );
          })}
        </div>
        <button
          className="size-10 flex justify-center items-center border rounded"
          onClick={_e => {
            // Remove selected elements from the elements array
            setStore(prev => ({
              ...prev,
              selectedElementIds: [],
              elements: prev.elements.filter(element => {
                const id = getElementId(element);
                return !isSelected(id, prev.selectedElementIds);
              }),
            }));
          }}
        >
          X
        </button>
      </div>
      <span>{getActiveStateDisplay(store.state)}</span>
      {store.selectedElementIds.length === 1 ? (
        <SelectedElementEditor
          selectedElement={store.elements.find(
            element => element._0.id === store.selectedElementIds[0]
          )}
          onUpdateElementLabel={(id, label) => {
            setStore(prev => {
              const elements = updateElementLabel(prev.elements, id, label);
              return { ...prev, elements };
            });
          }}
        />
      ) : null}
    </div>
  );
};
