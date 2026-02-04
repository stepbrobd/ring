open Model_util

type t =
  | En
  | Fr
  | Ja

let validate =
  let open Yocaml.Data.Validation in
  token
  & function
  | "eng" | "en" -> Ok En
  | "fra" | "fr" -> Ok Fr
  | "jpn" | "ja" -> Ok Ja
  | given -> fail_with ~given "Invalid Lang Value"
;;

let to_string = function
  | En -> "en"
  | Fr -> "fr"
  | Ja -> "ja"
;;

let normalize lang = Yocaml.Data.string @@ to_string lang
let pp ppf lang = Format.fprintf ppf "%s" @@ to_string lang

let equal a b =
  match a, b with
  | En, En | Fr, Fr | Ja, Ja -> true
  | En, _ | Fr, _ | Ja, _ -> false
;;
