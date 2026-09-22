# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ./zapret.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.limine.enable = true;
  boot.loader.limine.maxGenerations = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "aorus";

  networking.networkmanager.enable = true;

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

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.users.rtfr = {
    isNormalUser = true;
    description = "Andre Rottenfront";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
    ];
    packages = with pkgs; [ ];

    shell = pkgs.fish;
  };

  services.getty.autologinUser = "rtfr";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    ryzenadj

    brightnessctl
    hyprpolkitagent

    sing-box
    gvfs

    eza # ls
    jq # json queries
    yq # yaml queries
    fd # find
    fzf
    ripgrep # grep
    git
    p7zip
    wget

    any-nix-shell
  ];

  programs = {
    fish.enable = true;

    gamemode.enable = true;
    gamescope.enable = true;

    neovim.enable = true;
    steam = {
      enable = true;
      protontricks.enable = true;
    };
  };

  services.gvfs.enable = true;

  services.upower.enable = true;

  console = {
    keyMap = "colemak";
  };

  # fontconfig
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      paratype-pt-sans
      paratype-pt-serif
      paratype-pt-mono

      liberation_ttf
      cascadia-code

      texliveConTeXt.fonts
      corefonts

      (pkgs.runCommand "sofia-sans" { } ''
        mkdir -p $out/share/fonts/truetype
        cp ${./sofia-sans/SofiaSans-VariableFont_wght.ttf} $out/share/fonts/truetype/
        cp ${./sofia-sans/SofiaSans-Italic-VariableFont_wght.ttf} $out/share/fonts/truetype/
      '')
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [ "Sofia Sans" ];
        serif = [ "PT Serif" ];
        monospace = [ "Cascadia Code" ];
        emoji = [ "Noto Color Emogi" ];
      };

      hinting = {
        enable = true;
        style = "slight";
      };

      # antialias = true;
      subpixel = {
        rgba = "rgb";
      };
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "yourusername" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/tee";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
    
  # proxy & anti-dpi
  services.happ.enable = true;

  # repo version
  system.stateVersion = "26.11";
}
