{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./shared.nix
  ];

  networking.hostName = "aorus";

}
