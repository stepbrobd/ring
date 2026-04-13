let run (module R : Sigs.RESOLVER) cache =
  Yocaml.Action.copy_file ~into:R.Target.root R.Source.favicon cache
;;
