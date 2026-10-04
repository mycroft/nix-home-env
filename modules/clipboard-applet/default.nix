{ pkgs, ... }:
let
  # The applet exits if no StatusNotifierWatcher is registered yet, which is
  # the case at sway startup as waybar (the tray host) is launched concurrently.
  # Wait for the watcher to appear (up to 30s) before starting the applet.
  startApplet = pkgs.writeShellScript "clipboard-applet-start" ''
    for _ in $(seq 60); do
      ${pkgs.systemd}/bin/busctl --user status org.kde.StatusNotifierWatcher >/dev/null 2>&1 && break
      sleep 0.5
    done
    exec ${pkgs.clipboard-applet}/bin/clipboard-applet
  '';
in
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
    exec ${startApplet}
  '';
}
