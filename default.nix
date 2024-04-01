{
  lib,
  config,
  dream2nix,
  ...
}: rec {
  imports = [
    dream2nix.modules.dream2nix.nodejs-package-lock-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  name = "example-elm";
  version = "0.1.0";

  deps = {nixpkgs, ...}: {
    inherit
      (nixpkgs)
      stdenv
      ;
    npm = nixpkgs.nodePackages.npm;
    elm = nixpkgs.elmPackages.elm;
    nodejs = nixpkgs.nodejs_21;
    esbuild = nixpkgs.esbuild;
    caddy = nixpkgs.caddy;
    fetchElmDeps = nixpkgs.elmPackages.fetchElmDeps;
  };

  mkDerivation = {
    src = ./.;
    buildInputs = with config.deps; [
      elm
      caddy
    ];
    postConfigure = config.deps.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = "0.19.1";
      registryDat = ./registry.dat;
    };
    installPhase = ''
      cp -R $out/lib/node_modules/${name}/public $out/public
      rm -rf $out/lib
      mkdir $out/bin

      makeWrapper $(type -p caddy) $out/bin/${name} \
        --add-flags "file-server --listen :\"\''${PORT:-8000}\" --root $out/public"
    '';
  };

  nodejs-granular-v3 = {
    installMethod = "symlink";
  };

  nodejs-package-lock-v3 = {
    packageLockFile = "${config.mkDerivation.src}/package-lock.json";
  };
}
