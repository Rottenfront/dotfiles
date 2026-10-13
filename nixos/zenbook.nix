{
  config,
  pkgs,
  ...
}:

{

  networking.hostName = "aorus";

  environment.systemPackages = with pkgs; [
    ryzenadj
  ];

  services.ayuz = {
    enable = true;
    supportMyAsusKey = true;
  };

  services.upower.enable = true;
}
