{ pkgs, versions, ... }:
{
  programs.neovim = {
    enable = true;

    withPython3 = true;

    extraLuaConfig = builtins.readFile ./files/init.lua;

    extraPackages = with pkgs; [
      nixd
      yamlfmt
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim # Pastel theme
      lightline-vim # Statusline/tabline
      vim-markdown # Markdown plugin
      vim-nix # Nix plugin
      # vim-go           # Go lang. plugin
      nvim-lspconfig # LSP
      nvim-cmp # LSP completion
      cmp-nvim-lsp # LSP completion
      vim-vsnip # Requirement for LSP completion
      cmp-vsnip # nvim-cmp source for vsnip
      vim-commentary # commenting
      telescope-nvim # Telescope: Find, filter, preview, pick
      formatter-nvim # Formatter
    ];
  };
}
