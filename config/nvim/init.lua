-- Envs
local FULL_FAT = os.getenv('DOTFILES_VIM_FULL_FAT')

-- Paq installation
local function clone_paq()
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
    return true
  end
end

local function bootstrap_paq(packages)
  local first_install = clone_paq()
  vim.cmd.packadd("paq-nvim")
  local paq = require("paq")
  if first_install then
    vim.notify("Installing plugins... If prompted, hit Enter to continue.")
  end

  -- Read and install packages
  paq(packages)
  paq.install()
end

bootstrap_paq {
  { 'neovim/nvim-lspconfig' }, -- LSP
  { 'saghen/blink.cmp', version = "*", build = "cargo build --locked --release --target-dir target" },

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
  { 'echasnovski/mini.bracketed' },
  { 'echasnovski/mini.surround' }, -- Surround helpers, sa, sr, sd, s?
  { 'echasnovski/mini.icons' }, -- Icons for fzf
  { 'mbbill/undotree' },
  { 'famiu/bufdelete.nvim' },

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
}

-- Set runtime path - TODO remove once linked
vim.opt.runtimepath:append { '~/dotfiles/config/nvim', '~/dotfiles/vim/', '~/dotfiles/vim/after' }

if FULL_FAT then
  require('treesitter')
  if pcall(require, 'blink.cmp') then
    require('completion')
  end
  if pcall(require, 'lualine') then
    require('lualine').setup({})
  end
  if pcall(require, 'mini.surround') then
    require('mini.surround').setup({})
  end
  if pcall(require, 'mini.icons') then
    require('mini.icons').setup({})
  end
end
if pcall(require, 'mini.bracketed') then
  require('mini.bracketed').setup({})
end

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
vim.o.splitright = true -- Split right of current window
vim.o.splitbelow = true -- Split below current window
-- vim.o.mouse = 'r'
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·,extends:»,precedes:«,nbsp:␣'
vim.opt.wildignore = { '*.o', '*.a', '__pycache__', '*.class', '*.swp', '*.swo', '*.DS_Store' }
vim.o.wildmode = 'longest:full,full'
vim.o.completeopt = "menu,menuone,noselect"
-- vim.o.tags = ".git/tags,.tags,tags,./tags"
vim.g.linuxsty_patterns = {"/linux/", "/kernel/", "/usr/src/", "/tcu-3/", "/zephyr/"}


-- General settings (commented out are redundant defaults from legacy vim)
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- vim.o.hidden = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.undofile = true
vim.o.timeoutlen = 300
vim.o.updatetime = 200

if vim.fn.has('macunix') then
  vim.o.dictionary = '/usr/share/dict/words'
end
vim.o.spelllang = 'en_gb'

-- Keymaps

require('keymaps')

-- Resume last place
vim.cmd([[
au! BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
\| exe "normal! g`\"" | endif
]])

-- Slime

vim.g.slime_target = 'tmux'
vim.g.slime_python_ipython = 1
vim.g.slime_dont_ask_default = 1
vim.cmd([[
let g:slime_default_config = {
  \ 'socket_name': get(split($TMUX, ','), 0),
  \ 'target_pane': '{top-right}' }
]])
