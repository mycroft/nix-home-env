{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      fishPlugins.fzf
      fishPlugins.bobthefish
    ];
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Change fzf behavior
      bind \ct transpose-chars
      bind \cg transpose-words

      # Was \ct, but conflict with bash' transpose-chars
      bind \cf fzf-file-widget
      bind \cr fzf-history-widget

      fish_add_path -p $HOME/.cargo/bin
      fish_add_path -p $HOME/.local/bin
      fish_add_path -p $KREW_ROOT/bin
      fish_add_path -p /opt/ollama/bin

      alias assume='source ${pkgs.granted2}/share/assume.fish'

      function t
        pushd (mktemp -d /tmp/$argv[1].XXXX)
      end
    '';

    shellInit = ''
      function fish_greeting
        # Remove bobthefish default greetings
      end

      set -g theme_display_date no
      set -g theme_display_cmd_duration no
      set -g theme_display_k8s_context no
      set -g theme_display_k8s_namespace no
    '';

    # For some reason, the first instance of fish does not have the correct autocompletions for asoai or just.
    # Starting a shell in the shell would fix it. I found out the next path would not be part of the fish_complete_path
    # of the first instance, and if the path not set at the list beginning, just would not have its --nofiles auto completion
    # in order to not list files. So for now on, let's keep this while I take a deeper look at how nix is doing all those.
    #
    # Note this PR seems to fix the issue: https://github.com/nix-community/home-manager/pull/5199
    shellInitLast = ''
      set fish_complete_path ${config.home.path}/share/fish/vendor_completions.d $fish_complete_path
    '';

    shellAbbrs = {
      btm = "btm --theme nord";
      l = "lsd -ltr";
      ls = "lsd";
      la = "lsd -ltra";
      ll = "lsd -ltr";

      el = "eza --bytes --git --group --long -snew --group-directories-first";
      els = "eza";
      ell = "eza --bytes --git --group --long -snew --group-directories-first";
      ela = "eza --bytes --git --group --long -snew --group-directories-first -a";
      elt = "eza --bytes --git --group --long -snew --group-directories-first --tree --level=2";
      elta = "eza --bytes --git --group --long -snew --group-directories-first --tree --level=2 -a";

      gs = "git status";
      ga = "git add";
      gc = "git commit";

      vi = "nvim";
      vim = "nvim";
      cat = "bat -p";
      k = "kubectl";
      kns = "kubens";
      kctx = "kubectx";
      cd = "z";
      dc = "z";
      init-drone-token = "set -x DRONE_TOKEN (pass Mkz/drone-ci-token)";
    };
  };

  xdg.configFile = {
    "fish/conf.d/plugin-bobthefish.fish".text = ''
      for plugin in ${pkgs.fishPlugins.bobthefish} ${pkgs.fishPlugins.fzf}
        for f in $plugin/share/fish/vendor_functions.d/*.fish
          source $f
        end
      end
    '';

    # I really don't understand what the hell is with nix & fish.
    # Loading everything seems to make it ok.
    "fish/conf.d/nix.fish".source = "${pkgs.nix}/etc/profile.d/nix.fish";
    "fish/conf.d/nix-daemon.fish".source = "${pkgs.nix}/etc/profile.d/nix-daemon.fish";
    "fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
  };
}
