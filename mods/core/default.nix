{
  ...
}:

{
  home.username = "mor";
  home.homeDirectory = "/home/mor";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.packages = [
  ];

  home.file = {
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"

  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  programs.home-manager.enable = true;
}
