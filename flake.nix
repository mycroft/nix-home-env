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
    {
      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      homeConfigurations = {
        "mycroft" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          modules = [
            ./home.nix
          ];
          extraSpecialArgs = {
            enableJobFeatures = true;

            versions = {
              pkgs-fluxcd = nixpkgs-fluxcd.legacyPackages.x86_64-linux;
            };
          };
        };
      };
    };
}
