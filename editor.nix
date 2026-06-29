{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vscode.fhs
    neovim
    fzf
    ripgrep
    fd
    tree-sitter
    just
    gcc
    gnumake
    cmake
    pkg-config
    #formater
    nixfmt
    stylua
    #lsp
    lua-language-server
    prettier
  ];
}
