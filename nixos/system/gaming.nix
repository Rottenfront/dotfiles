{ pkgs, ... }:

{

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
}
