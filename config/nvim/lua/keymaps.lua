-- function to set keymap
local function map(mode, key, action, opts)
  vim.keymap.set(mode, key, action, opts)
end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
map('n', '<leader>qq', '<cmd>qa!<cr>', { desc = 'Quit all' })
map('n', '<leader>ww', '<cmd>w<cr>', { desc = 'Write' })
map('n', '<C-k>', 'gk', { desc = 'Move up' })
map('n', '<C-j>', 'gj', { desc = 'Move down' })
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search' })
-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
map('n', '<leader>tt', '<cmd>UndotreeToggle<cr>', { desc = 'Toggle undotree' })

-- Move Lines
map("n", "]e", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "[e", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "]e", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "[e", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "]e", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "[e", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffer navigation
map("n", "<leader>bd", "<cmd>Bdelete<cr>", { desc = "Delete Buffer but keep Window" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Telescope
map('n', '<leader><leader>', '<cmd>FzfLua files<cr>')
map('n', '<leader>g', '<cmd>FzfLua git_files<cr>')
map('n', '<leader>h', '<cmd>FzfLua oldfiles<cr>')
map('n', '<leader>;', '<cmd>FzfLua buffers<cr>')
map('n', '<leader>so', '<cmd>FzfLua lsp_document_symbols<cr>')
map('n', '<leader>sO', '<cmd>FzfLua lsp_workspace_symbols<cr>')
map('n', '<leader>ss', '<cmd>FzfLua grep<cr>')
map('v', '<leader>ss', '<cmd>FzfLua grep_visual<cr>')
map('n', '<leader>sc', '<cmd>FzfLua commands<cr>')
map('n', '<leader>sC', '<cmd>FzfLua command_history<cr>')
map('n', '<leader>sx', '<cmd>FzfLua<cr>')

-- LSP - could be done on attach in completion.lua but relies on FzfLua so here for now
map('n', 'grn', '<cmd>vim.lsp.buf.rename()<cr>', { noremap = true })
map('n', 'gO', '<cmd>FzfLua lsp_document_symbols<cr>', { noremap = true })
map('n', 'gra', '<cmd>FzfLua lsp_code_actions<cr>', { noremap = true })
map('n', 'grr', '<cmd>FzfLua lsp_references<cr>', { noremap = true })
map('n', 'gri', '<cmd>FzfLua lsp_implementations<cr>', { noremap = true })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  -- severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, {"WARN", "ERROR"}), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, {"WARN", "ERROR"}), { desc = "Prev Warning" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  if vim.fn.pumvisible() == 1 then
    return vim.fn["compe#close"]()
  end
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
