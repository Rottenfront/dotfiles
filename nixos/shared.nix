{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./fonts.nix
    ./zapret.nix
    ./system/base.nix
    ./system/desktop.nix
    ./system/gaming.nix
    ./system/development.nix
    ./system/networking.nix
  ];
}
