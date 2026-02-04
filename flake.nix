{
  outputs = { self, nixpkgs, parts, systems } @ inputs: parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { lib, pkgs, system, ... }: {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            ocamlPackages = prev.ocaml-ng.ocamlPackages_latest.overrideScope (ocamlFinal: ocamlPrev:
              (with lib; genAttrs
                (attrNames (builtins.readDir ./pkgs))
                (name: ocamlFinal.callPackage ./pkgs/${name} { }))
              //
              {
                dune = ocamlPrev.dune_3;
              });
          })
        ];
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.default ];
        packages = with pkgs; [
          deno
        ] ++ (with ocamlPackages; [
          ocaml-print-intf
          ocamlformat
          utop
        ]);
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        ${lib.getExe pkgs.deno} fmt .
        ${lib.getExe pkgs.nixpkgs-fmt} .
        ${lib.getExe pkgs.ocamlPackages.dune} fmt
      '';

      packages = with lib; fix (self: (
        (genAttrs
          (attrNames (builtins.readDir ./pkgs))
          (name: pkgs.ocamlPackages.${name}))
        //
        { default = self.ring; }
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
