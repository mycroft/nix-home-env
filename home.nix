{
  pkgs,
  lib,
  config,
  specialArgs,
  ...
}:
let
  username = "mycroft";
  homeDirectory = "/home/${username}";

  inherit specialArgs;
  inherit (specialArgs) versions;
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  imports = lib.concatMap import [
    ./modules
  ];

  home = {
    stateVersion = "23.11";
    inherit username homeDirectory;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "less";
      EXA_COLORS = "da=36";
      FFSEND_HOST = "https://send.services.mkz.me/";
      KAPILOGIN_CONFIG = "${homeDirectory}/.kapilogin.yaml";
      KREW_ROOT = "${homeDirectory}/.krew";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      PASSWORD_STORE_DIR = "${homeDirectory}/.sync/private/store";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";

      # X11 related configuration goes here as i3wm/gdm does not read .xprofile or .xinitrc.
      GTK_THEME = "Adwaita:dark";
      GTK2_RC_FILES = "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc";
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };

    packages = with pkgs; [
      nix-eval-jobs
      unrar
      cowsay
      ponysay
      yq-go
      jq
      ffsend
      bottom
      btop
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
      doggo # dig alternative; https://github.com/mr-karan/doggo

      glow
      zstd

      # coding
      bazelisk
      pre-commit
      tea
      drone-cli
      tig
      nixfmt-rfc-style
      cloc
      awscli2
      protoc-gen-go
      protoc-gen-go-grpc
      tldr
      gopls

      # container tools
      dive
      kubectl
      krew
      kubernetes-helm
      helmfile
      skopeo
      k9s
      kind
      natscli
      cmctl

      # security tools
      nmap
    ] ++ [
      versions.pkgs-fluxcd.fluxcd
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
      goPrivate = [ "git.mkz.me" ];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xdg.userDirs.download = "${config.home.homeDirectory}/.downloads";

  # Not sure this is even used on arch-linux
  xsession = {
    enable = true;
    profilePath = ".xprofile";
    profileExtra = ''
      export GTK_THEME=Adwaita:dark
      export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
      export QT_STYLE_OVERRIDE=adwaita-dark
    '';
  };
}
