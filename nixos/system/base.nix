{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
  ];

  nixpkgs.config.allowUnfree = true;

  services.bootvine.enable = true;

  boot.loader.limine.enable = true;
  boot.loader.limine.maxGenerations = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-amd" ];
  boot.blacklistedKernelModules = [
    "ftdi_sio"
    "ntfs3"
  ];

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    usbutils
    pciutils
    lsof

    ntfs3g

    gdu

    yq # yaml queries
    p7zip
    wget

    any-nix-shell
  ];

  console = {
    keyMap = "colemak";
  };

  system.stateVersion = "26.11";
  programs.fish.enable = true;
  programs.neovim.enable = true;
  programs.artcraft = {
    enable = true;
    apps = [
      "photocraft"
      "pdfcraft"
      "deckcraft"
      "wordcraft"
      "gridcraft"
    ];
  };
}
