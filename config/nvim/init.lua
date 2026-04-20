--- Envs & Vars ---
FULL_FAT = os.getenv('DOTFILES_VIM_FULL_FAT')
gh = function(x) return 'https://github.com/' .. x end

--- General settings ---

-- my runtimes are in ~/dotfiles/vim so managed by git
-- mostly universal plugins in 'after'
vim.opt.runtimepath:append { '~/dotfiles/vim', '~/dotfiles/vim/after' }

vim.o.background = 'dark'
-- No intro
vim.o.shortmess = vim.o.shortmess .. 'I'
-- Line numbers with relative on line
vim.o.number = true
vim.o.relativenumber = true
-- Sign column by default so no jump when lsp active
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
-- Keep 8 lines below cursor
vim.o.scrolloff = 8
-- Split config right/below
vim.o.splitright = true
vim.o.splitbelow = true
-- Only mouse in normal mode
vim.o.mouse = 'n'
-- Show whitespaces and define chars
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·,extends:»,precedes:«,nbsp:␣'
-- Ignore files in wild search
vim.opt.wildignore = { '*.o', '*.a', '__pycache__', '*.class', '*.swp', '*.swo', '*.DS_Store' }
-- vim.o.wildmode = 'longest:full,full'
vim.o.completeopt = "fuzzy,menu,menuone,noselect,popup"
-- Add 'o' to completeopt for omni completion, which is used by LSP and treesitter.
vim.o.complete = vim.o.complete .. ',o'
vim.o.winborder = 'rounded'
-- custom git hook templete generates tags to .git/tags
vim.o.tags = ".git/tags,.tags,./tags;"
vim.o.path = vim.o.path .. '**'
vim.g.linuxsty_patterns = { "/linux/", "/kernel/", "/usr/src/", "/zephyr/" }

-- Folding indent levels 2 deep so class functions are folded
vim.o.foldnestmax = 2

-- Settings (commented out are redundant defaults from legacy vim)
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
-- Sequence combo fairly long because I don't like short/long leader combos anyway
vim.o.timeoutlen = 500
-- CursorHold timeout
vim.o.updatetime = 1000

-- British and find dictionary
if vim.fn.has('macunix') then
  vim.o.dictionary = '/usr/share/dict/words'
end
vim.o.spelllang = 'en_gb'

-- if ssh use osc52
if vim.env.SSH_TTY then
  -- Use osc52 as clipboard provider
  local function paste()
    return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
  end
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
  }
end

-- Resume last place in file
vim.cmd([[
  au! BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g`\"" | endif
]])

--- Plugins ---
require('plugins')

--- Keymaps ---
require('keymaps')
