# generated by clj2nix-1.0.6
{ pkgs ? import <nixpkgs> {} }:

let repos = [
        "http://jcenter.bintray.com"
        "https://repo1.maven.org/maven2/"
        "https://repo.clojars.org/" ];

  in rec {
      fetchmaven = pkgs.callPackage (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/ba5e2222458a52357a3ba5873d88779d5c223269/pkgs/build-support/fetchmavenartifact/default.nix";
        sha512 = "05m7i8hbhyfz7p2f106mfbsasjf04svd9xkgc26pl3shljrk0dfacz39wiwzm6xqw7czgrsx745vciram7al621v7634nfdq3m1x88a";
      }) {};
      makePaths = {extraClasspaths ? null}:
        (pkgs.lib.concatMap
          (dep:
            builtins.map
            (path:
              if builtins.isString path then
                path
              else if builtins.hasAttr "jar" path then
                path.jar
              else if builtins.hasAttr "outPath" path then
                path.outPath
              else
                path
                )
            dep.paths)
          packages)
        ++ (if extraClasspaths != null then [ extraClasspaths ] else []);
      makeClasspaths = {extraClasspaths ? null}: builtins.concatStringsSep ":" (makePaths {inherit extraClasspaths;});
      packageSources = builtins.map (dep: dep.src) packages;
      packages = [
  rec {
    name = "clj-time/clj-time";
    src = fetchmaven {
      inherit repos;
      artifactId = "clj-time";
      groupId = "clj-time";
      sha512 = "b8012a4b1d9de72d3d1fe5b96dd5c36900f2a9aa040c76727f8ab7b744c1b0c758af17ac46075ac82d8e549a22c018e7d20b5aec4c774764508d28ab66f4a1f7";
      version = "0.14.2";
      
    };
    paths = [ src ];
  }

  (rec {
    name = "org.clojure/data.csv";
    src = pkgs.fetchgit {
      name = "data.csv";
      url = "https://github.com/clojure/data.csv.git";
      rev = "e5beccad0bafdb8e78f19cba481d4ecef5fabf36";
      sha256 = "021yhc19biycrdcyfak2hyy6jncrw3fhkqzd1jr77rid3f54nqx0";
    };
    paths = map (path: src + path) [
      "/src/main/clojure"
    ];
  })

  rec {
    name = "joda-time/joda-time";
    src = fetchmaven {
      inherit repos;
      artifactId = "joda-time";
      groupId = "joda-time";
      sha512 = "e1763df430f9b2556c591ab894668231a2d74ce946f4c6d460630272b55b02166c40715fdd7eab983cd4247fee19d48a23141d82aa17fc9c7ef6053f3b7bea80";
      version = "2.9.7";
      
    };
    paths = [ src ];
  }

  rec {
    name = "clojure/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "clojure";
      groupId = "org.clojure";
      sha512 = "4bb567b9262d998f554f44e677a8628b96e919bc8bcfb28ab2e80d9810f8adf8f13a8898142425d92f3515e58c57b16782cff12ba1b5ffb38b7d0ccd13d99bbc";
      version = "1.10.3";
      
    };
    paths = [ src ];
  }

  rec {
    name = "spec.alpha/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "spec.alpha";
      groupId = "org.clojure";
      sha512 = "0740dc3a755530f52e32d27139a9ebfd7cbdb8d4351c820de8d510fe2d52a98acd6e4dfc004566ede3d426e52ec98accdca1156965218f269e60dd1cd4242a73";
      version = "0.2.194";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.specs.alpha/org.clojure";
    src = fetchmaven {
      inherit repos;
      artifactId = "core.specs.alpha";
      groupId = "org.clojure";
      sha512 = "c1d2a740963896d97cd6b9a8c3dcdcc84459ea66b44170c05b8923e5fbb731b4b292b217ed3447bbc9e744c9a496552f77a6c38aea232e5e69f8faa627dea4b5";
      version = "0.2.56";
      
    };
    paths = [ src ];
  }

  ];
  }
  