{ enablePluginTelescope, ... }:
let
  telescopeConfig = if !enablePluginTelescope
    then ""
    else ''
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    '';
in
''
-- Built from neovim.lua.nix
--
-- Read those docs:
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.expandtab = true

vim.opt.list = true

local space_char = '_'
vim.opt.listchars:append {
  multispace = space_char,
  trail = space_char,
  lead = space_char,
  nbsp = space_char,
  tab = '>~'
}

vim.opt.autoindent = true
vim.opt.smarttab = true
vim.api.nvim_command('filetype plugin indent on')

vim.opt.mouse = nil

vim.api.nvim_set_keymap('n', '<C-n>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':tabprevious<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.go" },
  callback = function()
    vim.opt.expandtab = false
  end
})

-- format on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format {async = false, id = args.data.client_id }
      end,
    })
  end
})

vim.cmd.colorscheme "catppuccin"

${telescopeConfig}

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
      -- vim.snippet.expand(args.body) -- for neovin 0.10
    end
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {},
  },
}

lspconfig.gopls.setup {
  capabilities = capabilities,
  settings = {
  },
}

vim.api.nvim_set_keymap('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

''