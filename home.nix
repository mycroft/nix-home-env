{ pkgs, lib, ... }:
let
  username = "mycroft";
  homeDirectory = "/home/${username}";
in {
  imports = [
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

      glow

      # coding
      bazelisk
      pre-commit
      tea
      drone-cli

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
  };

  programs = {
    home-manager.enable = true;
    alacritty = {
      # Disabled as 
      enable = false;
      settings = {
        colors = {
          bright = {
            black = "0x7f7f7f";
            blue = "0x5c5cff";
            cyan = "0x00ffff";
            green = "0x00ff00";
            magenta = "0xff00ff";
            red = "0xff0000";
            white = "0xffffff";
            yellow = "0xffff00";
          };
          normal = {
            black = "0x000000";
            blue = "0x0d73cc";
            cyan = "0x00cdcd";
            green = "0x00cd00";
            magenta = "0xcd00cd";
            red = "0xcd0000";
            white = "0xe5e5e5";
            yellow = "0xcdcd00";
          };
          primary = {
            background = "0x000000";
            foreground = "0xffffff";
          };
        };
        font = {
          size = 7;
          bold = {
            style = "Bold";
          };
          glyph_offset = {
            x = 0;
            y = 0;
          };
          italic = {
            style = "Italic";
          };
          normal = {
            family = "TerminalMono";
            style = "Regular";
          };
          offset = {
            x = 0;
            y = 0;
          };
        };
        selection = {
          save_to_clipboard = true;
          semantic_escape_chars = ",│`|:\"' ()[]{}<>\t^";
        };
        window = {
          decorations = "full";
          opacity = 0.9;
        };
      };
    };

    fish = {
      enable = true;

      loginShellInit = ''
        source /etc/profile.d/nix-daemon.fish
      '';

      interactiveShellInit = ''
        # Remove default greeting
        set fish_greeting

        # Change fzf behavior

        bind \ct transpose-chars
        bind \cg transpose-words

        # Was \ct, but conflict with bash' transpose-chars
        bind \cf fzf-file-widget
        bind \cr fzf-history-widget

        fish_add_path -p $KREW_ROOT/bin
      '';

      shellInit = ''
      function fish_greeting
        # Remove bobthefish default greetings
        # XXX: Duplicate with set fish_greeting ?
      end
      '';

      shellAbbrs = {
        l =  "eza --bytes --git --group --long -snew --group-directories-first";
        ls = "eza";
        ll = "eza --bytes --git --group --long -snew --group-directories-first";
        la = "eza --bytes --git --group --long -snew --group-directories-first -a";
        lt = "eza --bytes --git --group --long -snew --group-directories-first --tree --level=2";
        lta = "eza --bytes --git --group --long -snew --group-directories-first --tree --level=2 -a";
        vi = "nvim";
        vim = "nvim";
        cat = "bat -p";
        k = "kubectl";
        kns = "kubectl-ns";
        kctx = "kubectl-ctx";
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    git = {
      enable = true;
      userName = "Patrick Marie";
      userEmail = "pm@mkz.me";
      aliases = {
        br = "branch";
        co = "checkout";
        gra = "gra = log --pretty=format:'\"%Cgreen%h %Creset%cd %C(bold blue)[%cn] %Creset%s%C(yellow)%d%C(reset)\"' --graph --date=relative --decorate --all";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        st = "status";
        staged = "diff --cached";
      };
      extraConfig = {
        github.user = "mycroft";
        help.autocorrect = 1;
        init.defaultBranch = "main";
        color = {
          ui = true;
          pager = true;
        };
        url = {
          "ssh://git@git.mkz.me" = {
            insteadOf = "https://git.mkz.me";
          };
        };
      };
      signing = {
        key = "A438EE8E0F1C6BAA21EB8EB4BB519E5CD8E7BFA7";
        signByDefault = true;
      };
    };

    go = {
      enable = true;
      goPrivate = [
        "git.mkz.me"
      ];
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
