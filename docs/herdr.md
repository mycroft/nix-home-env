# herdr

[herdr](https://github.com/herdrdev/herdr) is a terminal workspace manager for AI coding agents. The package comes from its own flake input and is installed through `herdrPackage` in `flake.nix`.

## What this repository manages

Only `~/.config/herdr/config.toml`, from `files/herdr/config.toml` (keybinding prefix and notification sounds).

Everything else — sessions, the update channel, plugins, and agent integrations — is runtime state that herdr owns itself and is deliberately left unmanaged.

## Agent integrations

Integrations let an agent report its state (working, blocked, idle) back to the herdr pane. They cannot be declared in `config.toml`: that file has no integrations section, and `herdr integration install` writes into each *agent's* configuration directory rather than herdr's own.

List the available targets and check what is currently installed:

```sh
herdr integration list
herdr integration status
herdr integration status --outdated-only
```

Install the ones matching the agents in use:

```sh
herdr integration install pi
herdr integration install claude
herdr integration install codex
herdr integration install opencode
```

Each target requires the agent's configuration directory to already exist, otherwise the command reports `install <agent> first`. For `pi`, the directory is `~/.pi/agent/extensions`.

Remove one with the matching `uninstall` command:

```sh
herdr integration uninstall pi
```

### Files written per target

| Target | Drop-in file | Existing files also edited |
|--------|--------------|----------------------------|
| `pi` | `~/.pi/agent/extensions/herdr-agent-state.ts` | none |
| `opencode` | `~/.config/opencode/plugins/herdr-agent-state.js` | none |
| `claude` | `~/.claude/hooks/herdr-agent-state.sh` | `~/.claude/settings.json` |
| `codex` | `~/.codex/herdr-agent-state.sh` | `~/.codex/hooks.json`, `~/.codex/config.toml` |

The `pi` and `opencode` integrations only add a sibling file, so they do not conflict with the `files/pi/models.json` and `files/opencode/opencode.json` entries managed here. The `claude` and `codex` integrations merge a hook block into an existing configuration file and embed an absolute path to the hook script, which is why those files are left out of Home Manager.

### Keeping integrations current

Every installed script carries a `HERDR_INTEGRATION_VERSION` header and is overwritten on reinstall. After a `herdr update`, check for stale scripts and reinstall the affected targets:

```sh
herdr update
herdr integration status --outdated-only
```

## Configuration changes

After editing `files/herdr/config.toml` and running `home-manager switch`, validate the result and reload a running server without restarting it:

```sh
herdr config check
herdr server reload-config
```

## References

- [herdr repository](https://github.com/herdrdev/herdr) — source and release notes
- `herdr --help` — full command list, including the socket API helpers
