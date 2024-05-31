let toSorted = (arr, fn) => {
  arr->Array.sort(fn)
  arr
}

let toReversed = arr => {
  arr->Array.reverse
  arr
}
