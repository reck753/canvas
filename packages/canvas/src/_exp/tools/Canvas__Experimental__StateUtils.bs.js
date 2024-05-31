// Generated by ReScript, PLEASE EDIT WITH CARE


function getSelectionState(state) {
  switch (state.TAG) {
    case "Selection" :
        return state._0;
    case "Rect" :
    case "Line" :
        return ;
    
  }
}

function getRectState(state) {
  switch (state.TAG) {
    case "Rect" :
        return state._0;
    case "Selection" :
    case "Line" :
        return ;
    
  }
}

function getLineState(state) {
  switch (state.TAG) {
    case "Selection" :
    case "Rect" :
        return ;
    case "Line" :
        return state._0;
    
  }
}

export {
  getSelectionState ,
  getRectState ,
  getLineState ,
}
/* No side effect */
