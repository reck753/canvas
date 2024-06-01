// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Utils from "./utils";
import * as Core__Option from "@rescript/core/src/Core__Option.bs.js";
import * as Utils__Array from "../../utils/src/array/Utils__Array.bs.js";
import * as Canvas__Constants from "./Canvas__Constants.bs.js";
import * as Canvas__SelectionUtils from "./Canvas__SelectionUtils.bs.js";

function getElementId(element) {
  return element._0.id;
}

function getElementZIndex(element) {
  return element._0.zIndex;
}

function getToolId(element) {
  return element._0.toolId;
}

function updateElementAtPosition(elements, position, element) {
  var copy = elements.slice();
  copy[position] = element;
  return copy;
}

function isSelected(elementId, selectedElementIds) {
  return selectedElementIds.some(function (selectedElementId) {
              return selectedElementId === elementId;
            });
}

function intersectsSelection(element, selection) {
  if (element.TAG === "Line") {
    return Canvas__SelectionUtils.lineIntersectsSelection(element._0, selection, Canvas__Constants.tolerance);
  } else {
    return Canvas__SelectionUtils.rectIntersectsSelection(element._0, selection);
  }
}

function getElementAtPoint(elements, clientX, clientY, givenTolerance) {
  var sortedElements = Utils__Array.toSorted(elements, (function (a, b) {
          return b._0.zIndex - a._0.zIndex;
        }));
  return sortedElements.find(function (element) {
              if (element.TAG === "Line") {
                return Canvas__SelectionUtils.isPointNearLine(clientX, clientY, element._0, Canvas__Constants.tolerance);
              }
              var match = element._0;
              var normalizedSelection = Canvas__SelectionUtils.normalizeSelection({
                    x: match.x,
                    y: match.y,
                    width: match.width,
                    height: match.height
                  });
              return Canvas__SelectionUtils.isPointInsideSelection(normalizedSelection, clientX, clientY, givenTolerance);
            });
}

function getElementAtPointWithTolerance(elements, clientX, clientY) {
  return getElementAtPoint(elements, clientX, clientY, Canvas__Constants.tolerance);
}

function moveSelectedElements(elements, move, selectedElementIds, clientX, clientY) {
  return elements.map(function (element) {
              var id = element._0.id;
              if (!isSelected(id, selectedElementIds)) {
                return element;
              }
              if (element.TAG === "Line") {
                var line = element._0;
                var end = line.end;
                var start = line.start;
                return {
                        TAG: "Line",
                        _0: {
                          id: line.id,
                          toolId: line.toolId,
                          zIndex: line.zIndex,
                          label: line.label,
                          start: {
                            x: start.x + clientX - move.target.x,
                            y: start.y + clientY - move.target.y
                          },
                          end: {
                            x: end.x + clientX - move.target.x,
                            y: end.y + clientY - move.target.y
                          }
                        }
                      };
              }
              var rect = element._0;
              return {
                      TAG: "Rect",
                      _0: {
                        id: rect.id,
                        toolId: rect.toolId,
                        zIndex: rect.zIndex,
                        label: rect.label,
                        x: rect.x + clientX - move.target.x,
                        y: rect.y + clientY - move.target.y,
                        width: rect.width,
                        height: rect.height
                      }
                    };
            });
}

function isElementSelected(element, selectedElementIds) {
  return selectedElementIds.some(function (selectedElementId) {
              return selectedElementId === element._0.id;
            });
}

function getFirstElementId(elements) {
  return elements[0]._0.id;
}

function resizeLineInElements(elements, resizedLine) {
  return elements.map(function (element) {
              if (resizedLine.id === element._0.id) {
                return {
                        TAG: "Line",
                        _0: resizedLine
                      };
              } else {
                return element;
              }
            });
}

function resizeRectInElements(elements, resizedRect) {
  return elements.map(function (element) {
              if (resizedRect.id === element._0.id) {
                return {
                        TAG: "Rect",
                        _0: resizedRect
                      };
              } else {
                return element;
              }
            });
}

function measureTextSize(prim0, prim1) {
  return Utils.measureTextSize(prim0, prim1);
}

function getLineCenter(param) {
  var end = param.end;
  var start = param.start;
  return {
          x: (start.x + end.x) / 2,
          y: (start.y + end.y) / 2
        };
}

function getLineCenterForText(line, text, font) {
  var match = getLineCenter(line);
  var match$1 = Utils.measureTextSize(text, font);
  return {
          x: match.x - match$1.width / 2,
          y: match.y + match$1.height / 3
        };
}

function getRectCenter(param) {
  return {
          x: param.x + param.width / 2,
          y: param.y + param.height / 2
        };
}

function getRectCenterForText(rect, text, font) {
  var match = getRectCenter(rect);
  var match$1 = Utils.measureTextSize(text, font);
  return {
          x: match.x - match$1.width / 2,
          y: match.y + match$1.height / 3
        };
}

function updateElementLabel(elements, id, label) {
  return elements.map(function (element) {
              if (element._0.id !== id) {
                return element;
              }
              if (element.TAG === "Line") {
                var line = element._0;
                return {
                        TAG: "Line",
                        _0: {
                          id: line.id,
                          toolId: line.toolId,
                          zIndex: line.zIndex,
                          label: label,
                          start: line.start,
                          end: line.end
                        }
                      };
              }
              var rect = element._0;
              return {
                      TAG: "Rect",
                      _0: {
                        id: rect.id,
                        toolId: rect.toolId,
                        zIndex: rect.zIndex,
                        label: label,
                        x: rect.x,
                        y: rect.y,
                        width: rect.width,
                        height: rect.height
                      }
                    };
            });
}

function invokeOnDoubleClick(clientX, clientY, tools, target, updateStore, store) {
  var clickedElement = getElementAtPointWithTolerance(store.elements, clientX, clientY);
  Core__Option.forEach(clickedElement, (function (clickedElement) {
          var clickedTool = tools.find(function (tool) {
                return tool.toolId === clickedElement._0.toolId;
              });
          if (clickedTool === undefined) {
            return ;
          }
          var onDoubleClick = clickedTool.onDoubleClick;
          if (onDoubleClick !== undefined) {
            return onDoubleClick({
                        tools: tools,
                        clickedElement: clickedElement,
                        store: store,
                        updateStore: updateStore,
                        target: target
                      });
          }
          
        }));
}

function roundNumberBySnapGridSize(number, gridSize) {
  var remainder = number % gridSize;
  if (remainder < gridSize / 2) {
    return number - remainder;
  } else {
    return number + gridSize - remainder;
  }
}

function snapElementToGrid(element, gridSize) {
  if (element.TAG === "Line") {
    var line = element._0;
    return {
            TAG: "Line",
            _0: {
              id: line.id,
              toolId: line.toolId,
              zIndex: line.zIndex,
              label: line.label,
              start: {
                x: roundNumberBySnapGridSize(line.start.x, gridSize),
                y: roundNumberBySnapGridSize(line.start.y, gridSize)
              },
              end: {
                x: roundNumberBySnapGridSize(line.end.x, gridSize),
                y: roundNumberBySnapGridSize(line.end.y, gridSize)
              }
            }
          };
  }
  var rect = element._0;
  return {
          TAG: "Rect",
          _0: {
            id: rect.id,
            toolId: rect.toolId,
            zIndex: rect.zIndex,
            label: rect.label,
            x: roundNumberBySnapGridSize(rect.x, gridSize),
            y: roundNumberBySnapGridSize(rect.y, gridSize),
            width: roundNumberBySnapGridSize(rect.width, gridSize),
            height: roundNumberBySnapGridSize(rect.height, gridSize)
          }
        };
}

export {
  getElementId ,
  getElementZIndex ,
  getToolId ,
  updateElementAtPosition ,
  isSelected ,
  intersectsSelection ,
  getElementAtPoint ,
  getElementAtPointWithTolerance ,
  moveSelectedElements ,
  isElementSelected ,
  getFirstElementId ,
  resizeLineInElements ,
  resizeRectInElements ,
  measureTextSize ,
  getLineCenter ,
  getLineCenterForText ,
  getRectCenter ,
  getRectCenterForText ,
  updateElementLabel ,
  invokeOnDoubleClick ,
  roundNumberBySnapGridSize ,
  snapElementToGrid ,
}
/* ./utils Not a pure module */
