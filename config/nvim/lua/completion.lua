-- Mason for LSP servers
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "bashls",
    "pyright",
    "clangd",
  },
  automatic_installation = true,
}

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'emoji' },
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
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
    "lua_ls",
    "rust_analyzer",
    "bashls",
    "pyright",
    "clangd",
    "ts_ls",
    "jsonls",
}

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Create a keymap for vim.lsp.buf.implementation
    -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true, silent = true})
    -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'grn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})
    -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
    -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'grr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
    -- vim.api.nvim_buf_set_keymap(args.buf, 'n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(args.buf, 'i', '<C-S>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
    -- in 0.11
    -- if client:supports_method('textDocument/completion') then
    --   -- Enable auto-completion
    --   -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    -- end
    if client:supports_method('textDocument/formatting') then
      -- Format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({bufnr = args.buf, id = client.id, async = true})
        end,
      })
    end
  end,
})
