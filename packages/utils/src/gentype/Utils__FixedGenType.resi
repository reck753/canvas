module JSON: {
  @genType
  type t = Js.Json.t
}

module Dict: {
  @genType
  type t<'value> = Js.Dict.t<'value>
}
