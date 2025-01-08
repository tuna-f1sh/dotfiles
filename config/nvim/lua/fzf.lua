local fzf = require('fzf-lua')
fzf.setup({{'fzf-native', 'max-perf'}})
fzf.setup_fzfvim_cmds() -- vim old school

-- Custom commands

-- Notes
vim.api.nvim_create_user_command('Note', 'lua require("fzf-lua").files({ prompt="Note> ", cwd="$NOTE_DIR", fd_opts=[[--color=never --type f --hidden --follow --exclude .git -e md]] })', {})
vim.api.nvim_create_user_command('Gote', 'lua require("fzf-lua").live_grep({ prompt="GNote> ", cwd="$NOTE_DIR" })', {})
