// Generated by ReScript, PLEASE EDIT WITH CARE


function getClientX(e) {
  return e.clientX;
}

function getClientY(e) {
  return e.clientY;
}

function normalizeClientX(clientX, offsetX) {
  return clientX - offsetX;
}

function normalizeClientY(clientY, offsetY) {
  return clientY - offsetY;
}

var Mouse = {};

var JsxEventFixed = {
  Mouse: Mouse
};

export {
  getClientX ,
  getClientY ,
  normalizeClientX ,
  normalizeClientY ,
  JsxEventFixed ,
}
/* No side effect */