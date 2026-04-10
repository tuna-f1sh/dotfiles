--- LSP servers ---

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

-- Enable the servers above
for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

-- Vanilla LSP completion setup
if vim.fn.has('nvim-0.11') == 1 then
  -- Enable native LSP completion and configure it to trigger automatically
  vim.o.autocomplete = true
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
    callback = function(args)
      local client_id = args.data.client_id
      if not client_id then
        return
      end

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      vim.api.nvim_create_user_command('Format',
        'lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= "typescript-tools" end})',
        { nargs = 0 })
      -- load my keymaps
      require('keymaps').lsp_keymaps()

      -- in 0.11
      if client:supports_method("textDocument/completion") then
        -- Enable native LSP completion for this client + buffer
        vim.lsp.completion.enable(true, client_id, args.buf, {
          -- configure it to trigger automatically not C-x,C-o and select
          -- but conflicts with copilot so I disable
          -- autotrigger = true,
        })
      end

      -- Format on save for rust_analyzer
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
end
