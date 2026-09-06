{
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  ssh-keys = import ../../nix/ssh-keys.nix;

  lan-suffix = "lan.mkz.me";
in
{
  home = {
    file."./.ssh/authorized_keys.nix".text = lib.strings.concatStringsSep "\n" ssh-keys;
  };

  programs.ssh = {
    enable = true;

    extraConfig = ''
      HostKeyAlgorithms=+ssh-rsa
      # PreferredAuthentications publickey
    '';

    includes = [
      "${specialArgs.homeDirectory}/.ssh/work/config-*"
    ];

    enableDefaultConfig = false;

    settings = {
      "*" = {
        serverAliveInterval = 30;
        serverAliveCountMax = 2;
      };
      "maki" = {
        hostname = "maki.mkz.me";
        port = 22222;
      };
      "glitter" = {
        user = "mycroft";
        hostname = "glitter.${lan-suffix}";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      "everyday" = {
        user = "pi";
        hostname = "everyday.${lan-suffix}";
      };
      "raspberrypi" = {
        user = "mycroft";
        hostname = "10.0.0.129";
      };
      "saisei" = {
        user = "mycroft";
        hostname = "saisei.${lan-suffix}";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      "nas0" = {
        hostname = "nas0.${lan-suffix}";
        user = "mycroft";
      };
      "mugen-mirai" = {
        hostname = "mugen-mirai.${lan-suffix}";
        user = "mycroft";
      };
      "moonstone" = {
        hostname = "moonstone.${lan-suffix}";
        user = "mycroft";
        addressFamily = "inet";
      };
      "kali" = {
        hostname = "10.0.0.99";
        user = "kali";
        forwardX11 = true;
        forwardX11Trusted = true;
      };
    };
  };
}
