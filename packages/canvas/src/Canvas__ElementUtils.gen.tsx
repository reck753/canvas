/* TypeScript file generated from Canvas__ElementUtils.resi by genType. */

/* eslint-disable */
/* tslint:disable */

import * as Canvas__ElementUtilsJS from './Canvas__ElementUtils.bs.js';

import type {Line_t as Canvas__Models_Line_t} from './Canvas__Models.gen';

import type {Rect_t as Canvas__Models_Rect_t} from './Canvas__Models.gen';

import type {Vec_t as Canvas__Models_Vec_t} from './Canvas__Models.gen';

import type {element as Canvas__Models_element} from './Canvas__Models.gen';

export const getElementId: <meta>(_1:Canvas__Models_element<meta>) => string = Canvas__ElementUtilsJS.getElementId as any;

export const isSelected: (_1:string, _2:string[]) => boolean = Canvas__ElementUtilsJS.isSelected as any;

export const getLineCenterForText: <meta>(_1:Canvas__Models_Line_t<meta>, text:string, font:string) => Canvas__Models_Vec_t = Canvas__ElementUtilsJS.getLineCenterForText as any;

export const getRectCenterForText: <meta>(_1:Canvas__Models_Rect_t<meta>, text:string, font:string) => Canvas__Models_Vec_t = Canvas__ElementUtilsJS.getRectCenterForText as any;

export const updateElementLabel: <meta>(_1:Canvas__Models_element<meta>[], id:string, label:(undefined | string)) => Canvas__Models_element<meta>[] = Canvas__ElementUtilsJS.updateElementLabel as any;

export const roundNumberBySnapGridSize: (_1:number, gridSize:number) => number = Canvas__ElementUtilsJS.roundNumberBySnapGridSize as any;
