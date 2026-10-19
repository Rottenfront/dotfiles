{ config, pkgs, ... }:

{
  programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos_small";
          padding = {
            top = 1;
            right = 2;
          };
        };
        display = {
          constants = [
            "─────────────────"
          ];
          key = {
            type = "icon";
            paddingLeft = 2;
          };
        };
        modules = [
          {
            type = "custom";
            format = "┌{$1} {#1}Hardware Information{#} {$1}┐";
          }
          "host"
          "cpu"
          "gpu"
          "disk"
          "memory"
          "swap"
          "display"
          "brightness"
          "battery"
          "poweradapter"
          "bluetooth"
          "sound"
          "gamepad"
          {
            type = "custom";
            format = "├{$1} {#1}Software Information{#} {$1}┤";
          }
          {
            type = "title";
            keyIcon = "";
            key =  "Title";
            format =  "{user-name}@{host-name}";
          }
          "os"
          "kernel"
          "lm"
          "de"
          "wm"
          "shell"
          "terminal"
          "theme"
          "icons"
          "wallpaper"
          "packages"
          "uptime"
          {
            type = "custom";
            format = "└{$1}──────────────────────{$1}┘";
          }
          {
            type = "colors";
            paddingLeft = 2;
          }
        ];
      };
    };
}
