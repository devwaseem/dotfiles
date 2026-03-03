{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, sops-nix, home-manager }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Waseems-MacBook-Air
      darwinConfigurations = {
        "Waseems-MacBook-Air" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs self; };
          modules = [
            ./darwin.nix
            sops-nix.darwinModules.sops
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "nix.bk";
                users.waseemakram = {
                  imports = [
                    sops-nix.homeManagerModules.sops
                    ./home.nix
                  ];
                };
              };
              users.users.waseemakram.home = "/Users/waseemakram";
            }
          ];
        };
      };
    };
}
