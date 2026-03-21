





{pkgs,...}:
{
programs.niri.enable = true;
services.displayManager.ly.enable = true;


environment.systemPackages = with pkgs; [
fuzzel
alacritty
wl-clipboard-rs
kitty
firefox
];







}
