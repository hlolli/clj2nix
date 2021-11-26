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
      clj2nix = pkgs.callPackage ./clj2nix.nix { };
    in {
      packages = utils.lib.flattenTree {
        inherit clj2nix;
      };

      defaultPackage = self.packages."${system}".clj2nix;

      devShell = pkgs.mkShell {
        name = "clj2nix-development";
        # sorry
        SHELL = "${pkgs.fish}/bin/fish";
        GIT_TERMINAL_PROMPT = 1;
        packages = with pkgs; [
          coreutils
          clojure
          git
          nix-prefetch-git
          openjdk
        ];
        shellHook = ''
          ${pkgs.fish}/bin/fish --interactive -C \
            '${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source'
             exit $?
        '';
      };
    });

}
