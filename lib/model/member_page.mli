(** Describes a member page. *)

(** The type describing the index page. *)
type t

val from_member : Member.t -> Member.t -> Member.t -> (unit, t) Yocaml.Task.t

(** {1 Dealing as metadata} *)

include Yocaml.Required.DATA_INJECTABLE with type t := t
