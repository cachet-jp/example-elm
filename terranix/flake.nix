{
  inputs = {
    parent.url = "path:..";
    nixpkgs.follows = "parent/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      perSystem = {
        self',
        pkgs,
        system,
        ...
      }: let
        terraform = pkgs.opentofu;
        terraformConfiguration = env:
          inputs.terranix.lib.terranixConfiguration {
            inherit system;
            extraArgs = {inherit env;};
            modules = [./config.nix];
          };
      in {
        apps.terraform-dev = {
          type = "app";
          program = toString (pkgs.writers.writeBash "terraform" ''
            set -exuo pipefail
            if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
            cp ${terraformConfiguration "dev"} config.tf.json
            ${terraform}/bin/tofu init -reconfigure
            ${terraform}/bin/tofu "$@"
          '');
        };

        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              terraform
              google-cloud-sdk
            ];
          };

        formatter = pkgs.alejandra;
      };
    };
}
