{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      lock-indicator = super.callPackage ../../nix/lock-indicator.nix { };
    })
  ];

  home.packages = [ pkgs.lock-indicator ];
}
