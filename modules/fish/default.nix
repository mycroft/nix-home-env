{ pkgs, specialArgs, ... }:
let
  extraAliases = {};
in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
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
      end

      set -g theme_display_date no
      set -g theme_display_cmd_duration no
      set -g theme_display_k8s_context yes
      set -g theme_display_k8s_namespace no
    '';

    shellAbbrs = {
      btm = "btm --color nord";
      l = "eza --bytes --git --group --long -snew --group-directories-first";
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
      cd = "z";
      dc = "z";
    } // extraAliases;
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = ''
    for plugin in ${pkgs.fishPlugins.bobthefish} ${pkgs.fishPlugins.fzf}
      for f in $plugin/share/fish/vendor_functions.d/*.fish
        source $f
      end
    end
  '';

  # I really don't understand what the hell is with nix & fish. Loading everything seems to make it ok.
  xdg.configFile."fish/conf.d/nix.fish".source = "${pkgs.nix}/etc/profile.d/nix.fish";
  xdg.configFile."fish/conf.d/nix-daemon.fish".source = "${pkgs.nix}/etc/profile.d/nix-daemon.fish";
  xdg.configFile."fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
}