type t

let from: (string, ~encode: string=?) => t
let toString: (t, ~encode: string=?) => string
