{ pkgs, ... }:
{
  # Note: It is also possible to move this imports array in home.nix
  # It is also possible to wrap nixpkgs & programs inside a config = {}
  # The krewfile plugin was ripped from https://github.com/vladfr/setup/tree/main/nix
  imports = [
    ../nix/krewfile-hm.nix
  ];

  nixpkgs.overlays = [
    (self: super: {
      krewfile = super.callPackage ../nix/krewfile.nix { };
    })
  ];

  programs.krewfile = {
    enable = true;
    plugins = [
      "krew"
      "stern"
      "ctx"
      "ns"
    ];
  };
}
