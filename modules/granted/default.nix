{ pkgs, ... }:
{
  nixpkgs.overlays = [ (self: super: { granted = super.callPackage ../../nix/granted.nix { }; }) ];
}
