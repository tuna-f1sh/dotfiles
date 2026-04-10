require('blink.cmp').setup(
  {
    -- Disable for some filetypes
    enabled = function()
      return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
    end,

    completion = {
      -- Show documentation when selecting a completion item
      documentation = { auto_show = true, auto_show_delay_ms = 500 },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = false },

      list = {
        -- Preselect will insert preview with c-e to undo
        selection = { preselect = true, auto_insert = true },
      },

      menu = {
        auto_show = function(ctx) return ctx.mode ~= 'cmdline' end
      },
    },

    sources = {
      -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- Disable cmdline completions
      -- cmdline = {},
    },

    cmdline = {
      -- optionally, separate cmdline keymaps
      keymap = {
        preset = 'default',
        ['<Tab>'] = {},
        ['<S-Tab>'] = {},
        ['<C-l>'] = { 'accept', 'fallback' },
      }
    },

    -- Tab gets in the way of autocomplete and copilot and I don't use snippets so disable
    keymap = {
      -- set to 'none' to disable the 'default' preset
      preset = 'default',
      ['<Tab>'] = {},
      ['<S-Tab>'] = {},
      ['<C-l>'] = { 'accept', 'fallback' }
    },

    -- Experimental signature help support
    signature = { enabled = true }
  }
)
