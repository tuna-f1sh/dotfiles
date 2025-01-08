-- Envs
local FULL_FAT = os.getenv('DOTFILES_VIM_FULL_FAT')

-- Paq installation
local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0

local function clone_paq()
  if not is_installed then
    vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
    return true
  end
end

local function bootstrap_paq(packages)
  local first_install = clone_paq()
  vim.cmd.packadd("paq-nvim")
  local paq = require("paq")

  -- Read and install packages
  paq(packages)

  if first_install then
    vim.notify("Installing plugins... If prompted, hit Enter to continue.")
    paq.install()
  end
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

  -- Git
  { 'tpope/vim-fugitive' }, -- Git integration
  { 'tpope/vim-rhubarb' }, -- GBrowse
  { 'lewis6991/gitsigns.nvim' },
  { 'folke/trouble.nvim' },

  -- Helpers
  { 'tpope/vim-unimpaired' }, -- Maps to help navigation with ]
  -- { 'echasnovski/mini.bracketed' },
  { 'echasnovski/mini.surround' }, -- Surround helpers, sa, sr, sd, s?
  -- { 'echasnovski/mini.icons' }, -- Icons for fzf
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

-- General settings

vim.opt.runtimepath:append { '~/dotfiles/vim/', '~/dotfiles/vim/after' }

-- Interface settings
vim.o.title = true
vim.o.background = 'dark'
vim.g.vim_monokai_tasty_italic = 1
vim.cmd.colorscheme('vim-monokai-tasty')
vim.o.shortmess = vim.o.shortmess .. 'I' -- no intro
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.splitright = true -- Split right of current window
vim.o.splitbelow = true -- Split below current window
vim.o.mouse = 'n' -- only normal mode
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·,extends:»,precedes:«,nbsp:␣'
vim.opt.wildignore = { '*.o', '*.a', '__pycache__', '*.class', '*.swp', '*.swo', '*.DS_Store' }
vim.o.wildmode = 'longest:full,full'
vim.o.completeopt = "menu,menuone,noselect"
-- custom git hook templete generates tags to .git/tags
vim.o.tags = ".git/tags,.tags,tags,./tags;"
vim.o.path = vim.o.path .. '**'
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
vim.o.timeoutlen = 600 -- fairly long because I don't like short/long leader combos anyway
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

-- Plugin config

if FULL_FAT and is_installed then
  require('fzf')
  require('treesitter')
  require('completion')
  require('gitsigns').setup({
    on_attach = function()
      local gitsigns = require('gitsigns');
      -- Navigation
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Next hunk' })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Previous hunk' })

      -- Actions
      vim.keymap.set('n', 'gdt', gitsigns.diffthis)
    end
  })
  require('trouble').setup()
  require('lualine').setup({})
  require('mini.surround').setup({})
  -- require('mini.icons').setup({})
elseif not is_installed then
  vim.notify("Reload to load plugin configurations.")
end
