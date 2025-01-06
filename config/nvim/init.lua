-- Envs
local FULL_FAT = os.getenv('DOTFILES_VIM_FULL_FAT')

-- Paq installation
local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path }
end

require 'paq' {
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' }, -- LSP
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-emoji' },
  { 'hrsh7th/nvim-cmp'},

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Copilot
  { 'github/copilot.vim' }, -- GitHub Copilot

  -- Search
  { 'ibhagwan/fzf-lua' }, -- Fzf popup

  -- Helpers
  { 'tpope/vim-fugitive' }, -- Git integration
  { 'tpope/vim-rhubarb' }, -- GBrowse
  { 'tpope/vim-unimpaired' }, -- Maps to help navigation with ]
  -- { 'echasnovski/mini.bracketed' },
  { 'echasnovski/mini.surround' }, -- Surround helpers, sa, sr, sd, s?
  { 'echasnovski/mini.icons' }, -- Icons for fzf

  -- Python
  { 'jpalardy/vim-slime' }, -- Send code to tmux
  { 'hanschen/vim-ipython-cell' }, -- Send code to IPython

  -- Themes
  { 'patstockwell/vim-monokai-tasty' },
  { 'loctvl842/monokai-pro.nvim' },
  { 'sainnhe/sonokai' },
  { 'rebelot/kanagawa.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'nvim-lualine/lualine.nvim' }, -- Status line
  { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install' },
}

-- Set runtime path
vim.opt.runtimepath:append { '~/dotfiles/config/nvim', '~/dotfiles/vim/', '~/dotfiles/vim/after' }

require('treesitter')
require('completion')

require('lualine').setup()
-- require('mini.bracketed').setup()
require('mini.surround').setup()
require('mini.icons').setup()

-- Interface settings
vim.o.title = true
vim.o.background = 'dark'
vim.g.vim_monokai_tasty_italic = 1
vim.cmd('colorscheme vim-monokai-tasty')
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.splitright = true
vim.o.splitbelow = true
-- vim.o.mouse = 'r'
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·,extends:»,precedes:«,nbsp:␣'
vim.opt.wildignore = { '*.o', '*.a', '__pycache__', '*.class', '*.swp', '*.swo', '*.DS_Store' }
-- vim.o.tags = ".git/tags,.tags,tags,./tags"

-- General settings (commented out are redundant defaults from legacy vim)
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- vim.o.hidden = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.undofile = true
vim.o.timeoutlen = 500
vim.o.updatetime = 250

if vim.fn.has('macunix') then
  vim.o.dictionary = '/usr/share/dict/words'
end
vim.o.spelllang = 'en_gb'

-- Keymaps
vim.g.mapleader = ' '
vim.keymap.set('n', '<C-k>', 'gk')
vim.keymap.set('n', '<C-j>', 'gj')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>ww', '<cmd>w<CR>')
-- also grn
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>FzfLua files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>FzfLua git_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>FzfLua oldfiles<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>f;', '<cmd>FzfLua buffers<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fo', '<cmd>FzfLua lsp_document_symbols<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fO', '<cmd>FzfLua lsp_workspace_symbols<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fs', '<cmd>FzfLua grep<cr>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>fs', '<cmd>FzfLua grep_visual<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fc', '<cmd>FzfLua<cr>', { noremap = true })

-- LSP - could be done on attach in completion.lua but relies on FzfLua so here for now
vim.api.nvim_set_keymap('n', 'grn', '<cmd>FzfLua lsp_rename<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gO', '<cmd>FzfLua lsp_document_symbols<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gra', '<cmd>FzfLua lsp_code_actions<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'grr', '<cmd>FzfLua lsp_references<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gri', '<cmd>FzfLua lsp_implementations<cr>', { noremap = true })
