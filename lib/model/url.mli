(** A rather naive implementation of a validator for URLs (which simply checks
    the existence of a scheme). In the near future, we will probably have to
    relay on the {{:https://ocaml.org/p/uri/latest} URI} library. Currently,
    prefix supported are:
    - http
    - https
    - gemini (because of heyPlzLookAtMe)

    Once normalized, an url has this complicated shape (to give control on the
    template side):
    - [url]: the full url representation ([scheme + "://" + url])
    - [scheme] the scheme of the url ([Http | Https | Gemini])
    - [url_without_scheme] the url without the scheme. *)

type scheme =
  | Http
  | Https
  | Gemini

(** The type describing an url. *)
type t

(** [validate data] validate an url from a {!type:Yocaml.Data.t} value. *)
val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value

(** [normalize url] serialize an url into a {!type:Yocaml.Data.t}. *)
val normalize : t -> Yocaml.Data.t

(** Pretty-printer for url. *)
val pp : Format.formatter -> t -> unit

(** serialize an url into a string. *)
val to_string : t -> string

(** Equality between url. *)
val equal : t -> t -> bool

val scheme : t -> scheme
val url : t -> string
