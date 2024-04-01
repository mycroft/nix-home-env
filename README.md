# nix-home-env

## Initial installation

Install nix with the recommended way:

```sh
$ sh <(curl -L https://nixos.org/nix/install)
```

Then, make sure to enable experimental features:

```sh
$ mkdir -p ~/.config && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

Then, build & switch the home:

```
$ nix run .
$ nix run . -- switch
```

