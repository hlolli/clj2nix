{ stdenv, clojure, makeWrapper, fetchMavenArtifact }:

let deps   = import ./deps.nix { inherit fetchMavenArtifact; };
    paths  = builtins.map (dep: dep.path.jar) deps.packages;
    classp = builtins.concatStringsSep ":" paths;

in stdenv.mkDerivation rec {

  name = "clj2nix-1.0.0";

  src = ./clj2nix.clj;

  buildInputs = [ makeWrapper ];

  phases = ["installPhase"];
  
  installPhase = ''

      mkdir -p $out/bin $out/.m2
      
      cp ${src} $out/bin
      makeWrapper ${clojure}/bin/clojure $out/bin/clj2nix \
        --add-flags "-Scp ${classp} -i ${src} -m clj2nix" \
  '';
}
