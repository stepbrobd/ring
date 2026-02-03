(** A link is a triplet of {!type:Gem.Model.Lang.t}, {!type:Gem.Model.Url.t} and
    title.

    Once normalized, a link is a record:
    - [title] the title of the link
    - [lang] the lang of the link (normalized as a {!module:Gem.Model.Lang})
    - [url] the url of the link (normalized as a {!module:Gem.Model.Url}) *)

(** The type describing a member. *)
type t

val normalize_underlying_link : t -> (string * Yocaml.Data.t) list

(** [validate data] validate a link from a {!type:Yocaml.Data.t} value. *)
val validate : Yocaml.Data.t -> t Yocaml.Data.Validation.validated_value

(** [normalize url] serialize an link into a {!type:Yocaml.Data.t}. *)
val normalize : t -> Yocaml.Data.t

(** Add a separator in each elements. *)
val normalize_to_semantic_list : t list -> Yocaml.Data.t

(** Pretty-printer for url. *)
val pp : Format.formatter -> t -> unit

(** serialize an url into a string. *)
val to_string : t -> string

(** Equality between url. *)
val equal : t -> t -> bool

val title : t -> string
val lang : t -> Lang.t
val url : t -> Url.t
