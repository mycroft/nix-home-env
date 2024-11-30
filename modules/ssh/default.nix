{ pkgs, lib, specialArgs, ... }:
let
  ssh-keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMek8Cn3KNlEeHP2f9vZCbx/hzNc3xzJI9+2FM7Mbx5y mycroft@nee.mkz.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIASLd/ou8xDr81AKt37sMTad2jKNyRqF614kdJG829zp mycroft@glitter.mkz.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPskz9xwVWyXUThFepyY4FZ+E5yXm8S2/vWpjrMxYLh mycroft@saisei.mkz.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrxhZWTz6HibWjvQrGxTLhBrcwnCh6QquTlIgmaM4qr mycroft@mugen-mirai"
  ];

  lan-suffix = "lan.mkz.me";
in
{
  home = {
    file."./.ssh/authorized_keys.nix".text = lib.strings.concatStringsSep "\n" ssh-keys;
  };

  programs.ssh = {
    enable = true;

    serverAliveInterval = 30;
    serverAliveCountMax = 2;
    extraConfig = ''
      HostKeyAlgorithms=+ssh-rsa
      # PreferredAuthentications publickey
    '';

    includes = [
      "${specialArgs.homeDirectory}/.ssh/custocy/config"
    ];

    matchBlocks = {
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
    };
  };
}
