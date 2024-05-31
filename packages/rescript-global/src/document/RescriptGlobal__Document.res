module Context = {
  type t = {
    mutable fillStyle: string,
    mutable strokeStyle: string,
    mutable lineWidth: float,
    mutable font: string,
    fillRect: (~x: float, ~y: float, ~width: float, ~height: float) => unit,
    fillText: (~text: string, ~x: float, ~y: float) => unit,
    beginPath: unit => unit,
    moveTo: (~x: float, ~y: float) => unit,
    lineTo: (~x: float, ~y: float) => unit,
    stroke: unit => unit,
    strokeRect: (~x: float, ~y: float, ~width: float, ~height: float) => unit,
    clearRect: (~x: float, ~y: float, ~width: float, ~height: float) => unit,
  }
}

module Element = {
  type t = {
    width: float,
    height: float,
  }

  @send external getContext: (t, string) => Nullable.t<Context.t> = "getContext"
}

type t

@val external init: t = "document"

@send external getElementById: (t, string) => Nullable.t<Element.t> = "getElementById"
