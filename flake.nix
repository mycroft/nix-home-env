{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for flux-cd 2.0.1
    nixpkgs-fluxcd.url = "github:nixos/nixpkgs/976fa3369d722e76f37c77493d99829540d43845";
  };

  outputs =
    inputs@{ nixpkgs
    , nixpkgs-fluxcd
    , home-manager
    , ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config = { allowUnfree = true; };
        inherit system;
      };
    in
    {
      defaultPackage.${system} = home-manager.defaultPackage.${system};
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      homeConfigurations = {
        "mycroft" = inputs.home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home.nix
          ];
          extraSpecialArgs = {
            enableJobFeatures = true;

            versions = {
              pkgs-fluxcd = nixpkgs-fluxcd.legacyPackages.${system};
            };
          };

          inherit pkgs;
        };
      };

      devShell.${system} = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ wget s-tar ];
        packages = with pkgs; [
          alejandra
          git
          nix
        ];
      };
    };
}
