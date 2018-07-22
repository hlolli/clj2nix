# clj2nix

## installation

Clone the repo and create an overlay file (ex. overlays.nix)
```
self: super:
{
  clj2nix = self.callPackage /path/to/git/repo {};
}
```

In your nix config, import the overlays file
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

Before useing clj2nix, make sure that all the dependencies in deps.edn exists locally, just start a clojure repl with the clojure command line tool in the same directory as your deps.edn and all the dependencies should be automatically fetched.

```
$ clj --repl
# or
$ clojure --repl
```


With an exported `deps.nix` you can use it to fetch the dependencies trough nix and with a simple trick, create a colon seperated classpath for a clojure runtime environment.

```
{ stdenv, clojure, fetchMavenArtifact }:

let deps   = import ./deps.nix { inherit fetchMavenArtifact; };
    paths  = builtins.map (dep: dep.path.jar) deps.packages;
    classp = builtins.concatStringsSep ":" paths;

in stdenv.mkDerivation {
  ...whatever here...
  
  installPhase = ''
      clojure -i somefile.clj -Scp ${classp}
  '';
}
```
