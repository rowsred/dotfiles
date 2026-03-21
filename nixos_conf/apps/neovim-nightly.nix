{ inputs, pkgs, ... }:
{
environment.systemPackages = [
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
    pkgs.tree-sitter
  ];
}
