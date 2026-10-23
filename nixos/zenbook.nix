{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./shared.nix
  ];

  hardware.cpu.amd.ryzen-smu.enable = false;
  networking.hostName = "zenbook";

  environment.systemPackages = with pkgs; [
    ryzenadj
  ];

  services.ayuz = {
    enable = true;
    supportMyAsusKey = true;
  };

  services.upower.enable = true;
}
