{pkgs,...}:
{
environment.systemPackages = with pkgs; [
gnumake
fzf
tmux
rsync
unzip
wget
starship
clang
];



}
