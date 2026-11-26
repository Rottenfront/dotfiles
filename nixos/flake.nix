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
    artcraft = {
      url = "github:devitek/artcraft-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bootvine = {
      url = "git+https://codeberg.org/wvhulle/bootvine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wlctl = {
      url = "github:aashish-thapa/wlctl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cintec = {
      url = "github:PepsiCommunity/cintec";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:

    let
      commonModules = [
        inputs.zapret.nixosModules.default
        inputs.bootvine.nixosModules.default
        inputs.artcraft.nixosModules.default
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
      mkHost =
        modules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = commonModules ++ modules;
        };
    in
    {
      nixosConfigurations = {
        aorus = mkHost [ ./aorus.nix ];
        zenbook = mkHost [
          inputs.ayuz.nixosModules.default
          ./zenbook.nix
        ];
      };
    };
}
