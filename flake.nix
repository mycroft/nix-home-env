{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs
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
