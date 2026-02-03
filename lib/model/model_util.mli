(** Generic utilities for describing models *)

(** {1 Validation helpers} *)

(** A validator which ensures that a character string has at least the size
    given as an argument. *)
val minimal_length : int -> string -> string Yocaml.Data.Validation.validated_value

(** A validator that ensure that a data is a string and apply [trim] and
    [lowercase]. *)
val token : Yocaml.Data.t -> string Yocaml.Data.Validation.validated_value

(** {1 Data helpers} *)

(** Transforms an option into [bool true] (if it exists) or [bool false] (if it
    doesn't exist). *)
val has_opt : 'a option -> Yocaml.Data.t

(** Transforms a list into [bool true] (if it is not empty) or [bool false] (if
    it is empty). *)
val has_list : 'a list -> Yocaml.Data.t
