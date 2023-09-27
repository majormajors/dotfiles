
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'maxmx03/fluoromachine.nvim'
Plug 'tpope/vim-sensible'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'tpope/vim-fugitive'
Plug 'Fymyte/rasi.vim'
Plug 'udalov/kotlin-vim'
Plug 'hashivim/vim-vagrant'
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'

Plug 'majormajors/vim-pio'

vim.call('plug#end')

local set = vim.opt
local cmd = vim.cmd
local map = vim.keymap.set
local g = vim.g
local executable = vim.fn.executable

set.syntax = 'on'
set.background = 'dark'
set.number = true
set.numberwidth = 5
set.relativenumber = true
set.ignorecase = true
set.smartcase = true
set.hlsearch = false
set.wrap = true
set.breakindent = true
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.termguicolors = true
set.encoding = 'UTF-8'

-- Fix for mismatched devicons codepoints https://github.com/ryanoasis/vim-devicons/issues/452
cmd [[
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue']    = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tex']    = '󰙧'  " nf-md-stop_circle_outline
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cs']     = '󰌛'  " nf-md-language_csharp
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['r']      = '󰟔'  " nf-md-language_r
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rproj']  = '󰗆'  " nf-md-vector_rectangle
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sol']    = '󰡪'  " nf-md-ethereum
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pem']    = '󰌋'  " nf-md-key_variant
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['robots.txt'] = '󰋚'  " nf-md-history
]]

g.mapleader = ','

-- Map arrows to move between buffers
map('', '<Up>', ':wincmd k<CR>')
map('', '<Down>', ':wincmd j<CR>')
map('', '<Left>', ':wincmd h<CR>')
map('', '<Right>', ':wincmd l<CR>')
map('', '<Leader>=', ':wincmd =<CR>')

-- set colorscheme
local fm = require 'fluoromachine'
fm.setup {
  glow = false,
  transparent = true,
  theme = 'delta'
}
cmd.colorscheme('fluoromachine')

-- PIO
g.pio_serial_port = '/dev/ttyUSB0'
g.pio_serial_baud_rate = 115200
map('n', '<Leader>;', ':PIOUpload<CR>')
map('n', '<Leader>"', ':PIOUploadAndSerial<CR>')

-- Airline
g.airline_powerline_fonts = true
g.airline_theme = 'molokai'

-- NERDTree setup
g.NERDTreeShowHidden = true
g.NERDTreeWinPos = 'right'
map('n', '<leader>n', ':NERDTreeToggle<CR>')
map('n', '<leader>y', ':NERDTreeFind<CR>')

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
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
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- configure autoformatters 
local autoformat_group = vim.api.nvim_create_augroup('autoformat', { clear = true })
vim.api.nvim_create_autocmd({'BufWritePost'}, {
    pattern = {'BUILD', 'WORKSPACE', '*.bzl', '*.bazel', '*.blaze'},
    group = autoformat_group,
    command = 'exe \'silent! ![[ -x "$(which buildifier)" ]] && buildifier %\''
})
vim.api.nvim_create_autocmd({'BufWritePost'}, {
    pattern = {'*.py'},
    group = autoformat_group,
    command = 'exe \'silent! ![[ -x "$(which yapf)" ]] && yapf -i --style=google %\''
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
local lspconfig = require('lspconfig')
lspconfig['clangd'].setup {
  capabilities = capabilities,
}
lspconfig['bashls'].setup {
  capabilities = capabilities,
}
lspconfig['ansiblels'].setup {
  capabilities = capabilities,
}
lspconfig['lua_ls'].setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}
lspconfig['pylsp'].setup{}
lspconfig['volar'].setup{
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    map('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    map('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
    map('n', '<Leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

