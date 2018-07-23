{ stdenv, clojure, jre, fetchMavenArtifact, fetchgit }:

let deps = import ./deps.test.nix {
      inherit fetchMavenArtifact;
      inherit fetchgit;
    };
    paths = builtins.map (dep: dep.path) deps.packages;
    classp = builtins.concatStringsSep ":" paths;


in stdenv.mkDerivation rec {
  name = "clj2nixTest";
  
  phases = [ "buildPhase" ];

  buildInputs = [ clojure jre ];

  buildPhase = ''
    echo ${classp}
    mkdir $out
  '';
}

# clojure -i clj2nix.clj -m clj2nix test/deps.test.edn test/deps.test.nix
# nix-build -E 'with import <nixpkgs> {}; callPackage ./test.nix {}'
