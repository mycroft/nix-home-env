{ pkgs
, lib
, config
, specialArgs
, ...
}:
let
  username = "mycroft";
  homeDirectory = "/home/${username}";
  locale = "en_US.UTF-8";

  rustToolChain = pkgs.rust-bin.stable.latest.minimal.override {
    extensions = [
      "clippy"
      "rust-analyzer"
      "rust-docs"
      "rust-src"
    ];
  };
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  imports = lib.concatMap import [ ./modules ];

  home = {
    stateVersion = "23.11";
    inherit username homeDirectory;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "less";
      EZA_COLORS = "da=36";
      FFSEND_HOST = "https://send.services.mkz.me/";
      KREW_ROOT = "${homeDirectory}/.krew";
      LANG = locale;
      LC_CTYPE = locale;
      LC_ALL = locale;
      PASSWORD_STORE_DIR = "${homeDirectory}/.sync/private/store";

      # Could be removed by services.ssh-agent.enable?
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";

      # X11 related configuration goes here as i3wm/gdm does not read .xprofile or .xinitrc.
      GTK_THEME = "Adwaita:dark";
      GTK2_RC_FILES = "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc";
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };

    packages =
      (with pkgs; [
        nix-eval-jobs
        nixpkgs-fmt
        unrar
        cowsay
        ponysay
        yq-go
        jq
        ffsend
        bottom
        btop
        pass
        mmtc

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
        skim

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
        pyright
        rust-bin.nightly."2024-05-08".rustfmt
        yamlfmt

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
        fluxcd
        kubeconform

        # security tools
        nmap
        step-cli
      ])
      ++ [ rustToolChain ];
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

  xdg.configFile = {
    "fontconfig/fonts.conf" = {
      source = ./files/fontconfig/fonts.conf;
    };

    "nix/nix.conf" = {
      text = ''
        # keep-derivations = true
        # keep-outputs = true
        experimental-features = nix-command flakes
      '';
    };
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
