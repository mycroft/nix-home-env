{ pkgs, ... }:
{
  programs.fish = {
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
    };
  };
}