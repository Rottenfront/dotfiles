{ config, pkgs, ... }:

{
  home.username = "rtfr";
  home.homeDirectory = "/home/rtfr";

  home.stateVersion = "26.11";

  programs.home-manager.enable = true;


  home.packages = with pkgs; [
    qbittorrent
    chromium
    
    kitty
    rofi # gui file opener
    hyprshot # screenshot utility
    playerctl

    telegram-desktop
    vesktop

    termusic
    kew
    pwvucontrol
    easyeffects
    helvum # PipeWire audio graphs
    
    btop
    mangohud
    
    thunar
    thunar-volman
    imv
    mpv
    zathura
    zathuraPkgs.zathura_pdf_mupdf

    github-cli
    
    neovide # neovim gui

    python314

    rustup

    clang
    clang-tools # clangd, clang-tidy, other utilities
    cmake
    meson
    vscode-json-languageserver

    typst
    mitex # TeX to typst
    typstyle
    typstPackages.cetz # graphics for Typst
    typstPackages.mmdr # mermaid for Typst
    tinymist # Typst LSP

    mermaid-cli

    miktex
    tex-fmt
    texlab # TeX LSP

    libreoffice-stable

    adwaita-icon-theme
    kdePackages.qt6ct
    libsForQt5.qt5ct
    adwaita-qt
  ];

  programs = {
    chromium.enable = true;
    firefox.enable = true;
    librewolf.enable = true;
    thunderbird.enable = true;

    mpv.enable = true;
    imv.enable = true;
    zathura.enable = true;
    yazi.enable = true;

    amp.enable = true;
    neovide.enable = true;

    noctalia.enable = true;
    hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/screenshots";
    };

    codex.enable = true;

    btop.enable = true;
    fastfetch = {
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

    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    jq.enable = true;

    fish = {
      loginShellInit = ''
        if uwsm check may-start
          exec uwsm start hyprland-uwsm.desktop
        end
      '';

      functions = {
        rename_number_dash = ''
          for file in *
              # Create new name
              set new_name (string replace -r '^([0-9]+) - ' '$1. ' -- $file)

              # Rename only if different
              if test "$file" != "$new_name"
                  mv -- "$file" "$new_name"
              end
          end
        '';
        rename_number_space = ''
          for file in *
              # Create new name
              set new_name (string replace -r '^([0-9]+) ' '$1. ' -- $file)

              # Rename only if different
              if test "$file" != "$new_name"
                  mv -- "$file" "$new_name"
              end
          end
        '';
        fish_greeting = "";
        detach = ''
          nohup $argv >/dev/null 2>&1 &
          disown
        '';
      };

      shellAliases = {
        ls = "eza -al --color=always --group-directories-first --icons=always";
        lt = "eza -aT --color=always --group-directories-first --icons=always";
        cp = "cp -r";
        scp = "sudo cp -r";
        rm = "rm -rf";
        srm = "sudo rm -rf";
        ".." = "cd ..";
        "..." = "cd ../..";
        jctl = "journalctl -p 3 -xb";
        ns = "nix-shell";
        yz = "yazi";
        v = "nvim";
        sv = "sudo nvim";
        tarnow="tar -acf ";
        untar="tar -zxvf ";
        wget="wget -c ";
        psmem="ps auxf | sort -nr -k 4";
        psmem10="ps auxf | sort -nr -k 4 | head -10";

        rebuild = "sudo nixos-rebuild switch";
      };

      shellInit = ''
        # format man pages
        set -x MANROFFOPT -c
        set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

        set -x PYTHONSTARTUP "$HOME/.pythonrc.py"

        fish_add_path "$HOME/.cargo/bin/"
        fish_add_path "$HOME/.local/bin/"

        test -r '/home/rtfr/.opam/opam-init/init.fish' && source '/home/rtfr/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true

        any-nix-shell fish --info-right | source

      '';
      enable = true;
    };

    gh.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          email = "rottenfront@atomicmail.io";
          name = "Andre Rottenfront";
        };
      };
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    size = 16;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/plain" = [ "neovide.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];

      "image/jpeg" = [ "imv.desktop" ];
      "image/png" = [ "imv.desktop" ];

      "video/mp4" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
    };
  };
}
