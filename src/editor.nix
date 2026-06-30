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
    #base-devel
    gcc
    gnumake
    cmake
    pkg-config
    clang-tools
    #formater
    nixfmt
    stylua
    #lsp
    lua-language-server
    prettier
  ];
}
