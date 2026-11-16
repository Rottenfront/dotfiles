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

  # Use detailed list view everywhere, ignoring saved per-folder views.
  xfconf.settings.thunar = {
    "default-view" = "ThunarDetailsView";
    "last-view" = "ThunarDetailsView";
    "misc-directory-specific-settings" = false;
  };

  home.packages = with pkgs; [
    (termusic.overrideAttrs (old: {
      doCheck = false;
    }))
    strawberry
    pwvucontrol
    easyeffects

    bluetui
    inputs.wlctl.packages.${stdenv.hostPlatform.system}.default

    adwaita-icon-theme
    kdePackages.qt6ct
    libsForQt5.qt5ct
    adwaita-qt

    file
    mangohud

    thunar
    thunar-volman

    qbittorrent
    telegram-desktop
    vesktop

    libreoffice-stable

    ffmpeg
    flac
    cuetools
    shntool
    kid3-cli
    imagemagick

    lutris
    umu-launcher
  ];

  programs = {
    chromium.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;

    ghostty = {
      enable = true;
      enableFishIntegration = true;
      installBatSyntax = true;
      systemd.enable = true;
      settings = {
        font-family = "Cascadia Code NF";
        font-feature = "-calt -liga -dlig";
        font-size = 10;
        theme = "Patina Dark";
        background-opacity = 0.95;
        background-opacity-cells = true;
      };
    };

    mpv.enable = true;
    imv.enable = true;
    zathura = {
      enable = true;

      package = pkgs.zathura.override {
        plugins = with pkgs.zathuraPkgs; [
          zathura_pdf_mupdf
          zathura_djvu
        ];
      };
    };
    yazi.enable = true;

    btop.enable = true;

    zed-editor = {
      enable = true;
      userSettings = {
        buffer_font_size = 12;
        buffer_font_family = "Cascadia Code NF";
        features = {
          copilot = false;
        };
        telemetry = {
          metrics = false;
        };
        ui_font_size = 14;
        ui_font_family = "Sofia Sans";
        vim_mode = false;
      };
    };
  };
}
