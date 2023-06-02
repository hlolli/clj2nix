{
  stdenv, lib, coreutils, clojure,
  makeWrapper, nix-prefetch-git,
  fetchMavenArtifact, fetchgit,
  openjdk, fetchFromGitHub, git, gitignore
}:

let cljdeps = import ./deps.nix { inherit fetchMavenArtifact fetchgit lib; };
    classp  = cljdeps.makeClasspaths {
      extraClasspaths = [ "${placeholder "out"}/lib" ];
    };
    version = "1.1.0-rc";
    inherit (import gitignore { inherit lib; }) gitignoreSource;

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
