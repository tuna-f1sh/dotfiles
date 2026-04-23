local base_packages = {
  { gh('ibhagwan/fzf-lua') },               -- Fzf popup
  { gh('patstockwell/vim-monokai-tasty') }, -- Theme
}

local full_packages = {
  gh('neovim/nvim-lspconfig'), -- LSP
  -- gh('saghen/blink.cmp'),

  -- Treesitter
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },

  -- Copilot
  gh('github/copilot.vim'), -- GitHub Copilot
  -- { gh('nvim-lua/plenary.nvim'), }, -- Required by codecompanion
  -- { gh('olimorris/codecompanion.nvim') },
  --
  -- -- Search
  gh('ibhagwan/fzf-lua'), -- Fzf popup
  --
  -- -- Git
  gh('tpope/vim-fugitive'), -- Git integration
  gh('tpope/vim-rhubarb'),  -- GBrowse
  gh('lewis6991/gitsigns.nvim'), -- Sidebar git status
  gh('folke/trouble.nvim'), -- Quickfix list
  gh('sindrets/diffview.nvim'), -- Diff view
  --
  -- -- Helpers
  gh('echasnovski/mini.surround'), -- Surround helpers, sa, sr, sd, s?
  gh('echasnovski/mini.hipatterns'), -- Highlight colours and TODO etc
  gh('ojroques/nvim-bufdel'),
  gh('HakonHarnes/img-clip.nvim'),
  --
  -- -- Python
  gh('jpalardy/vim-slime'),        -- Send code to tmux
  gh('hanschen/vim-ipython-cell'), -- Send code to IPython
  --
  -- -- typst
  gh('chomosuke/typst-preview.nvim'), -- Typst preview
  --
  -- -- UI
  gh('nvim-lualine/lualine.nvim'), -- Status line
  gh('MeanderingProgrammer/render-markdown.nvim'),
  -- -- { gh('iamcco/markdown-preview.nvim'), build = ':call mkdp#util#install()' },
  gh('nvim-tree/nvim-web-devicons'),
  gh('folke/zen-mode.nvim'),
  gh('junegunn/limelight.vim'),
  gh('dhruvasagar/vim-marp'),
  --
  -- -- Themes
  gh('patstockwell/vim-monokai-tasty'),
  gh('loctvl842/monokai-pro.nvim'),
  gh('folke/tokyonight.nvim'),
  gh('sainnhe/sonokai'),
  gh('rebelot/kanagawa.nvim'),
  gh('NLKNguyen/papercolor-theme'),
  gh('Lokaltog/vim-monotone'),
}

if FULL_FAT then
  vim.pack.add(full_packages)
else
  vim.pack.add(base_packages)
end

--- Plugin config ---

-- Slime
vim.g.slime_target = 'tmux'
vim.g.slime_python_ipython = 1
vim.g.slime_dont_ask_default = 1
vim.cmd([[
let g:slime_default_config = {
  \ 'socket_name': get(split($TMUX, ','), 0),
  \ 'target_pane': '{top-right}' }
]])

vim.g.vim_monokai_tasty_italic = 1
-- pcall to fall back to default if not installed
pcall(vim.cmd.colorscheme, 'vim-monokai-tasty')

-- status 2
if vim.fn.has('nvim-0.12') == 1 then
  require('vim._core.ui2').enable({})
end

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
  require('line')
  require('mini.surround').setup({})
  require('typst-preview').setup({
    dependencies_bin = { 'tinymist' }, -- installed locally
  })
  -- require('codecompanion').setup({})
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
  require('img-clip').setup({
    default = { 
      extension = "png", ---@type string | fun(): string
      file_name = "%Y-%m-%d-%H-%M-%S", ---@type string | fun(): string
      use_absolute_path = false, ---@type boolean | fun(): boolean
      relative_to_current_file = true, ---@type boolean | fun(): boolean
      prompt_for_file_name = true, ---@type boolean | fun(): boolean
      show_dir_path_in_prompt = true, ---@type boolean | fun(): boolean

      -- base64 options
      max_base64_size = 10, ---@type number | fun(): number
      embed_image_as_base64 = true, ---@type boolean | fun(): boolean
    }
  })
end
