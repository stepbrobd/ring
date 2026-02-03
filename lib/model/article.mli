(** Describes an external Article. *)

(** The type describing an article. *)
type t

(** Ensure that authors are present in chain. *)
val authors_in_chain : Chain.t -> t -> bool

val pp : Format.formatter -> t -> unit
val sort : t -> t -> int
val to_atom : Chain.t -> t -> Yocaml_syndication.Atom.entry

(** {1 Dealing as metadata} *)

include Yocaml.Required.DATA_READABLE with type t := t
include Yocaml.Required.DATA_INJECTABLE with type t := t
