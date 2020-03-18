setlocal nosmartindent
" compiler pylint " doesn't include file pass?
setlocal makeprg=pylint\ --output-format=text\ --msg-template=\"{path}:{line}:{column}:{C}:\ [{symbol}]\ {msg}\"\ --reports=no\ %
setlocal errorformat=%A%f:%l:%c:%t:\ %m,%A%f:%l:\ %m,%A%f:(%l):\ %m,%-Z%p^%.%#,%-G%.%#

" setlocal tw=80

let b:dispatch='pylint &'

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
