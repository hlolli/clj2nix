{
  stdenv, lib, pkgs, coreutils, clojure,
  makeWrapper, nix-prefetch-git
}:

let cljdeps = import ./deps.nix { inherit pkgs; };
    classp  = cljdeps.makeClasspaths {};
    version = "1.0.6";

in stdenv.mkDerivation rec {

  name = "clj2nix-${version}";

  src = ./clj2nix.clj;

  buildInputs = [ makeWrapper ];

  phases = ["installPhase"];

  installPhase = ''

      mkdir -p $out/bin

      cp ${src} $out/bin
      makeWrapper ${clojure}/bin/clojure $out/bin/clj2nix \
        --add-flags "-Scp ${classp} ${
          if (lib.versionAtLeast clojure.version "1.10.1.697")
            then "-M ${src}" else "-i ${src} -m clj2nix"
        } ${version}" \
        --prefix PATH : "$PATH:${lib.makeBinPath [ coreutils nix-prefetch-git ]}"
  '';
}
