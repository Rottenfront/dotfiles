{ pkgs, ... }:

{
  users.groups.plugdev = { };

  services.udev = {
    packages = [
      pkgs.usb-blaster-udev-rules
      pkgs.vial
    ];

    extraRules = ''
      # fix for webhid
      SUBSYSTEM=="hidraw", TAG+="uaccess"
    '';
  };

  virtualisation.docker.enable = true;

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

}
