{ pkgs
, pkgs-24-11
, pkgs-terragrunt-0-73-12
, home-manager
, lib
, config
, daggerPkgs
, specialArgs
, ...
}:
let
  username = specialArgs.username;
  homeDirectory = specialArgs.homeDirectory;
  locale = "en_US.UTF-8";
  editor = "nvim";

  rustToolChain = pkgs.rust-bin.stable.latest.minimal.override {
    extensions = [
      "clippy"
      "rust-analyzer"
      "rust-docs"
      "rust-src"
      "rustfmt"
    ];
  };

  commonVars = {
    GTK_THEME = "Adwaita:dark";
    GTK2_RC_FILES = "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  } // specialArgs.commonVars;
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  imports = lib.concatMap import [ ./modules ];

  home = {
    stateVersion = "23.11";
    inherit username homeDirectory;

    sessionVariables = {
      EDITOR = editor;
      VISUAL = editor;
      EZA_COLORS = "da=36";
      FFSEND_HOST = "https://send.services.mkz.me/";
      KREW_ROOT = "${homeDirectory}/.krew";
      LANG = locale;
      LC_CTYPE = locale;
      LC_ALL = locale;
      PASSWORD_STORE_DIR = "${homeDirectory}/.sync/private/store";
      DRONE_SERVER = "https://ci.mkz.me";

      # Could be removed by services.ssh-agent.enable?
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";

      # shut up, cdk8s
      JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION = "yes";
    } // commonVars;

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
        just

        bat
        eza
        fd
        ripgrep
        dust
        duf
        silver-searcher
        procs
        doggo # dig alternative; https://github.com/mr-karan/doggo
        skim
        nushell
        htop

        glow
        zstd
        rclone

        # coding
        bazelisk
        pre-commit
        tea
        drone-cli
        tig
        nixfmt-rfc-style
        cloc
        awscli2
        ssm-session-manager-plugin
        protoc-gen-go
        protoc-gen-go-grpc
        tlrc
        gopls
        pyright
        yamlfmt
        operator-sdk
        gotools
        golangci-lint
        zig
        zls
        exercism
        lazygit
        glances
        httpie
        curlie

        # container tools
        dive
        kubectl
        kubectx
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
        nova
        pluto
        tektoncd-cli
        kustomize

        deno

        # security tools
        nmap
        # step-cli
      ])
      ++ [ rustToolChain ]
      ++ [ daggerPkgs.dagger ]
      ++ [ pkgs-terragrunt-0-73-12.terraform ]
      ++ [ pkgs-terragrunt-0-73-12.terragrunt ]
      ++ [ daggerPkgs.dagger ];
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
      goPath = ".local/go";
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "pm@mkz.me";
          name = "Patrick MARIE";
        };
      };
    };

    lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        icons = {
          when = "never";
        };
        sorting = {
          dir-grouping = "first";
        };
        date = "+%y/%m/%d %H:%M";
        literal = true;
        size = "bytes";
      };
    };

  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
    extraConfig = ''
      auto-expand-secmem
    '';
  };

  # X11 related configuration goes here as i3wm/gdm does not read .xprofile or .xinitrc.
  # It is required to set them here so they are used in xdg-desktop-portal-gtk which is started by
  # systemd on login with nix session env. vars. are not loaded yet.
  systemd.user.sessionVariables = commonVars;

  xdg.configFile = {
    "fontconfig/fonts.conf" = {
      source = ./files/fontconfig/fonts.conf;
    };
    "ghostty/config" = {
      source = ./files/ghostty/config;
    };
    "hypr" = {
      source = ./files/hypr;
      recursive = true;
    };
  };

  xdg.userDirs.download = "${config.home.homeDirectory}/.downloads";

  # Not sure this is even used on arch-linux
  # TODO: To re-use commonVars
  xsession = {
    enable = true;
    profilePath = ".xprofile";
    profileExtra = ''
      # export GTK_THEME=Adwaita:dark
      # export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
      # export QT_STYLE_OVERRIDE=adwaita-dark
    '';
  };

  home.file.".local/bin/mount-obsidian.sh" = {
    source = ./files/scripts/mount-obsidian.sh;
    executable = true;
  };
}
