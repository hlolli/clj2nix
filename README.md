# clj2nix

## installation

Clone the repo and create an overlay file (ex. overlays.nix)
```
self: super:
{
  clj2nix = self.callPackage /path/to/git/repo {};
}
```

In your nix config, import the overlays file and pass in pkgs as argument
```
nixpkgs.overlays = [/path/to/overlays.nix];
```

Then add `clj2nix` to `environment.systemPackages`

```
environment.systemPackages =
    with pkgs;
    [
      ...all your packages....
      clj2nix
    ];
```

Finally

```
# nixos-rebuild switch
```

## useage

After the installation you should have `clj2nix` on your path, which takes two arguments, the depn.edn file for the project's dependencies, and the output file.

Example:

```
$ clj2nix ./deps.edn ./deps.nix
```

With an imported `deps.nix` you can use it to fetch the dependencies trough nix. The set has two helper functions that can do this for you; `makeClasspaths {}` and `makePaths {}`.

```
{ stdenv, pkgs, clojure }:

let cljdeps = import ./deps.nix pkgs;
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
let cljdeps = import ./deps.nix pkgs;
    classp  = cljsdeps.makeClasspaths {};

....
echo ${classp}

prints:
/nix/store/9zp8rpnhpmx9i1g7vnicq6hiz11yknqi-clj-time_clj-time-0.14.2.jar:/nix/store/n7fmadn560r77qw34814a97j408n0vd6-data.csv:/nix/store/sch7dhx6f6mhfx33nvl964qfdr8ivn2x-joda-time_joda-time-2.9.7.jar
```

with the optional parameter extraClasspaths

```
# example
let cljdeps = import ./deps.nix pkgs;
    classp  = cljsdeps.makeClasspaths {extraClasspaths="./local/file.jar"};

....
echo ${classp}

prints:
/nix/store/9zp8rpnhpmx9i1g7vnicq6hiz11yknqi-clj-time_clj-time-0.14.2.jar:/nix/store/n7fmadn560r77qw34814a97j408n0vd6-data.csv:/nix/store/sch7dhx6f6mhfx33nvl964qfdr8ivn2x-joda-time_joda-time-2.9.7.jar:./local/file.jar
```

### makePaths

```
# example
let cljdeps = import ./deps.nix pkgs;
    classp  = cljsdeps.makePaths {};

....
echo ${builtins.toString classp}

prints (square brackets added for demonstrations):
[
  /nix/store/9zp8rpnhpmx9i1g7vnicq6hiz11yknqi-clj-time_clj-time-0.14.2.jar
  /nix/store/n7fmadn560r77qw34814a97j408n0vd6-data.csv
  /nix/store/sch7dhx6f6mhfx33nvl964qfdr8ivn2x-joda-time_joda-time-2.9.7.jar
]
```
