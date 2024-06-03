/* TypeScript file generated from Canvas__Models.resi by genType. */

/* eslint-disable */
/* tslint:disable */

import type {JsxEventFixed_Mouse_target as Canvas__CanvasUtils_JsxEventFixed_Mouse_target} from './Canvas__CanvasUtils.gen';

export type Vec_t = { readonly x: number; readonly y: number };

export type Rect_t<meta> = {
  readonly id: string; 
  readonly toolId: string; 
  readonly zIndex: number; 
  readonly label: (undefined | string); 
  readonly metadata?: meta; 
  readonly x: number; 
  readonly y: number; 
  readonly width: number; 
  readonly height: number
};

export type Rect_state = "Idle" | "Drawing";

export type Line_t<meta> = {
  readonly id: string; 
  readonly toolId: string; 
  readonly zIndex: number; 
  readonly label: (undefined | string); 
  readonly metadata?: meta; 
  readonly start: Vec_t; 
  readonly end: Vec_t
};

export type Line_state = "Idle" | "Drawing";

export type element<meta> = 
    { type: "Line"; _0: Line_t<meta> }
  | { type: "Rect"; _0: Rect_t<meta> };

export type Corner_t = 
    "Start"
  | "End"
  | "TopLeft"
  | "TopRight"
  | "BottomLeft"
  | "BottomRight"
  | "Top"
  | "Bottom"
  | "Left"
  | "Right";

export type Selection_t = {
  readonly x: number; 
  readonly y: number; 
  readonly width: number; 
  readonly height: number
};

export type Selection_move = { readonly origin: Vec_t; readonly target: Vec_t };

export type Selection_state = 
    "Idle"
  | { type: "Selecting"; _0: Selection_t }
  | { type: "Moving"; _0: Selection_move }
  | { type: "Resizing"; _0: Corner_t };

export type State_t = 
    { type: "Selection"; _0: Selection_state }
  | { type: "Rect"; _0: Rect_state }
  | { type: "Line"; _0: Line_state };

export type Store_snapToGrid = "No" | { type: "Yes"; _0: number };

export type Store_t<meta> = {
  readonly state: State_t; 
  readonly snapToGrid: Store_snapToGrid; 
  readonly selectedToolId: string; 
  readonly selectedElementIds: string[]; 
  readonly elements: element<meta>[]
};

export type Tool_onStartArguments<tool,meta> = {
  readonly clientX: number; 
  readonly clientY: number; 
  readonly store: Store_t<meta>; 
  readonly updateStore: (_1:((_1:Store_t<meta>) => Store_t<meta>)) => void; 
  readonly target: Canvas__CanvasUtils_JsxEventFixed_Mouse_target; 
  readonly tools: tool[]; 
  readonly nextIndex: number
};

export type Tool_onMoveArguments<tool,meta> = {
  readonly clientX: number; 
  readonly clientY: number; 
  readonly store: Store_t<meta>; 
  readonly updateStore: (_1:((_1:Store_t<meta>) => Store_t<meta>)) => void; 
  readonly target: Canvas__CanvasUtils_JsxEventFixed_Mouse_target; 
  readonly tools: tool[]
};

export type Tool_onEndArguments<tool,meta> = {
  readonly clientX: number; 
  readonly clientY: number; 
  readonly store: Store_t<meta>; 
  readonly updateStore: (_1:((_1:Store_t<meta>) => Store_t<meta>)) => void; 
  readonly target: Canvas__CanvasUtils_JsxEventFixed_Mouse_target; 
  readonly tools: tool[]
};

export type Tool_onDoubleClickArguments<tool,meta> = {
  readonly tools: tool[]; 
  readonly clickedElement: element<meta>; 
  readonly store: Store_t<meta>; 
  readonly updateStore: (_1:((_1:Store_t<meta>) => Store_t<meta>)) => void; 
  readonly target: Canvas__CanvasUtils_JsxEventFixed_Mouse_target
};

export type Tool_style = { readonly lineWidth?: number };

export type Tool_rectSettings = {
  readonly lineWidth?: number; 
  readonly canResizeVertically?: boolean; 
  readonly canResizeHorizontally?: boolean
};

export type Tool_lineSettings = {
  readonly lineWidth?: number; 
  readonly canResizeStart?: boolean; 
  readonly canResizeEnd?: boolean
};

export type Tool_engine = 
    "Selection"
  | { type: "Rect"; _0: Tool_rectSettings }
  | { type: "Line"; _0: Tool_lineSettings };

export type Tool_t<meta> = {
  readonly toolId: string; 
  readonly engine: Tool_engine; 
  readonly onStart: (_1:Tool_onStartArguments<Tool_t<meta>,meta>) => void; 
  readonly onMove: (_1:Tool_onMoveArguments<Tool_t<meta>,meta>) => void; 
  readonly onEnd: (_1:Tool_onEndArguments<Tool_t<meta>,meta>) => void; 
  readonly onDoubleClick?: (_1:Tool_onDoubleClickArguments<Tool_t<meta>,meta>) => void
};
