{ pkgs, ... }:
{
  nixpkgs.overlays = [ (self: super: { mmtc = super.callPackage ../../nix/mmtc.nix { }; }) ];
}
