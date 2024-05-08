{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , home-manager
    , pre-commit-hooks
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        config = { allowUnfree = true; };
        inherit system;
      };
    in
    {
      legacyPackages = {
        homeConfigurations = {
          "mycroft" = inputs.home-manager.lib.homeManagerConfiguration {
            modules = [
              ./home.nix
            ];

            inherit pkgs;
          };
        };
      };
      defaultPackage = home-manager.defaultPackage.${system};
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;

          hooks = {
            nixpkgs-fmt = {
              enable = true;
            };
          };
        };
      };

      devShell = pkgs.mkShell {
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

        nativeBuildInputs = with pkgs; [ wget s-tar ];
        packages = with pkgs; [
          alejandra
          git
          nix
        ];

        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });
}
