{ pkgs, lib, ... }:
let
  ssh-keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMek8Cn3KNlEeHP2f9vZCbx/hzNc3xzJI9+2FM7Mbx5y mycroft@nee.mkz.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIASLd/ou8xDr81AKt37sMTad2jKNyRqF614kdJG829zp mycroft@glitter.mkz.me"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPskz9xwVWyXUThFepyY4FZ+E5yXm8S2/vWpjrMxYLh mycroft@saisei.mkz.me"
  ];
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

    matchBlocks = {
      "maki" = {
        hostname = "maki.mkz.me";
        port = 2022;
      };
      "maki4" = {
        hostname = "maki.mkz.me";
        port = 2022;
        addressFamily = "inet";
      };
      "maki6" = {
        hostname = "maki.mkz.me";
        port = 2022;
        addressFamily = "inet6";
      };
      "maki-backup" = {
        hostname = "abused.minithins.net";
        port = 2022;
      };
      "everyday" = {
        user = "pi";
        hostname = "10.0.0.254";
      };
      "raspberrypi" = {
        user = "mycroft";
        hostname = "10.0.0.129";
      };
      "saisei" = {
        user = "mycroft";
        hostname = "10.0.0.12";
      };
    };
  };
}
