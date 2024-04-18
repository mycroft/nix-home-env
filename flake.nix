{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private-repository = {
      url = "git+ssh://git@git.mkz.me/mycroft/nix-home-private.git";
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "/home/mycroft/dev/nix-home-private";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      private-repository,
      ...
    }:
    {
      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      homeConfigurations = {
        "mycroft" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home.nix
            "${private-repository}/home.nix"
          ];
          extraSpecialArgs = {
            enableJobFeatures = true;
          };
        };
      };
    };
}
