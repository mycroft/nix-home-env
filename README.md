# nix-home-env

## Initial installation

Prior installing nix, you might want to disable selinux if you're on Fedora like me.

Install nix with the recommended way:

```sh
$ sh <(curl -L https://nixos.org/nix/install) --deamon
```

Then, make sure to enable experimental features:

```sh
$ mkdir -p ~/.config && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

You need the repository to be inside ~/.config/home-manager:

```sh
$ ln -s /path/to/nix-home-env ~/.config/home-manager
$ ls -l ~/.config/home-manager/home.nix
```

Then, build & switch the home:

```
$ nix run .
$ nix run . -- switch
```

## Login shell

If you want home-manager to control the login shell, you'll need to:

* add the shell in `/etc/shells`
* make sure the following scripts are sourced:
  * $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
  * /etc/profile.d/nix-daemon.fish

Both script should be loaded by login shell.

