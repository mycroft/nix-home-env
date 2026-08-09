{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      clipboard-applet = super.callPackage ../../nix/clipboard-applet.nix { };
    })
  ];

  home.packages = [ pkgs.clipboard-applet ];

  xdg.dataFile."applications/clipboard-applet.desktop".source =
    "${pkgs.clipboard-applet}/share/applications/clipboard-applet.desktop";

  systemd.user.services.clipboard-applet = {
    Unit = {
      Description = "Wayland clipboard tray applet";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.clipboard-applet}/bin/clipboard-applet";
      Restart = "on-abnormal";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
