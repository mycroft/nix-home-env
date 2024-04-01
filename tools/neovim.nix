{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
  };

  home.file."./.config/nvim/" = {
    source = ../files/neovim;
    recursive = true; 
  };
}
