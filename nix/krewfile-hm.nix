{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.krewfile;
in
{
  options.programs.krewfile = {
    enable =
      mkEnableOption "krewfile - Declarative krew plugin management";

    plugins = mkOption {
      default = [ "krew" ];
      example = [
        "explore"
        "modify-secret"
        "neat"
        "oidc-login"
        "pv-migrate"
        "stern"
        "krew"
      ];
      type = types.listOf types.str;
      description = ''
        List of plugins to install, one per line.
        Configuration is written to
        <filename>$XDG_CONFIG_HOME/.krewfile</filename>
      '';
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile.".krewfile".text = concatStringsSep "\n" (cfg.plugins);

    home.activation = {
      updateKrewfile = (lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        export PATH="$PATH:${pkgs.git}/bin/:/usr/bin/";
        ${pkgs.krew}/bin/krew update 2>/dev/null;
        ${pkgs.krewfile}/bin/krewfile \
            -command ${pkgs.krew}/bin/krew \
            -file ${config.xdg.configHome}/.krewfile
      '');
    };
  };
}
