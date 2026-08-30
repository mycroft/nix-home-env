{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      power-module = super.callPackage ../../nix/power-module.nix { };
    })
  ];

  home.packages = [ pkgs.power-module ];

  xdg.configFile."power-module.toml".source = ../../files/power-module.toml;
}
