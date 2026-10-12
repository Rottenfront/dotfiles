{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    happ.url = "github:Rottenfront/happ.nix";
    ayuz.url = "github:Traciges/Ayuz";

    zapret.url = "github:novvux/zapret-discord-youtube-nix.flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.aorus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.ayuz.nixosModules.default
          inputs.zapret.nixosModules.default
          inputs.happ.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.rtfr = import ./home;
            };
          }
        ];
      };
    };
}
