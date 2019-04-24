compiler eslint " defined by vim-javascript plugin
let b:dispatch='node %'

" Enable completion where available.
" This setting must be set before ALE is loaded.
let g:ale_completion_enabled = 1
" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
let g:ale_sign_column_always = 1
