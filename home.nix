{ pkgs
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
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
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
      DRONE_SERVER = "https://ci.mkz.me";

      # Could be removed by services.ssh-agent.enable?
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";

      # shut up, cdk8s
      JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION = "yes";
    } // commonVars;

    packages =
      (with pkgs; [
        # nix related stuff
        nix-eval-jobs
        nixpkgs-fmt
        nixd
        nil
        nixfmt-rfc-style

        # modern unix tools
        bat
        bottom
        eza
        fd
        ripgrep
        dust
        duf
        silver-searcher
        procs
        doggo # dig alternative; https://github.com/mr-karan/doggo
        htop
        httpie
        curlie
        btop
        htop

        # code: git, gitea, etc.
        tea
        tig
        git-filter-repo
        lazygit

        # code: golang
        gopls
        gotools
        golangci-lint
        protoc-gen-go
        protoc-gen-go-grpc

        # code: zig
        zig
        zls

        # code: misc
        pre-commit

        # containers tools
        cosign
        dive
        hadolint
        notation
        skopeo

        # kubernetes related tools
        kubectl
        kubectx
        krew
        kubernetes-helm
        helmfile
        k9s
        kind
        fluxcd
        kustomize
        operator-sdk
        kubeconform

        # security tools
        nmap
        step-cli
        skim # fuzzy finder written in Rust

        # all other stuff
        unrar
        cowsay
        ponysay
        yq-go
        jq
        ffsend
        mmtc
        just
        nushell
        glow
        zstd
        rclone

        # coding
        bazelisk
        drone-cli
        cloc
        awscli2
        ssm-session-manager-plugin
        pyright
        yamlfmt
        exercism
        glances

        # container tools
        natscli
        cmctl
        nova
        pluto
        tektoncd-cli

        deno
      ])
      ++ [ rustToolChain ]
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

    granted = {
      enable = true;
      enableFishIntegration = true;
      package = pkgs.granted;
    };

    lsd = {
      enable = true;
      enableFishIntegration = true;
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

    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.sync/private/store";
      };
    };

    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      dataLocation = "${config.home.homeDirectory}/.sync/task";
    };

  };

  services.gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.pinentry-curses;
    };
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
    extraConfig = ''
      auto-expand-secmem
    '';
  };

  services.home-manager = {
    autoExpire = {
      enable = true;
      frequency = "weekly";
      store = {
        cleanup = true;
        options = "--delete-older-than 30d";
      };
      timestamp = "-15 days";
    };
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

  home.file.".granted/config.template" = {
    source = ./files/granted/config;
    onChange = ''
      rm -f ${config.home.homeDirectory}/.granted/config
      cp ${config.home.homeDirectory}/.granted/config.template ${config.home.homeDirectory}/.granted/config
      chmod u+w ${config.home.homeDirectory}/.granted/config
    '';
  };
}
