{ lib
, buildDunePackage
, cmdliner
, tailwindcss_4
, yocaml
, yocaml_eio
, yocaml_liquid
, yocaml_omd
, yocaml_syndication
, yocaml_yaml
}:

buildDunePackage (finalAttrs: {
  pname = "gskring";
  version = with lib; pipe ./dune-project [
    readFile
    (match ".*\\(version ([^\n]+)\\).*")
    head
  ];

  src = with lib.fileset; toSource {
    root = ../../.;
    fileset = unions [
      ./bin
      ./lib
      ./dune-project
      ../../assets
      ../../members
      ../../articles
      ../../pages
      ../../chain.yaml
      ../../dune-workspace
    ];
  };

  env.DUNE_CACHE = "disabled";

  nativeBuildInputs = [
    tailwindcss_4
  ];

  buildInputs = [
    cmdliner
    yocaml
    yocaml_eio
    yocaml_liquid
    yocaml_omd
    yocaml_syndication
    yocaml_yaml
  ];

  buildPhase = ''
    runHook preBuild

    dune build -p ${finalAttrs.pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    dune exec pkgs/gskring/bin/gskring.exe -- build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm _build/www/cache
    mkdir -p $out/var/www/html
    cp -r _build/www/* $out/var/www/html/

    runHook postInstall
  '';
})
