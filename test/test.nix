{ stdenv, pkgs, fetchMavenArtifact, callPackage }:

let
  # fetchclojar = callPackage ./fetchClojar.nix {};
  cljPackages = import ./debug.nix {
    inherit fetchMavenArtifact;
  };

#   nodeSources = map (x: x.path) nodePackages.packages;

in stdenv.mkDerivation rec {
  version = "1.9.0-alpha";
  name = "lumo-${version}";

  srcs = map (x: x.path) cljPackages.packages;

  # 


  phases = [ "unpackPhase" "installPhase" "buildPhase" ];

  # unpackPhase = ''
  #   unpackPhase;
  # '';

  buildPhase = ''
    echo `pwd`
  '';


  installPhase = ''
  echo `pwd`
  '';
}

# nix-build -E 'with import <nixpkgs> {}; callPackage ./test.nix {}' --dry-run
