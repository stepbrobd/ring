{ lib
, buildDunePackage
, cmdliner
, yocaml
, yocaml_eio
, yocaml_jingoo
, yocaml_omd
, yocaml_syndication
, yocaml_yaml
, ppx_expect
}:

buildDunePackage (finalAttrs: {
  pname = "ring";
  version = with lib; pipe ../../dune-project [
    readFile
    (match ".*\\(version ([^\n]+)\\).*")
    head
  ];

  src = with lib.fileset; toSource {
    root = ../../.;
    fileset = unions [
      ../../bin
      ../../data
      ../../dune-project
      ../../lib
      ../../static
      ../../test
    ];
  };

  env.DUNE_CACHE = "disabled";

  buildInputs = [
    cmdliner
    ppx_expect
    yocaml
    yocaml_eio
    yocaml_jingoo
    yocaml_omd
    yocaml_syndication
    yocaml_yaml
  ];

  buildPhase = ''
    runHook preBuild
    dune build -p ${finalAttrs.pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    dune exec bin/ring.exe -- build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR ${finalAttrs.pname}
    mkdir -p $out/var/www/html
    cp -r _build/www/* $out/var/www/html/
    runHook postInstall
  '';
})
