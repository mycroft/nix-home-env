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


-- lazy
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "itchyny/lightline.vim" }
})

-- https://github.com/catppuccin/nvim
-- https://github.com/itchyny/lightline.vim

vim.cmd.colorscheme "catppuccin"
