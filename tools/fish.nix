{ pkgs, specialArgs, ... }:
let
  extraAliases = if specialArgs.enableJobFeatures
    then {
      prod = "set -x KUBECONFIG $HOME/.kube/parts/config.pe-prod";
      quar = "set -x KUBECONFIG $HOME/.kube/parts/config.pe-quarantine";
      insp = "set -x KUBECONFIG $HOME/.kube/parts/config.inspectability";
      siem = "set -x KUBECONFIG $HOME/.kube/parts/config.siem";

      prod-ng = "set -x KUBECONFIG $HOME/.kube/parts/config.ela.dev.pe-prod";
      quar-ng = "set -x KUBECONFIG $HOME/.kube/parts/config.ela.dev.pe-quarantine";
      insp-ng = "set -x KUBECONFIG $HOME/.kube/parts/config.ela.dev.inspectability";
      siem-ng = "set -x KUBECONFIG $HOME/.kube/parts/config.ela.dev.siem";
    }
    else {};
in
{
  programs.fish = {
    enable = true;

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
      cd = "z";
      dc = "z";
    } // extraAliases;
  };
}
