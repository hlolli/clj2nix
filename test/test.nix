{ stdenv, clojure, jre, fetchMavenArtifact, fetchgit }:

let cljdeps = import ./deps.test.nix {
      inherit fetchMavenArtifact;
      inherit fetchgit;
    };

    classp = cljdeps.makePaths {};


in stdenv.mkDerivation rec {
  name = "clj2nixTest";
  
  phases = [ "buildPhase" ];

  buildInputs = [ clojure jre ];

  buildPhase = ''
    echo 'classpd! ' ${builtins.toString classp}
    mkdir $out
  '';
}

# clojure -i clj2nix.clj -m clj2nix test/deps.test.edn test/deps.test.nix
# nix-build -E 'with import <nixpkgs> {}; callPackage ./test.nix {}'
