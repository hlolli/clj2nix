{ stdenv, pkgs, clojure, makeWrapper, fetchMavenArtifact }:

let cljdeps = import ./deps.nix pkgs;
    classp  = cljdeps.makeClasspaths {};

in stdenv.mkDerivation rec {

  name = "clj2nix-1.0.2";

  src = ./clj2nix.clj;

  buildInputs = [ makeWrapper ];

  phases = ["installPhase"];
  
  installPhase = ''

      mkdir -p $out/bin
      
      cp ${src} $out/bin
      makeWrapper ${clojure}/bin/clojure $out/bin/clj2nix \
        --add-flags "-Scp ${classp} -i ${src} -m clj2nix" \
  '';
}
