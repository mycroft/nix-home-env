{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      clipboard-applet = super.callPackage ../../nix/clipboard-applet.nix { };
    })
  ];

  home.packages = [ pkgs.clipboard-applet ];

  xdg.configFile."clipboard-applet/config.toml".source = ../../files/clipboard-applet/config.toml;

  xdg.dataFile."applications/clipboard-applet.desktop".source =
    "${pkgs.clipboard-applet}/share/applications/clipboard-applet.desktop";

  # Started by sway at login rather than as a systemd user service: home-manager
  # (re)starts services on switch, which fails when the switch does not run from
  # the graphical session. Sway only runs `exec` lines at startup, not on reload.
  xdg.configFile."sway/config.d/clipboard-applet.conf".text = ''
    exec ${pkgs.clipboard-applet}/bin/clipboard-applet
  '';
}
