{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
    , rust-overlay
    , ...
    }:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
    let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        config = { allowUnfree = true; };
        inherit system overlays;
      };
    in
    {
      # home-manager is looking into either packages.<system>, legacyPackages.<system> or
      # directly "homeConfigurations".<user>. As eachSystem is overwriting top level key part
      # adding system, only packages & legacyPackages are possible. Using packages makes nix flake
      # unhappy as this is not a derivation... Seems like legacyPackages will do it.
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

      devShells.default = pkgs.mkShell {
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
