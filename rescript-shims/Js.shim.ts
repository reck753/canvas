export type Json_t = unknown;

export interface Dict_t<T> {
  [k: string]: T;
}

export type Exn_t = Error;

export type Types_obj_val = Record<string | number, any>;
