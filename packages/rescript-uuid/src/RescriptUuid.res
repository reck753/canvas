@module("uuid")
external make: unit => string = "v4"

@module("uuid")
external test: string => bool = "validate"
