# nix-home-env

Personal [Home Manager](https://github.com/nix-community/home-manager) configuration for a Nix-based development environment. The flake provides a shared configuration plus optional Sway and Waybar settings for several hosts.

## Features

- Reproducible command-line and development tools from a pinned `flake.lock`
- Modular configuration for Fish, Git, Neovim, SSH, tmux, and other tools
- Host-specific Sway configuration with a shared fallback
- Formatting checks through `nix flake check`

## Getting started

### Prerequisites

- A 64-bit Linux system (`x86_64-linux`)
- Nix with the `nix-command` and `flakes` experimental features enabled
- Git
- A Nerd Font providing the `Symbols Nerd Font` family, for the Waybar hosts — the ac, battery and backlight modules use Nerd Fonts glyphs that render as tofu without it (Fedora needs the `che/nerd-fonts` Copr; it is not in the official repositories)

Install Nix by following the [official installation instructions](https://nixos.org/download/). For a multi-user installation, ensure the Nix daemon is running before continuing.

Enable flakes if they are not already enabled:

```sh
mkdir -p ~/.config/nix
grep -qxF 'extra-experimental-features = nix-command flakes' ~/.config/nix/nix.conf 2>/dev/null || \
  printf '%s\n' 'extra-experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

### Installation

Clone the repository:

```sh
git clone https://github.com/mycroft/nix-home-env.git ~/.config/home-manager
cd ~/.config/home-manager
```

Choose the configuration matching the machine:

| Host | Desktop configuration |
|------|-----------------------|
| `mycroft` | Base configuration only |
| `moonstone` | Base configuration only (headless AI node) |
| `glitter` | Sway and Waybar, with host-specific Sway settings |
| `quantum` | Sway and Waybar, using the default Sway host settings |
| `relax` | Sway and Waybar, with host-specific Sway settings |
| `nee` | Sway and Waybar, with host-specific Sway and Electron settings |

Apply it by replacing `<host>` with one of the names above:

```sh
nix run github:nix-community/home-manager -- switch --flake ".#<host>" -b backup
```

The `-b backup` option moves files that would otherwise conflict with Home Manager. After the first successful installation, use the installed command for subsequent updates:

```sh
home-manager switch --flake ".#<host>"
```

## Development

Enter the development shell to install the formatter and Git pre-commit hook:

```sh
nix develop
```

Format Nix files:

```sh
nix fmt
```

Run the flake checks:

```sh
nix flake check
```

## Agent skills

`modules/agent-skills` links each skill directory into `~/.agents/skills` (read by Codex, opencode,
pi and maki) and `~/.claude/skills` (Claude Code), replacing `npx skills`. Skills come from
repositories pinned as flake inputs (`mycroft-skills`, `gh-stack`, `superpowers`,
`mattpocock-skills`), or from the package they document (`hunk-review` from `pkgs.hunk`). Claude Code plugins, which add hooks to
skills, are linked into `~/.claude/skills` only, where Claude Code loads them as personal plugins
(worktrunk, from the source of the installed `wt`).

- Add a skill: add its name to the module's list, or a new flake input with `flake = false`
  for another repository, then switch.
- Update skills: `nix flake update mycroft-skills gh-stack superpowers mattpocock-skills` (or a
  full `nix flake update`), then switch.
- Try an unpushed skill change from a local checkout:

  ```sh
  home-manager switch --flake ".#<host>" --override-input mycroft-skills ~/dev/skills
  ```

The build fails if a listed skill has no `SKILL.md` (or a plugin no `.claude-plugin/plugin.json`),
for example after it was renamed upstream.

## Login shell

To let Home Manager control the login shell, add the generated Fish executable to `/etc/shells` and select it with `chsh`. Login shells should load these generated environment scripts automatically:

- `$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh`
- `/etc/profile.d/nix-daemon.fish` for a multi-user Nix installation

## Troubleshooting

### Reload Nix in Fish

For a single-user installation:

```fish
source "$HOME/.nix-profile/etc/profile.d/nix.fish"
```

For a multi-user installation:

```fish
source /etc/profile.d/nix-daemon.fish
```

### Install authorized SSH keys

Home Manager writes the configured public keys to `~/.ssh/authorized_keys.nix`. Install them with the required permissions:

```sh
cp ~/.ssh/authorized_keys.nix ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Review the generated file before replacing an existing `authorized_keys` file.

### Clean old generations

List and expire old Home Manager generations:

```sh
home-manager generations
home-manager expire-generations '-7 days'
```

Collect unused Nix store paths:

```sh
nix-store --gc
```

## References

- [Nix manual](https://nix.dev/manual/nix/latest/) — Nix commands and configuration
- [Home Manager manual](https://nix-community.github.io/home-manager/) — Home Manager options and usage
