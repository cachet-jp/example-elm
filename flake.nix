{
  description = "Elm Example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    nix-pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.nix-pre-commit-hooks.flakeModule
      ];
      systems = import inputs.systems;
      flake = {
      };
      perSystem = {
        config,
        self',
        pkgs,
        system,
        ...
      }: {
        packages.default = inputs.dream2nix.lib.evalModules {
          packageSets.nixpkgs = pkgs;
          modules = [
            ./default.nix
            {
              paths.projectRoot = ./.;
              paths.package = ./.;
            }
          ];
        };
        packages.docker = with pkgs;
          dockerTools.buildLayeredImage {
            name = "exampleelm";
            tag = "latest";
            config = {
              Env = [
                # https://gist.github.com/CMCDragonkai/1ae4f4b5edeb021ca7bb1d271caca999
                "SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
              ];
              Cmd = [
                "${self.packages.${system}.default}/bin/example-elm"
              ];
            };
          };
        pre-commit = {
          check.enable = true;

          settings = {
            hooks = {
              alejandra.enable = true;
              elm-format.enable = true;
            };
          };
        };
        devShells.default = with pkgs;
          mkShell {
            nativeBuildInputs =
              [
                nodejs_21
                nodePackages.npm
              ]
              ++ (with elmPackages; [
                elm
                elm-test
                elm-format
                elm-language-server
              ]);

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

        apps.dev = {
          type = "app";
          program = toString (pkgs.writers.writeBash "elm-watch" ''
            set -exuo pipefail
            ${pkgs.nodePackages.npm}/bin/npm start
          '');
        };

        apps.elm2nix = {
          type = "app";
          program = toString (pkgs.writers.writeBash "elm2nix" ''
            set -exuo pipefail
            ${pkgs.elm2nix}/bin/elm2nix convert > elm-srcs.nix
            ${pkgs.elm2nix}/bin/elm2nix snapshot
          '');
        };
      };
    };
}
