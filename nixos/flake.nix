{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    happ.url = "github:Rottenfront/happ.nix";
    noctalia.url = "github:noctalia-dev/noctalia";
    ayuz.url = "github:Traciges/Ayuz";

    zapret.url = "github:novvux/zapret-discord-youtube-nix.flake";
  };

  outputs = { self, nixpkgs, happ, zapret, ayuz, ... }@inputs: {
    nixosConfigurations.aorus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	./hyprland.nix
	./zapret.nix
	ayuz.nixosModules.default
	zapret.nixosModules.default
        happ.nixosModules.default
      ];
    };
  };
}
