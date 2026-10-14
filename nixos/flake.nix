{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ayuz = {
      url = "github:Traciges/Ayuz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapret = {
      url = "github:novvux/zapret-discord-youtube-nix.flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    termusic = {
      url = "github:rottenfront/termusic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:

    let
      home-manager-setup = [
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
    in
    {
      nixosConfigurations.aorus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./aorus.nix
          inputs.zapret.nixosModules.default
        ]
        ++ home-manager-setup;
      };

      nixosConfigurations.zenbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./zenbook.nix
          inputs.ayuz.nixosModules.default
          inputs.zapret.nixosModules.default
        ]
        ++ home-manager-setup;
      };
    };
}
