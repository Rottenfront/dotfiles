{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
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

  home.packages = with pkgs; [
    # inputs.termusic.packages.${stdenv.hostPlatform.system}.default
    termusic
    strawberry
    pwvucontrol
    easyeffects

    adwaita-icon-theme
    kdePackages.qt6ct
    libsForQt5.qt5ct
    adwaita-qt

    file
    mangohud

    thunar
    thunar-volman
    zathura
    zathuraPkgs.zathura_pdf_mupdf

    qbittorrent
    telegram-desktop
    vesktop

    libreoffice-stable

    anki
  ];

  programs = {
    chromium.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;

    kitty = {
      enable = true;
      font = {
        name = "Cascadia Code";
        size = 10.0;
      };
      settings = {
        disable_ligatures = "always";
      };
    };

    mpv.enable = true;
    imv.enable = true;
    zathura.enable = true;
    yazi.enable = true;

    btop.enable = true;
  };
}
