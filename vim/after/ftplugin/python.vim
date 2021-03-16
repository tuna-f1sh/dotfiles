setlocal nosmartindent
" compiler pylint " doesn't include file pass?
setlocal makeprg=pylint\ --output-format=text\ --msg-template=\"{path}:{line}:{column}:{C}:\ [{symbol}]\ {msg}\"\ --reports=no\ %
setlocal errorformat=%A%f:%l:%c:%t:\ %m,%A%f:%l:\ %m,%A%f:(%l):\ %m,%-Z%p^%.%#,%-G%.%#

" setlocal tw=80

let b:dispatch='pylint &'

if exists(':CocStart')
  call CocSetup()
elseif exists(':ALEEnable')
  let g:ale_sign_column_always = 1
  " always show signcolumns
  set signcolumn=yes
  set shortmess+=c
  " Remap keys for gotos
  nmap <buffer> <silent> gd :ALEGoToDefinition
  nmap <buffer> <silent> gr :ALEFindReferences

  " Use K to show documentation in preview window
  nnoremap <buffer> <silent> K :ALEDocumentation<CR>
  ALEEnable
endif

let g:slime_cell_delimiter = "##"

"------------------------------------------------------------------------------
" ipython-cell configuration
"------------------------------------------------------------------------------
" Keyboard mappings. <Leader> is \ (backslash) by default

" map <Leader>r to run script
nnoremap <Leader>r :IPythonCellRun<CR>

" map <Leader>c to execute the current cell
nnoremap <Leader>c :IPythonCellExecuteCell<CR>

" map <Leader>C to execute the current cell and jump to the next cell
nnoremap <Leader>C :IPythonCellExecuteCellJump<CR>

" map [h and ]h to jump to the previous and next cell header
nnoremap [h :IPythonCellPrevCell<CR>
nnoremap ]h :IPythonCellNextCell<CR>

" map <Leader>Q to restart ipython
nnoremap <Leader>Q :IPythonCellRestart<CR>

" map <Leader>D to start debug mode
nnoremap <Leader>D :SlimeSend1 %debug<CR>
