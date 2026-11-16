{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  programs.amnezia-vpn.enable = true;
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
