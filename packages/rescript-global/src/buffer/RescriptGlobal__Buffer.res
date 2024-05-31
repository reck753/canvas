type t

@scope("Buffer") @val
external from: (string, ~encode: string=?) => t = "from"

@send
external toString: (t, ~encode: string=?) => string = "toString"
