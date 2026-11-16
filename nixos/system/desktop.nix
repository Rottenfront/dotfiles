{ pkgs, ... }:

{

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.getty.autologinUser = "rtfr";

  services = {
    udisks2 = {
      enable = true;
      settings."mount_options.conf".defaults.ntfs_drivers = "ntfs";
    };
    gvfs.enable = true;
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

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.thunar = {
    enable = true;
    plugins = [ pkgs.thunar-volman ];
  };
}
