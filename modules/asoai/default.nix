{ pkgs, ... }:
{
  imports = [ ../../nix/asoai-hm.nix ];

  nixpkgs.overlays = [ (self: super: { asoai = super.callPackage ../../nix/asoai.nix { }; }) ];

  programs.asoai = {
    enable = true;
  };
}
