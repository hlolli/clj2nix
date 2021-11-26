# clj2nix

## try without installing

```
$ nix run github:hlolli/clj2nix -- deps.edn deps.nix
```

## installation

(Change rev and sha256 according to `nix-prefetch-github hlolli clj2nix`)

```nix
let
  clj2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "hlolli";
    repo = "clj2nix";
    rev = "b9a28d4a920d5d680439b1b0d18a1b2c56d52b04";
    sha256 = "0d8xlja62igwg757lab9ablz1nji8cp9p9x3j0ihqvp1y48w2as3";
  }) {};
```

## usage

After the installation you should have `clj2nix` on your path, which takes two arguments, the depn.edn file for the project's dependencies, and the output file.

Example:

```
$ clj2nix ./deps.edn ./deps.nix [options]
```

With an imported `deps.nix` you can use it to fetch the dependencies trough nix.
The generated file currently requires that `fetchMavenArtifact, fetchgit, lib` are
explicitly passed (see example below).
The imported attribute-set has two helper functions that can do classpath handling for you.
These are: `makeClasspaths {}` and `makePaths {}`.

```
{ stdenv, pkgs, clojure }:

let cljdeps = import ./deps.nix { inherit (pkgs) fetchMavenArtifact fetchgit lib; };
    classp  = cljsdeps.makeClasspaths {};

in stdenv.mkDerivation {
  ...whatever here...

  installPhase = ''
      clojure -i somefile.clj -Scp ${classp}
  '';
}
```

### makeClasspaths (colon seperated classpaths)

```
# example
let cljdeps = import ./deps.nix { inherit (pkgs) fetchMavenArtifact fetchgit lib; };
    classp  = cljsdeps.makeClasspaths {};

....
echo ${classp}

prints:
/nix/store/9zp8rpnhpmx9i1g7vnicq6hiz11yknqi-clj-time_clj-time-0.14.2.jar:/nix/store/n7fmadn560r77qw34814a97j408n0vd6-data.csv:/nix/store/sch7dhx6f6mhfx33nvl964qfdr8ivn2x-joda-time_joda-time-2.9.7.jar
```

with the optional parameter extraClasspaths

```
# example
let cljdeps = import ./deps.nix { inherit (pkgs) fetchMavenArtifact fetchgit lib; };
    classp  = cljsdeps.makeClasspaths { extraClasspaths = ["./local/file.jar"]; };

....
echo ${classp}

prints:
/nix/store/9zp8rpnhpmx9i1g7vnicq6hiz11yknqi-clj-time_clj-time-0.14.2.jar:/nix/store/n7fmadn560r77qw34814a97j408n0vd6-data.csv:/nix/store/sch7dhx6f6mhfx33nvl964qfdr8ivn2x-joda-time_joda-time-2.9.7.jar:./local/file.jar
```

### makePaths

```nix
# example
let cljdeps = import ./deps.nix { inherit (pkgs) fetchMavenArtifact fetchgit lib; };
    classp  = cljsdeps.makePaths {};

#! bash
# echo ${builtins.concatStringsSep " " classp}
# prints (square brackets added for demonstrations):
[
  "/nix/store/9zp8rpnhpmx9i1g7vnicq6hiz11yknqi-clj-time_clj-time-0.14.2.jar"
  "/nix/store/n7fmadn560r77qw34814a97j408n0vd6-data.csv"
  "/nix/store/sch7dhx6f6mhfx33nvl964qfdr8ivn2x-joda-time_joda-time-2.9.7.jar"
]
```

## options

It's possible to add the extra dependencies form aliases into the nix file by adding one or more -Aalias to the end of the command. Example

```
clj2nix ./deps.edn ./deps.nix -A:test -A:ci
```
