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
    prettier
    #lsp
    lua-language-server
    nodejs
    emmet-ls
    vtsls
    vscode-langservers-extracted
    vue-language-server
    svelte-language-server
    tailwindcss-language-server
  ];
}
