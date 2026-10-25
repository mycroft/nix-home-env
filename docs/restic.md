# restic

Backups of `relax` go to a [Garage](https://garagehq.deuxfleurs.fr/) S3 bucket on `moonstone`, through the Home Manager `services.restic` module. They are declared in `modules/restic/default.nix`, which `flake.nix` imports for the `relax` host only.

## Layout

- Endpoint: Garage S3 API on `moonstone`, port `3900`, region `garage`, reached over Tailscale.
- Bucket: `backup-relax`, one restic repository per prefix (`backup-relax/<prefix>`).
- Each prefix is an independent repository: its own password, retention, and lock. Data is not deduplicated across prefixes.

| Backup | Source | Repository | Password file | Schedule |
|--------|--------|------------|---------------|----------|
| `claude-at-work` | `~/.claude-at-work` | `s3:http://moonstone:3900/backup-relax/claude` | `/etc/restic-claude-backup` | hourly |

Each `backups.<name>` entry produces a `restic-backups-<name>` user service and timer, plus a `restic-<name>` wrapper that runs restic with the repository, password, and S3 credentials already set.

## Secrets

Secrets never enter this repository or the Nix store; the module only references their paths.

Password file, one per repository. Generate it once and keep a copy outside the machine: without it the repository cannot be decrypted.

```sh
openssl rand -base64 48 | sudo install -m 0400 -o $USER -g $USER /dev/stdin /etc/restic-<name>-backup
```

S3 credentials, in `~/.config/restic/claude-at-work.env` (mode `0600`). Every repository in `backup-relax` can reuse it. The file is read both by systemd (`EnvironmentFile=`) and by the wrapper (sourced by bash), so keep plain `KEY=value` lines: no `export`, no spaces around `=`, no quotes.

```
AWS_ACCESS_KEY_ID=GK...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=garage
```

The Garage key needs access to the bucket. On `moonstone`:

```sh
garage bucket allow --read --write backup-relax --key <key-name>
```

## Add a backup

1. Create its password file (see above).
2. Add an entry next to `claude-at-work` in `modules/restic/default.nix`:

   ```nix
   backups.<name> = {
     repository = "s3:http://moonstone:3900/backup-relax/<prefix>";
     passwordFile = "/etc/restic-<name>-backup";
     environmentFile = "${config.xdg.configHome}/restic/claude-at-work.env";
     initialize = true;
     paths = [ "${config.home.homeDirectory}/<dir>" ];
     exclude = [ ];
     timerConfig = {
       OnCalendar = "daily";
       RandomizedDelaySec = "5m";
       Persistent = true;
     };
     pruneOpts = [
       "--keep-daily 14"
       "--keep-weekly 8"
       "--keep-monthly 12"
     ];
   };
   ```

   Use strings, not Nix paths, for `passwordFile` and `environmentFile`: a path literal would copy the secret into the world-readable Nix store.

3. Apply and run the first backup, which also creates the repository (`initialize = true`):

   ```sh
   home-manager switch --flake ".#relax"
   systemctl --user start restic-backups-<name>.service
   journalctl --user -u restic-backups-<name> -n 50
   ```

## Run and inspect

Backups run from the user timer, so only while the user session is up. `Persistent = true` runs a missed slot at the next login or resume.

```sh
systemctl --user list-timers 'restic-backups-*'       # next and last runs
systemctl --user start restic-backups-<name>.service  # back up now
journalctl --user -u restic-backups-<name> -n 50      # last run
restic-<name> snapshots
restic-<name> stats latest
```

Each run creates the repository if it is missing, backs up, then runs `unlock`, `forget --prune` with `pruneOpts`, and `restic check`.

## Restore

```sh
restic-<name> snapshots
restic-<name> ls latest
restic-<name> restore latest --target /tmp/restore
restic-<name> restore latest --target /tmp/restore --include <absolute-path>
```

Restored files keep their absolute path under the target, for example `/tmp/restore/home/<user>/.claude-at-work`. Restore to a scratch directory and copy back what is needed rather than restoring over a live directory.

## Change or remove a backup

Edit `paths`, `exclude`, `timerConfig`, or `pruneOpts` and run `home-manager switch`. A new `pruneOpts` policy applies at the next run.

Removing an entry stops its timer and service but leaves the repository in the bucket. Delete its `<prefix>/` objects with an S3 client once the data is no longer needed.

## Troubleshooting

- `restic-<name>: command not found` right after a switch: open a new shell, or call `~/.nix-profile/bin/restic-<name>`.
- `AccessDenied` / 403: the Garage key is not allowed on `backup-relax` (see Secrets).
- Connection refused or DNS failure: Tailscale is down or `moonstone` is offline; the next run retries.
- `repository is already locked`: a run was interrupted. Check that no backup is running, then `restic-<name> unlock`.
- Garage is served over plain HTTP. That is acceptable only because traffic stays inside Tailscale and restic encrypts data client-side.
