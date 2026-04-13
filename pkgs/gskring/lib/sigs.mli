module type RESOLVABLE = sig
  val source : Yocaml.Path.t
  val target : Yocaml.Path.t
end

module type RESOLVER = sig
  include RESOLVABLE

  val track_common_dependencies : (unit, unit) Yocaml.Task.t

  module Source : sig
    val root : Yocaml.Path.t
    val binary : Yocaml.Path.t
    val common_deps : Yocaml.Path.t list
    val css : Yocaml.Path.t
    val layouts : Yocaml.Path.t
    val template : Yocaml.Path.fragment -> Yocaml.Path.t
    val members : Yocaml.Path.t
    val entries : Yocaml.Path.t
    val chain : Yocaml.Path.t
    val index : Yocaml.Path.t
    val articles : Yocaml.Path.t
    val avatars : Yocaml.Path.t
    val favicon : Yocaml.Path.t
  end

  module Target : sig
    val root : Yocaml.Path.t
    val cache : Yocaml.Path.t
    val css : Yocaml.Path.t
    val opml : Yocaml.Path.t
    val atom : Yocaml.Path.t
    val ring_opml : Yocaml.Path.t
    val index : Yocaml.Path.t
    val members : Yocaml.Path.t
    val member_redirection : id:string -> [ `Pred | `Succ ] -> Yocaml.Path.t
    val frame : id:string -> Yocaml.Path.t
    val member : id:string -> Yocaml.Path.t
    val avatars : Yocaml.Path.t
    val articles : Yocaml.Path.t
  end
end
