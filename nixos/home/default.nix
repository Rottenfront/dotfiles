{
  ...
}:

{
  imports = [
    ./applications.nix
    ./fastfetch.nix
    ./hyprland.nix
    ./mime.nix
    ./programming.nix
    ./rofi.nix
    ./shell.nix
    ./theme.nix
    ./tmux.nix
  ];

  home.username = "rtfr";
  home.homeDirectory = "/home/rtfr";

  home.stateVersion = "26.11";

  programs.home-manager.enable = true;

}
