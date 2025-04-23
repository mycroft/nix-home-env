{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24-11.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-terragrunt-0-73-12 = {
      url = "github:nixos/nixpkgs/39d921ecb8fc4028eb43d9a87bdeef55ff86fa9b";
    };
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dagger = {
      url = "github:dagger/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-24-11
    , nixpkgs-terragrunt-0-73-12
    , flake-utils
    , home-manager
    , nur
    , dagger
    , pre-commit-hooks
    , rust-overlay
    , ...
    }:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
    let
      overlays = [ nur.overlays.default (import rust-overlay) ];
      pkgs = import nixpkgs {
        config = { allowUnfree = true; };
        inherit system overlays;
      };
      pkgs-24-11 = import nixpkgs-24-11 {
        config = { allowUnfree = true; };
        inherit system overlays;
      };
      pkgs-terragrunt-0-73-12 = import nixpkgs-terragrunt-0-73-12 {
        config = { allowUnfree = true; };
        inherit system overlays;
      };
      daggerPkgs = dagger.packages.${system};

      modules = [
        ./home.nix
      ];

      extraSpecialArgs = rec {
        username = "mycroft";
        homeDirectory = "/home/${username}";
        commonVars = { };

        inherit daggerPkgs pkgs-24-11 pkgs-terragrunt-0-73-12;
      };
    in
    {
      # home-manager is looking into either packages.<system>, legacyPackages.<system> or
      # directly "homeConfigurations".<user>. As eachSystem is overwriting top level key part
      # adding system, only packages & legacyPackages are possible. Using packages makes nix flake
      # unhappy as this is not a derivation... Seems like legacyPackages will do it.
      legacyPackages = {
        homeConfigurations = {
          # default configuration
          "mycroft" = home-manager.lib.homeManagerConfiguration {
            inherit extraSpecialArgs modules pkgs;
          };
          "glitter" = home-manager.lib.homeManagerConfiguration {
            inherit extraSpecialArgs modules pkgs;
          };
          "nee" = home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = extraSpecialArgs // {
              commonVars = {
                # Somehow required for electron apps to be happy with wayland
                # without this, I'm getting borders for menus in VScode as it seems
                # to be using xwayland.
                # To be used only on my archlinux system; On fedora, x11 is required.
                ELECTRON_OZONE_PLATFORM_HINT = "auto";
              };
            };
            inherit modules pkgs;
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

        nativeBuildInputs = with pkgs; [ wget ];
        packages = with pkgs; [
          alejandra
          git
          nix
        ];

        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });
}
