{
  outputs = { self, nixpkgs, parts, systems } @ inputs: parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { lib, pkgs, system, self', ... }: {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            ocamlPackages = prev.ocaml-ng.ocamlPackages.overrideScope (ocamlFinal: ocamlPrev:
              (with lib; genAttrs
                (attrNames (builtins.readDir ./pkgs))
                (name: ocamlFinal.callPackage ./pkgs/${name} { })));
          })
        ];
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = with self'.packages; [ gskring ];
        packages = with pkgs; [
          deno
          nixpkgs-fmt
        ] ++ (with ocamlPackages; [
          ocaml-lsp
          ocaml-print-intf
          ocamlformat
          utop
        ]);
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        set -eoux pipefail
        shopt -s globstar
        root="$PWD"
        while [[ ! -f "$root/.git/index" ]]; do
          if [[ "$root" == "/" ]]; then
            exit 1
          fi
          root="$(dirname "$root")"
        done
        pushd "$root" > /dev/null
        ${lib.getExe pkgs.deno} fmt .
        ${lib.getExe pkgs.nixpkgs-fmt} .
        ${lib.getExe pkgs.ocamlPackages.dune} fmt
        popd
      '';

      packages = with lib; fix (self: (
        (genAttrs
          (attrNames (builtins.readDir ./pkgs))
          (name: pkgs.ocamlPackages.${name}))
        //
        { default = self.gskring; }
      ));
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };
}
