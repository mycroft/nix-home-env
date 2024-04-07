{ pkgs, lib, ... }:
let
  username = "mycroft";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./tools/alacritty.nix
    ./tools/fish.nix
    ./tools/git.nix
    ./tools/krewfile.nix
    ./tools/neovim.nix
    ./tools/tmux.nix
  ];

  home = {
    stateVersion = "23.11";
    inherit username homeDirectory;

    sessionVariables = {
      EDITOR = "nvim";
      EXA_COLORS = "da=36";
      FFSEND_HOST = "https://send.services.mkz.me/";
      GOPRIVATE = "git.mkz.me"; # to be replaced by programs.go.goPrivate
      KREW_ROOT = "${homeDirectory}/.krew";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      PASSWORD_STORE_DIR = "$HOME/.sync/private/store";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
      XDG_DOWNLOAD_DIR = "$HOME/.downloads";
    };

    packages = with pkgs; [
      cowsay
      ponysay
      yq-go
      jq
      ffsend
      bottom
      pass

      # shell
      fish
      fishPlugins.fzf
      fishPlugins.bobthefish

      bat
      eza
      fd
      ripgrep
      dust
      lsd
      duf
      silver-searcher
      procs
      doggo

      glow

      # coding
      bazelisk
      pre-commit
      tea
      drone-cli
      tig

      # container tools
      dive
      kubectl
      krew
      helm
      helmfile
      fluxcd
      skopeo
      k9s
      kind

      # security tools
      nmap
    ];

    file."./.config/fontconfig/fonts.conf" = {
      source = ./files/fontconfig/fonts.conf;
    };

    file.".config/nix/nix.conf".text = ''
      # keep-derivations = true
      # keep-outputs = true
      experimental-features = nix-command flakes
    '';
  };

  programs = {
    home-manager.enable = true;

    starship = {
      enable = false;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        gcloud = {
          disabled = true;
        };
        kubernetes = {
          disabled = false;
        };
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    go = {
      enable = true;
      goPrivate = [
        "git.mkz.me"
      ];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = ''
    for plugin in ${pkgs.fishPlugins.bobthefish} ${pkgs.fishPlugins.fzf}
      for f in $plugin/share/fish/vendor_functions.d/*.fish
        source $f
      end
    end
  '';
}
