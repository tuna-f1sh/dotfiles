compiler eslint " defined by vim-javascript plugin
let b:dispatch='node %'

setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\)
setlocal define=^\\s*\\(function\\\|var\\\|define\\)[('\"]\\{-\\}

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']

if exists(':CocStart')
  call CocSetup()
elseif exists(':ALEInfo')
  let g:ale_sign_column_always = 1
  " always show signcolumns
  set signcolumn=yes
  set shortmess+=c
  " Remap keys for gotos
  nmap <buffer> <silent> gd :ALEGoToDefinition
  nmap <buffer> <silent> gr :ALEFindReferences

  " Use K to show documentation in preview window
  nnoremap <buffer> <silent> K :ALEDocumentation<CR>
endif
