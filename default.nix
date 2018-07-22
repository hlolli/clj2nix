{ stdenv, clojure, makeWrapper }:

stdenv.mkDerivation rec {

  name = "clj2nix-1.0.0";

  src = ./clj2nix.clj;

  buildInputs = [ makeWrapper ];

  phases = ["installPhase"];
  
  installPhase = ''

      mkdir -p $out/bin
      cp ${src} $out/bin
      makeWrapper ${clojure}/bin/clojure $out/bin/clj2nix \
        --add-flags " -i ${src} -m clj2nix" \
  '';
}

