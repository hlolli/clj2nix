{
  stdenv, lib, coreutils, clojure,
  makeWrapper, nix-prefetch-git,
  fetchMavenArtifact, fetchgit,
  openjdk, fetchFromGitHub, git
}:

let cljdeps = import ./deps.nix { inherit fetchMavenArtifact fetchgit lib; };
    classp  = cljdeps.makeClasspaths {
      extraClasspaths = [ "${placeholder "out"}/lib" ];
    };
    version = "1.1.0-rc";
    gitignoreSrc = fetchFromGitHub {
      owner = "hercules-ci";
      repo = "gitignore.nix";
      rev = "211907489e9f198594c0eb0ca9256a1949c9d412";
      sha256 = "sha256-qHu3uZ/o9jBHiA3MEKHJ06k7w4heOhA+4HCSIvflRxo=";
    };

    inherit (import gitignoreSrc { inherit lib; }) gitignoreSource;

in stdenv.mkDerivation rec {

  name = "clj2nix-${version}";

  src = gitignoreSource ./.;

  buildInputs = [ makeWrapper clojure git ];

  buildPhase = ''
    mkdir -p classes
    HOME=. clojure -Scp "${classp}:src" -e "(compile 'clj2nix.core)"
  '';

  dontFixup = true;

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -rT classes $out/lib
    makeWrapper ${openjdk}/bin/java $out/bin/clj2nix \
      --add-flags "-Dlog4j.rootLogger=FATAL" \
      --add-flags "-cp" \
      --add-flags "${classp}" \
      --add-flags "clj2nix.core" \
      --add-flags "${version}" \
      --prefix PATH : "$PATH:${lib.makeBinPath [ coreutils nix-prefetch-git ]}"
  '';
}
