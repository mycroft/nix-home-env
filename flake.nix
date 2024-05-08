{
  description = "home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , pre-commit-hooks
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

      checks.${system} = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;

          hooks = {
            nixpkgs-fmt = {
              enable = true;
            };
          };
        };
      };

      devShell.${system} = pkgs.mkShell {
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

        nativeBuildInputs = with pkgs; [ wget s-tar ];
        packages = with pkgs; [
          alejandra
          git
          nix
        ];

        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    };
}
