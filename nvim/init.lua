vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'maxmx03/fluoromachine.nvim'
Plug 'tpope/vim-sensible'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
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
Plug 'nvim-lua/plenary.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'NvChad/nvterm'
Plug 'tpope/vim-obsession'
Plug 'lewis6991/gitsigns.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-neorg/neorg'
Plug 'kylechui/nvim-surround'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'folke/neodev.nvim'
Plug 'stevearc/overseer.nvim'
Plug 'ggandor/leap.nvim'
Plug('catppuccin/nvim', { as = 'catppuccin' })

Plug 'majormajors/vim-pio'

vim.call('plug#end')

local set = vim.opt
local cmd = vim.cmd
local map = vim.keymap.set
local g = vim.g

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
cmd.colorscheme('catppuccin-mocha')

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
    'ansiblels',
    'bashls',
    'pylsp',
  }
}

require('leap').add_default_mappings()

require('overseer').setup()

require('nvim-surround').setup()

-- dapui for debugging
local dap, dapui = require('dap'), require('dapui')
dapui.setup {}
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
map('n', '<Leader>dt', ':DapToggleBreakpoint<CR>')
map('n', '<Leader>dx', ':DapTerminate<CR>')
map('n', '<Leader>do', ':DapStepOver<CR>')

require("neodev").setup {
  library = { plugins = { "nvim-dap-ui" }, types = true },
}

map('n', '<Space>e', vim.diagnostic.open_float)
map('n', '<Space>q', vim.diagnostic.setloclist)
map('n', '<Leader>dj', vim.diagnostic.goto_next)
map('n', '<Leader>dk', vim.diagnostic.goto_prev)


-- PIO
g.pio_serial_port = '/dev/ttyUSB0'
g.pio_serial_baud_rate = 115200
map('n', '<Leader>;', ':PIOUpload<CR>')
map('n', '<Leader>"', ':PIOUploadAndSerial<CR>')

-- nvim-tree
require("nvim-tree").setup {
  view = { side = 'left' }
}
map('n', '<leader>n', ':NvimTreeToggle<CR>', {})
cmd[[hi NvimTreeNormal guibg=NONE ctermbg=NONE]]
cmd[[hi NvimTreeWinSeparator guibg=NONE ctermbg=NONE]]

cmd[[hi CursorLineNR guifg=Yellow ctermfg=Yellow]]
cmd[[set cursorline]]
cmd[[set cursorlineopt=number]]

-- Airline
g.airline_powerline_fonts = true
g.airline_theme = 'murmur'

-- Telescope setup
local telescope = require('telescope.builtin')
map('n', '<leader>ff', telescope.find_files, {})
map('n', '<leader>fg', telescope.live_grep, {})
map('n', '<leader>fb', telescope.buffers, {})
map('n', '<leader>fh', telescope.help_tags, {})
map('n', '<leader>fi', telescope.highlights, {})
cmd[[hi TelescopeNormal guibg=NONE ctermbg=NONE]]
cmd[[hi TelescopeBorder guibg=NONE ctermbg=NONE]]

-- nvterm setup
require('nvterm').setup()
local terminal = require('nvterm.terminal')
map('n', '<leader>tf', function()
  terminal.toggle 'float'
end, {})
map('n', '<leader>th', function()
  terminal.toggle 'horizontal'
end, {})
map('n', '<leader>tv', function()
  terminal.toggle 'vertical'
end, {})

-- neorg
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    work = "~/notes/projects",
                    home = "~/notes/personal",
                }
            }
        }
    }
}

-- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
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
    { name = 'vsnip' },
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
    command = 'exe \'silent! ![[ -x "$(which buildifier)" ]] && buildifier %\' | exe \'silent! edit\''
})
vim.api.nvim_create_autocmd({'BufWritePost'}, {
    pattern = {'*.py'},
    group = autoformat_group,
    command = 'exe \'silent! ![[ -x "$(which yapf)" ]] && yapf -i --style=google %\' | exe \'silent! edit\''
})
vim.api.nvim_create_autocmd({'BufWritePost'}, {
    pattern = {'*.rs'},
    group = autoformat_group,
    command = 'exe \'silent! ![[ -x "$(which rustfmt)" ]] && rustfmt --edition=2021 --color=never %\' | exe \'silent! edit\''
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig.util')

local rt = require("rust-tools")
local mason_registry = require('mason-registry')
local codelldb = mason_registry.get_package('codelldb')
local extension_path = codelldb:get_install_path() .. '/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
local rt_dap = require("rust-tools.dap")
rt.setup({
  dap = {
    adapter = rt_dap.get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  tools = {
    hover_actions = {
      auto_focus = true,
    },
  },
})

lspconfig['ansiblels'].setup {
  capabilities = capabilities,
  settings = {
    filetypes = { 'yaml.ansible', 'yaml', 'yml' },
  },
}
lspconfig['asm_lsp'].setup {
  capabilities = capabilities,
  filetypes = { 'asm', 's', 'S' },
  root_dir = function(fname)
    return lspconfig_util.root_pattern('main.asm', 'main.S', 'Makefile')(fname)
  end,
}
lspconfig['bashls'].setup {
  capabilities = capabilities,
}
lspconfig['clangd'].setup {
  capabilities = capabilities,
}
lspconfig['html'].setup {
  capabilities = capabilities,
  filetypes = { "html", "htm", "css" },
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
lspconfig['pylsp'].setup {
  capabilities = capabilities
}
lspconfig['tsserver'].setup {
  capabilities = capabilities,
}
lspconfig['volar'].setup {
  capabilities = capabilities,
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}
lspconfig['zls'].setup{
  capabilities = capabilities
}


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    map('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    map('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
    map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    map('n', '<Leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local tabopts = { noremap = true, silent = true }
-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', tabopts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', tabopts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', tabopts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', tabopts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', tabopts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', tabopts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', tabopts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', tabopts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', tabopts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', tabopts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', tabopts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', tabopts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', tabopts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', tabopts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', tabopts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', tabopts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', tabopts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', tabopts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', tabopts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', tabopts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', tabopts)
