{
  lib,
  config,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland:xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct:qt6ct";
    SDL_VIDEODRIVER = "wayland,x11";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    PROTON_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  home.packages = with pkgs; [
    playerctl
    brightnessctl

    lm_sensors
    wf-recorder
    libnotify
    pipewire
    wl-clipboard
    gawk
    gnused
    procps
  ];

  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = [ "graphical-session.target" ];
  };

  services.hyprpolkitagent.enable = true;
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/wallpaper.jpg";
          fit_mode = "cover";
        }
      ];
    };
  };
  programs.quickshell.enable = true;
  programs.cava.enable = true;

  systemd.user.services.cliphist.Service = {
    ExecStart = lib.mkForce "${lib.getExe' config.services.cliphist.clipboardPackage "wl-paste"} --type text --watch ${lib.getExe config.services.cliphist.package} ${lib.escapeShellArgs config.services.cliphist.extraOptions} store";
    UMask = "0077";
  };
  systemd.user.services.cliphist-images.Service.UMask = "0077";

  xdg.configFile = {

    "xkb/symbols/en_custom".source = ./keyboard/symbols/en_custom;

    "xkb/symbols/ru_custom".source = ./keyboard/symbols/ru_custom;

    "xkb/rules/evdev.xml".source = ./keyboard/rules/evdev.xml;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # UWSM owns the session and graphical-session.target.
    systemd.enable = false;
  };

  programs = {
    hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/screenshots";
    };
  };
}
