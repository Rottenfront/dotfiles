{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.preferred = [
        "hyprland"
        "gtk"
      ];
    };
  };

  programs.noctalia.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
