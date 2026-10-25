{ config, ... }:
let
  source = "${config.home.homeDirectory}/.claude-at-work";
in
{
  services.restic = {
    enable = true;

    backups.claude-at-work = {
      # Garage S3 API, reached over Tailscale; the bucket holds one repository per prefix.
      repository = "s3:http://moonstone:3900/backup-relax/claude";
      # Both files are created by hand and kept out of the Nix store.
      passwordFile = "/etc/restic-claude-backup";
      environmentFile = "${config.xdg.configHome}/restic/claude-at-work.env";
      initialize = true;

      paths = [ source ];
      exclude = [
        "${source}/.credentials.json"
        "${source}/cache"
        "${source}/plugins/cache"
        "${source}/plugins/marketplaces"
        "${source}/plugins/plugin-directory-cache-v2.json"
        "${source}/shell-snapshots"
        "${source}/telemetry"
      ];

      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = "5m";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-hourly 24"
        "--keep-daily 14"
        "--keep-weekly 8"
        "--keep-monthly 12"
      ];
    };
  };
}
