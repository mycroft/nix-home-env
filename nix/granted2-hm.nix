{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.programs.granted2;
  package = pkgs.granted2;
in
{
  meta.maintainers = [ hm.maintainers.wcarlsen ];

  options.programs.granted2 = {
    enable = mkEnableOption "granted2";

    enableZshIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Zsh integration.
      '';
    };

    enableFishIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Fish integration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
      function assume() {
        export GRANTED_ALIAS_CONFIGURED="true"
        source ${package}/bin/assume "$@"
        unset GRANTED_ALIAS_CONFIGURED
      }
    '';

    programs.fish.shellInit = mkIf cfg.enableFishIntegration ''
      function assume
        set -x GRANTED_ALIAS_CONFIGURED true
        alias assume='source ${package}/share/assume.fish'
        set -e GRANTED_ALIAS_CONFIGURED
      end
      
    '';
  };
}
