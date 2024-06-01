import { tool as LineToolInternal } from "./Canvas__Tools__Line.gen";
import { tool as RectToolInternal } from "./Canvas__Tools__Rect.gen";
import { tool as SelectionToolInternal } from "./Canvas__Tools__Selection.gen";

export const LineTool = LineToolInternal;
export const RectTool = RectToolInternal;
export const SelectionTool = SelectionToolInternal;

export const defaultTools = [SelectionTool, RectTool, LineTool];
