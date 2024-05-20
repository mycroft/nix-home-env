{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.programs.asoai;
in
{
  options.programs.asoai = {
    enable = mkEnableOption "asoai - other stupid Open AI client";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.asoai ];
  };
}
