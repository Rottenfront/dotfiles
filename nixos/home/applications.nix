{ inputs, pkgs, ... }:

{
  # Use detailed list view everywhere, ignoring saved per-folder views.
  xfconf.settings.thunar = {
    "default-view" = "ThunarDetailsView";
    "last-view" = "ThunarDetailsView";
    "misc-directory-specific-settings" = false;
  };

  home.packages =
    with pkgs;
    let
      mediaTools = [
        ffmpeg
        flac
        cuetools
        shntool
        kid3-cli
        imagemagick
      ];
      appStyle = [
        kdePackages.qt6ct
        libsForQt5.qt5ct
        adwaita-qt
      ];
    in
    mediaTools
    ++ appStyle
    ++ [
      (termusic.overrideAttrs (old: {
        doCheck = false;
      }))
      strawberry
      pwvucontrol

      bluetui
      inputs.wlctl.packages.${stdenv.hostPlatform.system}.default

      qbittorrent

      discord
      telegram-desktop

      libreoffice-stable

      file

      umu-launcher
    ];

  # EasyEffects is managed as a session service.
  services.easyeffects.enable = true;

  programs = {
    mangohud.enable = true;
    vesktop.enable = true;
    lutris.enable = true;
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
    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    jq.enable = true;

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
