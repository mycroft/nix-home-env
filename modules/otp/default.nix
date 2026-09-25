{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      otp = super.callPackage ../../nix/otp.nix { };
    })
  ];

  home.packages = [ pkgs.otp ];

  xdg.configFile."otp/config.toml".source = ../../files/otp/config.toml;
}
