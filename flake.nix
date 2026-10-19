{
  description = "Waseem's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:herdrdev/herdr/v0.9.5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qmd = {
      url = "github:tobi/qmd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    omp.url = "github:can1357/oh-my-pi";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      sops-nix,
      home-manager,
      herdr,
      git-hooks-nix,
      qmd,
      omp,
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      pre-commit-check = git-hooks-nix.lib.${system}.run {
        src = ./.;
        hooks = {
          deadnix.enable = true;
          statix.enable = true;
        };
      };
    in
    {
      checks.${system}.pre-commit = pre-commit-check;
      formatter.${system} = pkgs.writeShellApplication {
        name = "format";
        runtimeInputs = [
          pkgs.findutils
          pkgs.nixfmt
        ];
        text = ''
          find . -type f -name '*.nix' -not -path './.git/*' -print0 \
            | xargs -0 -r nixfmt
        '';
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = pre-commit-check.enabledPackages ++ [
          pkgs.ast-grep
          pkgs.just
          pkgs.nvd
        ];
        inherit (pre-commit-check) shellHook;
      };

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
              nixpkgs.overlays = [
                herdr.overlays.default
                # Herdr 0.9.5 sorts by priority but does not render visible status-group headings.
                (_final: prev: {
                  herdr = prev.herdr.overrideAttrs (oldAttrs: {
                    patches = (oldAttrs.patches or [ ]) ++ [ ./patches/herdr-agent-status-groups.patch ];
                  });
                })
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "nix.bk";
                users.waseemakram = {
                  # OMP embeds this input's libiconv path in its extracted native addon.
                  home.packages = [ omp.inputs.nixpkgs.legacyPackages.${system}.libiconv ];
                  imports = [
                    sops-nix.homeManagerModules.sops
                    qmd.homeModules.default
                    omp.homeManagerModules.default
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
