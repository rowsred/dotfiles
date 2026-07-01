{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    river-kwm.url = "github:rowsred/river_kwm_modules_nixos";
  };

  outputs =
    {
      self,
      nixpkgs,
      river-kwm,
    }:
    {

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit river-kwm; };
          system = "x86_64-linux";
          modules = [
            ./src/configuration.nix
            ./src/kwm.nix
            ./src/editor.nix
          ];

        };

      };

    };
}
