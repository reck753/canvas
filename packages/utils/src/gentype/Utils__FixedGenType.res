module JSON = {
  type t = Js.Json.t
}

module Dict = {
  type t<'value> = Js.Dict.t<'value>
}
