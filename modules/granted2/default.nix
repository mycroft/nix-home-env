{ pkgs, ... }:
{
  imports = [ ../../nix/granted2-hm.nix ];

  nixpkgs.overlays = [ (self: super: { granted2 = super.callPackage ../../nix/granted2.nix { }; }) ];

  programs.granted2 = {
    enable = true;
    enableFishIntegration = true;
  };
}
