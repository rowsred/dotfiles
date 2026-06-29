{ pkgs, ... }:
let
  sf-mono-nerd = pkgs.stdenv.mkDerivation {
    pname = "sf-mono-nerd-font";
    version = "18.0d1e1.0";
    src = pkgs.fetchurl {
      url = "https://github.com/epk/SF-Mono-Nerd-Font/archive/refs/tags/v18.0d1e1.0.tar.gz";
      sha256 = "sha256-me+FvhQjUEkMvNk4PatNhldfozDbHKi1ezshq3uL8vc="; # Use nix-prefetch-url to get the hash
    };
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -vr *.otf $out/share/fonts/opentype/ || cp -vr */*.otf $out/share/fonts/opentype/
    '';
  };
  sf-pro-display = pkgs.stdenv.mkDerivation {
    pname = "sf-pro-display";
    version = "git";
    src = pkgs.fetchurl {
      url = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts/raw/refs/heads/master/SF-Pro-Display-Regular.otf";
      sha256 = "sha256-fcBKwRAA91nJc6RcYQniwWQ3LbDbI91HlsiH33MEjNA=";
    };
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp $src $out/share/fonts/opentype/SF-Pro-Display-Regular.otf
    '';
  };
in

{

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme = true
  '';
  services.displayManager.ly.enable = true;
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    firefox
    hyprlauncher
    waybar
    foot
  ];
  fonts.packages = [
    sf-pro-display
    sf-mono-nerd
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "SF Pro Display" ];
      monospace = [ "SFMono Nerd Font" ];
      serif = [ "SF Pro Display" ];
    };
  };

}
