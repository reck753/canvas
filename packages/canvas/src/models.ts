import {
  Tool_t,
  Store_t,
  State_t,
  element,
  Tool_style,
} from "./Canvas__Models.gen";

export type Tool<Meta> = Tool_t<Meta>;
export type ToolStyle = Tool_style;
export type Store<Meta> = Store_t<Meta>;
export type State = State_t;
export type Element<Meta> = element<Meta>;
