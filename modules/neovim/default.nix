{ pkgs, ... }:
let
  enablePluginTelescope = true;
in
{
  programs.neovim = {
    enable = true;

    withPython3 = true;

    extraLuaConfig = (import ./files/neovim.lua.nix) {
      inherit enablePluginTelescope;
    };

    plugins = with pkgs; [
      vimPlugins.catppuccin-nvim  # Pastel theme
      vimPlugins.lightline-vim    # Statusline/tabline
      vimPlugins.vim-markdown     # Markdown plugin
      vimPlugins.vim-nix          # Nix plugin
      # vimPlugins.vim-go           # Go lang. plugin
      vimPlugins.nvim-lspconfig   # LSP
      vimPlugins.nvim-cmp         # LSP completion
      vimPlugins.cmp-nvim-lsp     # LSP completion
      vimPlugins.vim-vsnip        # Requirement for LSP completion
      vimPlugins.cmp-vsnip        # nvim-cmp source for vsnip
    ] ++ (lib.optionals (enablePluginTelescope) [
      vimPlugins.telescope-nvim   # Telescope: Find, filter, preview, pick
    ]);
  };
}
