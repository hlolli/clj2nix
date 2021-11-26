{ stdenv, pkgs, clojure }:

let cljdeps = import ./deps.test.nix { inherit (pkgs) fetchMavenArtifact fetchgit lib; };
    classp = cljdeps.makePaths {};


in stdenv.mkDerivation rec {
  name = "clj2nixTest";

  phases = [ "buildPhase" ];

  buildInputs = [];

  buildPhase = ''
    mkdir $out
  '';

  # basic sanity checks
  installCheckPhase = ''
    echo ${builtins.toString classp} | fgrep 'clj-time'
    echo ${builtins.toString classp} | fgrep 'org.clojure/data.csv'
    echo ${builtins.toString classp} | fgrep 'joda-time/joda-time'
  '';
}

# clojure -i clj2nix.clj -m clj2nix test/deps.test.edn test/deps.test.nix
# clojure -M:run "1.1.0-rc" deps.edn deps.nix -A:build
# nix-build -E 'with import <nixpkgs> {}; callPackage ./test.nix {}'
