-- Set up lspconfig.
local capabilities = require('blink.cmp').get_lsp_capabilities()
local servers = {
    "lua_ls", -- lua_language_server
    "rust_analyzer", -- rustup component add rust-analyzer
    "bashls", -- bash_language_server
    "pyright", -- pyright
    "clangd",
    "ts_ls",
    "jsonls",
    "dartls", -- flutter env
}

local lspconfig = require('lspconfig')
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
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


  -- Tab gets in the way of autocomplete and copilot and I don't use snippets so disable
  keymap = {
    -- set to 'none' to disable the 'default' preset
    preset = 'default',
    ['<Tab>'] = {},
    ['<S-Tab>'] = {},
    ['<C-l>'] = { 'accept', 'fallback' },

    -- optionally, separate cmdline keymaps
    cmdline = {
      preset = 'default',
      ['<Tab>'] = {},
      ['<S-Tab>'] = {},
      ['<C-l>'] = { 'accept', 'fallback' },
    }
  },

  -- Experimental signature help support
  signature = { enabled = true }
}
)

-- Set up diagnostics for specifics
lspconfig.lua_ls.setup {
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
}

-- Vanilla LSP
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     -- Create a keymap for vim.lsp.buf.implementation
--     -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true, silent = true})
--     -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'grn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})
--     -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
--     -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'grr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
--     -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true, silent = true})
--     -- vim.api.nvim_buf_set_keymap(args.buf, 'i', '<C-S>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
--     -- in 0.11
--     -- if client:supports_method('textDocument/completion') then
--     --   -- Enable auto-completion
--     --   -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
--     -- end
--     if client:supports_method('textDocument/formatting') then
--       -- Format the current buffer on save
--       vim.api.nvim_create_autocmd('BufWritePre', {
--         buffer = args.buf,
--         callback = function()
--           vim.lsp.buf.format({bufnr = args.buf, id = client.id, async = true})
--         end,
--       })
--     end
--   end,
-- })
