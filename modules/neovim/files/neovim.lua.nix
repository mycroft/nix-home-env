{ ... }:
''
-- Built from neovim.lua.nix
--
-- Read those docs:
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smarttab = true
vim.api.nvim_command('filetype plugin indent on')

vim.opt.mouse = nil

vim.api.nvim_set_keymap('n', '<C-n>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':tabprevious<CR>', { noremap = true, silent = true })

vim.cmd.colorscheme "catppuccin"

-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
''