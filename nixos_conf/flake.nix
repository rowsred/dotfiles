{
  description = "Description for the project";
nixConfig= {
  trusted-substituters = [ "https://nix-community.cachix.org"
"https://cache.nixos.org" 
  ];
};

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import an internal flake module: ./other.nix
        # To import an external flake module:
        #   1. Add foo to inputs
        #   2. Add foo as a parameter to the outputs function
        #   3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
      };

      flake = {
	nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
system = "x86_64-linux";
specialArgs= {inherit inputs;};
modules = [
./configuration.nix
./desktop/window_manager.nix
./apps/system.nix
./apps/neovim-nightly.nix
];
};

      };
    };
}
