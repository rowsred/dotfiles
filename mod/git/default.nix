{...}:
{
programs.git = {
    enable = true;
    userName = "zeckrow";
    userEmail = "fadlidev99@gmail.com";

    # Optional: useful default settings
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    # Set up global ignores (replaces .gitignore_global)
    ignores = [ ".DS_Store" "*.swp" "node_modules" ];
  };
}
