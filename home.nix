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
      nixfmt-rfc-style

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

    file."./.ssh/authorized_keys".text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMek8Cn3KNlEeHP2f9vZCbx/hzNc3xzJI9+2FM7Mbx5y mycroft@nee.mkz.me
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIASLd/ou8xDr81AKt37sMTad2jKNyRqF614kdJG829zp mycroft@glitter.mkz.me
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwRnU+roKCocfzqUruFf5GUs5IeticEBp9nAojNcEaf mycroft@zenzen.s3ns.io
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
      goPrivate = [ "git.mkz.me" ];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    ssh = {
      enable = true;
      serverAliveInterval = 30;
      serverAliveCountMax = 2;
      extraConfig = ''
        HostKeyAlgorithms=+ssh-rsa
        # PreferredAuthentications publickey
      '';

      matchBlocks = {
        "maki" = {
          hostname = "maki.mkz.me";
          port = 2022;
        };
        "maki4" = {
          hostname = "maki.mkz.me";
          port = 2022;
          addressFamily = "inet";
        };
        "maki6" = {
          hostname = "maki.mkz.me";
          port = 2022;
          addressFamily = "inet6";
        };
        "maki-backup" = {
          hostname = "abused.minithins.net";
          port = 2022;
        };
        "everyday" = {
          user = "pi";
          hostname = "10.0.0.254";
        };
        "raspberrypi" = {
          user = "mycroft";
          hostname = "10.0.0.129";
        };
      };
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
