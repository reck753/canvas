// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Core__Option from "@rescript/core/src/Core__Option.bs.js";
import * as Canvas__CanvasUtils from "../Canvas__CanvasUtils.bs.js";

function handler(e, offsetX, offsetY, store, tools, updateStore) {
  var target = e.target;
  var clientX = Canvas__CanvasUtils.normalizeClientX(Canvas__CanvasUtils.getClientX(e), offsetX);
  var clientY = Canvas__CanvasUtils.normalizeClientY(Canvas__CanvasUtils.getClientY(e), offsetY);
  var selectedTool = tools.find(function (tool) {
        return tool.toolId === store.selectedToolId;
      });
  Core__Option.forEach(selectedTool, (function (selectedTool) {
          selectedTool.onMove({
                clientX: clientX,
                clientY: clientY,
                store: store,
                updateStore: updateStore,
                target: target,
                tools: tools
              });
        }));
}

var CanvasUtils;

export {
  CanvasUtils ,
  handler ,
}
/* No side effect */