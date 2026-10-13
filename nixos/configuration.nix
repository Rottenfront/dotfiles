# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./hardware-configuration.nix
    ./fonts.nix
    ./zapret.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.limine.enable = true;
  boot.loader.limine.maxGenerations = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
      "docker"
    ];
    packages = with pkgs; [ ];

    shell = pkgs.fish;
  };

  services.getty.autologinUser = "rtfr";

  environment.systemPackages = with pkgs; [
    vial

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
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    fish.enable = true;

    gamemode.enable = true;
    gamescope.enable = true;

    neovim.enable = true;
    steam = {
      enable = true;
      protontricks.enable = true;
    };
    # proxy
    amnezia-vpn.enable = true;
    throne = {
      enable = true;
      tunMode.enable = true;
    };
  };

  services = {
    gvfs.enable = true;
  };

  virtualisation.docker.enable = true;

  console = {
    keyMap = "colemak";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.preferred = [
        "hyprland"
        "gtk"
      ];
    };
  };

  # repo version
  system.stateVersion = "26.11";
}
