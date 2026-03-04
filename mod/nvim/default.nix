{ inputs, pkgs, ... }:
{

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    initLua = builtins.readFile ./init.lua;
  };
  home.packages = [
    pkgs.nixfmt
    pkgs.stylua
    pkgs.nixd
    pkgs.lua-language-server
  ];

}
