{ pkgs, ... }:
{
  nixpkgs.overlays = [ (self: super: { tlrc = super.callPackage ../../nix/tlrc.nix { }; }) ];
}
