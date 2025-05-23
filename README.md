# nix-home-env

## Initial installation

Prior installing nix, you might want to disable selinux if you're on Fedora like me.

Install nix with the recommended way:

```sh
$ sh <(curl -L https://nixos.org/nix/install) --daemon
```

Then, make sure to enable experimental features:

```sh
$ mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

You need the repository to be inside ~/.config/home-manager:

```sh
$ ln -s /path/to/nix-home-env ~/.config/home-manager
$ ls -l ~/.config/home-manager/home.nix
```

Then, build & switch the home:

```sh
$ nix run home-manager/master -- switch -b backup
```

On your first install, there might be a conflict for `~/.config/nix/nix.conf`. You can use the `-b backup` flag so the file is moved if in he way. Further reconcialiation will work.

## Login shell

If you want home-manager to control the login shell, you'll need to:

* add the shell in `/etc/shells`
* make sure the following scripts are sourced:
  * $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
  * /etc/profile.d/nix-daemon.fish

Both script should be loaded by login shell already. However, they're listed here in case something is going wrong. Check help section to reload nix from scratch if your shell is failing.

## Help!

### Load nix

Lost nix in your shell? Reload it!

Without daemon:

```sh
$ . $HOME/.nix-profile/etc/profile.d/nix.fish
```

With daemon:

```sh
$ . /etc/profile.d/nix-daemon.fish
```

### About ssh keys

`.ssh/authorized_keys` can not be managed by nix. Just do the following and that'll do it:

```sh
$ rm -f ~/.ssh/authorized_keys
$ cp ~/.ssh/authorized_keys.nix ~/.ssh/authorized_keys
$ chmod 600 ~/.ssh/authorized_keys
```

### pre-commit

You can use `nix flake check` to find out your files correctly formatted or not.

```sh
$ nix flake check
...
```

If the pre-commit is no longer there, just recreate it with a dev shell:

```sh
$ nix develop
```

### Doing clean up

Listing & cleaning last generations

```sh
home-manager generations
home-manager expire-generations '-7 days'
```

Cleaning the nix store

```sh
nix-store --gc
```

