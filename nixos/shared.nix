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

  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
  ];

  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.limine.enable = true;
  boot.loader.limine.maxGenerations = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "usbcore.old_scheme_first=1"
    "usbcore.autosuspend=-1"
  ];
  boot.blacklistedKernelModules = [ "ftdi_sio" ];

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
  i18n.extraLocales = [
    "bg_BG.UTF-8/UTF-8"
    "ro_RO.UTF-8/UTF-8"
  ];
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

  users.groups.plugdev = { };

  users.users.rtfr = {
    isNormalUser = true;
    description = "Andre Rottenfront";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
      "docker"
      "plugdev"
    ];
    packages = with pkgs; [ ];

    shell = pkgs.fish;
  };

  services.getty.autologinUser = "rtfr";

  services.udev = {
    packages = [
      pkgs.vial
      (pkgs.writeTextFile {
        name = "intel-fpga";
        text = ''
          SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6022", MODE="0666"
        '';
        destination = "/etc/udev/rules.d/90-intel-fpga.rules";
      })
    ];
    extraRules = ''
      # Common FTDI clones (FT245 / FT232)
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", MODE="0666", GROUP="plugdev", TAG+="uaccess"

      # Disable runtime power management specifically for USB-Blaster devices
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", ATTR{power/control}="on"
    '';
  };

  environment.systemPackages = with pkgs; [
    vial

    gvfs

    usbutils
    pciutils

    gdu

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

    artcraft = {
      enable = true;
      apps = [
        "photocraft"
        "pdfcraft"
      ];
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

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      # List by default
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
    ];
  };

  # repo version
  system.stateVersion = "26.11";
}
