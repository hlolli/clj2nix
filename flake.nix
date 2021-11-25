{
  description = "Convert deps.edn to a nix expression.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      clj2nix = pkgs.callPackage ./clj2nix-pkg.nix { };
    in {
      packages = utils.lib.flattenTree {
        inherit clj2nix;
      };

      defaultPackage = self.packages."${system}".clj2nix;

    });

}
