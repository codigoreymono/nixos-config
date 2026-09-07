{
  description = "NixOS hm";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    herdr-nix = {
      url = "github:herdrdev/herdr-nix";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.elitebook = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./elitebook/configuration.nix
          ./elitebook/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            home-manager.users.reymono =
              import ./home/home.nix;
          }
        ];
      };
    };
}
