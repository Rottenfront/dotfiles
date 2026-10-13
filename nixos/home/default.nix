{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./programs/fastfetch.nix
    ./programs/rofi.nix
    ./programs/shell.nix
    ./programs/tmux.nix
    ./hyprland.nix
    ./theme.nix
    ./mime.nix
  ];

  home.username = "rtfr";
  home.homeDirectory = "/home/rtfr";

  home.stateVersion = "26.11";

  # Home profiles do not run the OCaml library setup hooks used by nix-shell.
  home.sessionVariables.OCAMLPATH = lib.makeSearchPath "lib/ocaml/${pkgs.ocaml.version}/site-lib" (
    lib.closePropagation [ pkgs.ocamlPackages.alcotest ]
  );

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    inputs.termusic.packages.${stdenv.hostPlatform.system}.default
    playerctl
    pwvucontrol
    easyeffects
    brightnessctl

    hyprpolkitagent

    hyprpaper
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

    # language support
    gcc
    python314
    nodejs
    rustup

    # OCaml
    # (lib.lowPrio gcc) # OCaml invokes gcc; keep clang preferred for cc/c++.
    ocaml
    dune_3
    ocamlPackages.findlib
    ocamlPackages.alcotest

    # Haskell
    (haskellPackages.ghcWithPackages (ps: [ ps.parsec ]))
    cabal-install

    (texliveBasic.withPackages (
      ps: with ps; [
        latexmk

        # languages
        fontspec
        babel-russian
        hyphen-russian

        # decorations
        titlesec
        tcolorbox
        pdfcol

        # TikZ
        tikzfill
      ]
    ))

    # build systems
    cmake

    # programming tools
    clang-tools # clangd, clang-tidy, other utilities
    lua-language-server
    nixfmt
    tex-fmt
    texlab # TeX LSP
    vscode-json-languageserver

    google-chrome
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

    amp.enable = true;
    neovide = {
      enable = true;
      settings = {
        font = {
          normal = [ "Cascadia Code" ];
          size = 12.0;
        };
      };
    };

    btop.enable = true;

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
}
