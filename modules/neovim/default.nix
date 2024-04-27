{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    withPython3 = true;

    # extraConfig =
    # ''
    #     syntax on
    #     " set relativenumber
    #     " set autoindent
    #     " set tabstop=4
    #     " set ignorecase
    # '';

    extraLuaConfig = (import ./files/neovim.lua.nix) {};

    plugins = with pkgs; [
      vimPlugins.catppuccin-nvim  # Pastel theme
      vimPlugins.lightline-vim    # Statusline/tabline
      #vimPlugins.vim-markdown     # Markdown plugin
      #vimPlugins.vim-nix          # Nix plugin
      vimPlugins.vim-go           # Go lang. plugin
      #vimPlugins.telescope-nvim   # Telescope: Find, filter, preview, pick
    ];
  };
}
