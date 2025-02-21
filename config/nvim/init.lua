-- Envs
local FULL_FAT = os.getenv('DOTFILES_VIM_FULL_FAT')

-- Paq installation
local paq_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
local paq_installed = vim.fn.empty(vim.fn.glob(paq_path)) == 0

local function clone_paq()
  if not paq_installed then
    vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", paq_path }
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

local base_packages = {
  { 'ibhagwan/fzf-lua' },               -- Fzf popup
  { 'patstockwell/vim-monokai-tasty' }, -- Theme
}

local full_packages = {
  { 'neovim/nvim-lspconfig' }, -- LSP
  { 'saghen/blink.cmp', version = '*', build = 'cargo build --locked --release --target-dir target' },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Copilot
  { 'github/copilot.vim' }, -- GitHub Copilot

  -- Search
  { 'ibhagwan/fzf-lua' }, -- Fzf popup

  -- Git
  { 'tpope/vim-fugitive' }, -- Git integration
  { 'tpope/vim-rhubarb' },  -- GBrowse
  { 'lewis6991/gitsigns.nvim' },
  { 'folke/trouble.nvim' },

  -- Helpers
  { 'tpope/vim-unimpaired' },      -- Maps to help navigation with ]
  { 'echasnovski/mini.surround' }, -- Surround helpers, sa, sr, sd, s?
  { 'echasnovski/mini.hipatterns' }, -- Highlight colours and TODO etc
  { 'mbbill/undotree' },
  { 'famiu/bufdelete.nvim' },

  -- Python
  { 'jpalardy/vim-slime' },        -- Send code to tmux
  { 'hanschen/vim-ipython-cell' }, -- Send code to IPython

  -- UI
  { 'nvim-lualine/lualine.nvim' }, -- Status line
  { 'MeanderingProgrammer/render-markdown.nvim' },
  { 'iamcco/markdown-preview.nvim', build = ':call mkdp#util#install()' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'folke/zen-mode.nvim' },
  -- { 'junegunn/goyo.vim' },
  { 'junegunn/limelight.vim', opt=true },
  { 'dhruvasagar/vim-marp', opt=true }, -- Deckset style slides

  -- Themes
  { 'patstockwell/vim-monokai-tasty' },
  { 'loctvl842/monokai-pro.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'sainnhe/sonokai' },
  { 'rebelot/kanagawa.nvim' },
  { 'NLKNguyen/papercolor-theme' },
  { 'reedes/vim-colors-pencil' },
  { 'Lokaltog/vim-monotone' },
}

if FULL_FAT then
  bootstrap_paq(full_packages)
else
  bootstrap_paq(base_packages)
end

-- General settings

-- my runtimes are in ~/dotfiles/vim so managed by git
vim.opt.runtimepath:append { '~/dotfiles/vim', '~/dotfiles/vim/after' }

-- Interface settings
vim.o.title = true
vim.o.background = 'dark'
vim.o.shortmess = vim.o.shortmess .. 'I' -- no intro
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.splitright = true -- Split right of current window
vim.o.splitbelow = true -- Split below current window
vim.o.mouse = 'n'       -- only normal mode
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·,extends:»,precedes:«,nbsp:␣'
vim.opt.wildignore = { '*.o', '*.a', '__pycache__', '*.class', '*.swp', '*.swo', '*.DS_Store' }
vim.o.wildmode = 'longest:full,full'
vim.o.completeopt = "menu,menuone,noselect"
-- custom git hook templete generates tags to .git/tags
vim.o.tags = ".git/tags,.tags,./tags;"
vim.o.path = vim.o.path .. '**'
vim.g.linuxsty_patterns = { "/linux/", "/kernel/", "/usr/src/", "/tcu-3/", "/zephyr/" }

-- Folding indent levels 2 deep so class functions are folded
vim.o.foldnestmax = 2

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

-- Resume last place in file
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

vim.g.vim_monokai_tasty_italic = 1
-- pcall to fall back to default if not installed
pcall(vim.cmd.colorscheme, 'vim-monokai-tasty')

if paq_installed then
  require('fzf')
  if FULL_FAT then
    require('treesitter')
    require('completion')
    require('gitsigns').setup({
      on_attach = function()
        require('keymaps').gitsigns_keymaps()
      end
    })
    require('trouble').setup()
    require('lualine').setup({})
    require('mini.surround').setup({})
    local hipatterns = require('mini.hipatterns');
    hipatterns.setup({
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
        todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
        note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
  end
else
  vim.notify("Reload to load plugin configurations.")
end
