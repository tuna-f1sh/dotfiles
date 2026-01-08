-- Set up vim.lsp.config.
local capabilities = require('blink.cmp').get_lsp_capabilities()
local servers = {
  "lua_ls",        -- lua_language_server
  "rust_analyzer", -- rustup component add rust-analyzer
  "bashls",        -- bash_language_server
  "ty",            -- python type checker `uv tool install ty@latest`
  "ruff",          -- python linting and formatting
  "clangd",
  "ts_ls",
  "jsonls",
  "dartls",        -- flutter env
  "tinymist",      -- typst
}

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

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

-- Set up diagnostics for specifics
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- https://www.reddit.com/r/neovim/comments/12qbcua/multiple_different_client_offset_encodings/
vim.lsp.config('clangd', {
  -- arduino works if arduino-cli compile .. --build-path build
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto', 'arduino' },
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      checkOnSave = true,
    },
  },
})

-- Vanilla LSP
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.api.nvim_create_user_command('Format',
      'lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= "typescript-tools" end})',
      { nargs = 0 })
    -- load my keymaps
    require('keymaps').lsp_keymaps()
    -- in 0.11
    -- if client:supports_method('textDocument/completion') then
    --   -- Enable auto-completion
    --   -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    -- end
    if client:supports_method('textDocument/formatting') and client.name == "rust_analyzer" then
      -- Format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, async = true })
        end,
      })
    end
  end,
})
