module Make (R : Sigs.RESOLVABLE) = struct
  include R
  open Yocaml

  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let members = Path.rel [ "members" ]
    let entries = Path.rel [ "articles" ]
    let chain = Path.rel [ "chain.yaml" ]
    let common_deps = [ binary; chain ]
    let pages = Path.rel [ "pages" ]
    let index = Path.(pages / "index.md")
    let articles = Path.(pages / "articles.md")
    let avatars = members
    let css = Path.(Path.rel [ "assets" ] / "style" / "tailwind.css")
    let favicon = Path.(Path.rel [ "assets" ] / "favicon.ico")
    let layouts = Path.(Path.rel [ "assets" ] / "layout")
    let template file = Path.(layouts / file)
  end

  module Target = struct
    let root = R.target
    let cache = Path.(R.target / "cache")
    let opml = Path.(R.target / "opml")
    let atom = Path.(R.target / "atom.xml")
    let ring_opml = Path.(opml / "ring.opml")
    let members = Path.(R.target / "u")
    let css = Path.(R.target / "assets" / "style" / "tailwind.css")
    let index = Path.(R.target / "index.html")
    let avatars = members
    let frame ~id = Path.(members / id / "frame.html")
    let member ~id = Path.(members / id / "index.html")
    let articles = Path.(R.target / "articles" / "index.html")

    let member_redirection ~id pred_or_succ =
      let target = Path.(members / id) in
      match pred_or_succ with
      | `Pred -> Path.(target / "pred" / "index.html")
      | `Succ -> Path.(target / "succ" / "index.html")
    ;;
  end

  let track_common_dependencies = Yocaml.Pipeline.track_files Source.common_deps
end
