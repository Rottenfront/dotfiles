{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    happ = {
      url = "github:Rottenfront/happ.nix";
      inputs.nixpkgs.follows = "nixpkgs"; # optional
    };


    zapret.url = "github:novvux/zapret-discord-youtube-nix.flake";
  };

  outputs = { self, nixpkgs, happ, zapret, ... }@inputs: {
    nixosConfigurations.aorus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	./hyprland.nix
	./zapret.nix
	zapret.nixosModules.default
        happ.nixosModules.default
      ];
    };
  };
}
