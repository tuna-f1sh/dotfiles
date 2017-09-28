set nocompatible "Use vim rather than vi settings

"=================================
" --- OS SPECIFIC SETTINGS ---- "
"=================================

if has("win32")
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin

  "Set Shell Cgywin
  set shell=C:\\cygwin64\\bin\\bash.exe
  let &shellcmdflag='-c'
  set shellxescape="\"&|<>()@^"
  set shellpipe=2>&1\|tee
  set shellredir=>%s\ 2>&1
  set shellxquote=\"
  set shellslash
  let g:gutentags_enabled = 0 " disable auto-update on windows to stop paths changing

elseif has("gui_macvim")
  set dictionary=/usr/share/dict/words
endif
"
"=================================
" --- PLUG ---- "
"=================================

filetype off

if has("nvim")
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" Plugins
Plug 'kien/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'tmhedberg/matchit' " html tag matching
Plug 'ddollar/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
" Plugin 'mtth/scratch.vim'
Plug 'mbbill/undotree'
" Plugin 'MarcWeber/vim-addon-signs'
Plug 'dhruvasagar/vim-markify' " signs for location and quickfix
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plugin 'itchyny/lightline.vim'
Plug 'sudar/vim-arduino-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-gutentags'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-latex/vim-latex'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/vim-peekaboo'
Plug 'darfink/vim-plist'
Plug 'tpope/vim-surround'
Plug 'torrancew/vim-openscad'
Plug 'mileszs/ack.vim'
Plug 'pangloss/vim-javascript'

" Plugin 'metakirby5/codi.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Colours
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'
Plug 'endel/vim-github-colorscheme'
Plug 'romainl/flattened'

" All of your Plugins must be added before the following line
call plug#end()            " required

"=====================
" ---- INTERFACE ----
"=====================

set title " set terminal title as file
let g:gutentags_enabled = 0 "disabled by default
" Set 256 colours for terminals that have it
if &t_Co >= 256 || has("gui_running")
  let g:gutentags_enabled = 1
  try
    colorscheme molokai
  endtry
  let g:solarized_termcolors=256
  set t_Co=256
  let g:rehash256 = 1
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
  let g:solarized_contrast="high"
  let g:solarized_visibility="high"
endif
" Otherwise just put syntax highlighting on it some colour
if &t_Co > 2 || has("gui_running")
  syntax on
endif

let g:pencil_higher_contrast_ui = 1

if has("gui_running")
  set guioptions -=T  "remove toolbar
  set guioptions -=m  "menu bar
  set guioptions +=t "buffer bar
  set guioptions -=r  "scrollbar
  set guioptions -=L  "left scrollbar
  set noshowmode " hide mode using airline
  if has("win32")
    try
      colorscheme molokai
      set guifont=DejaVu_Sans_Mono_for_Powerline:h10
    catch
    endtry
  else
    try
      colorscheme molokai
      set guifont=DejaVu_Sans_Mono_for_Powerline:h11
    catch
      set guifont=Menlo:h11
    endtry
  endif

endif

" --- GENERAL SETTINGS ---

set background=dark   " Dark background
set ruler             " Show line and column number
set encoding=utf-8    " Set default encoding to UTF-8
set number            " Line Numbering
" set clipboard+=unnamed " use system clipboard
set autoread          " autoload external file changes
set history=100       " keep 100 lines of command line history
set backspace=indent,eol,start    " backspace through everything in insert mode
set autochdir         " autochange directory
set scrolloff=1000    " center the cursor in window
set wildmenu          " make command autocomplete easier
set shortmess +=I     " remove the start up message
set splitbelow        " split below current buffer
set splitright        " split to right of current buffer
set vb t_vb=          " set visual bell
set lazyredraw        " improve performance, don't redraw while moving
if !has("win32")
  set shell=/bin/bash   " set shell Bash, helps with compatability with no POSIX
endif
set relativenumber "with number and relative creates hybrid
set cursorline "highlight current line (slow in term)

"filetype plugin on
set omnifunc=syntaxcomplete#Complete

" CTAGS location search
set tags=.tags,tags,./.git/tags,../tags,$HOME,./tags;
" project path recursively
set path+=**

"" Searching
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter
set keywordprg=google

"" undo
set undolevels=1000 " 1000 undos
set noundofile " no persistent undo

if has("persistent_undo") " must 'mkdir ~/.vim/.vimundo'
  set undodir=~/.vim/.vimundo " where to keep it
  set undofile " persistent undo
  set undoreload=100 " number of lines to save for undo
endif

" command complete settings
set wildmenu " make command autocomplete easier
set wildmode=longest,full
set completeopt+=longest

"Change buffers without saving
set hidden

" Syntax options
set smartindent
set smarttab " copy tab size from document
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set copyindent " copy the previous indentation on autoindent
let g:indent_guides_enable_on_vim_startup = 1

" another nice listchars configuration
set list
" set listchars=tab:\|\ ,eol:¬
set listchars=tab:>-,eol:¬,trail:-,extends:»,precedes:«,nbsp:+
" set listchars=tab:\|\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+

" Set region to British English
set spelllang=en_gb

" Ignore types
set wildignore=*.swp,*.bak,*.pyc,*.class,*.asv

" Folding
nmap <leader>fs :set foldmethod=syntax<CR>
" set foldlevelstart=10 " start folding at > 10
set foldnestmax=1 "only 1 fold per syntax

"" Sizing
" set go+=a "copy visual line to clipboard
if has("gui_running")
  if has("autocmd")
    " Automatically resize splits when resizing MacVim window
    autocmd VimResized * wincmd =
    " Use ~x on an English Windows version or ~n for French.
    if has("win32")
      au GUIEnter * simalt ~x
    endif
  endif
endif

" ---- AUTOCMD ----

if has("autocmd")
  "Auto change to current directory on open
  autocmd BufEnter * silent! lcd %:p:h

  " autosource config on exit
  " au BufLeave $MYVIMRC :source $MYVIMRC
  " --- FILETYPES ----
  " ===============
  autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
  autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  " Make sure all mardown files have the correct filetype set and setup
  " wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt,text} setlocal ft=markdown
  let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html', 'c', 'python']
  if !exists("g:disable_markdown_autostyle")
    au FileType markdown setlocal wrap linebreak textwidth=78 nolist complete+=sk colorcolumn=78
  endif
  " Remove smartindent on python to stop comments going SOL
  autocmd BufRead *.py set nosmartindent

  "" Cursor Stuff
  function! MyCursor()
  hi! Cursor guibg=lightgreen
  hi! Cursor guifg=black
  hi! CursorInsert guibg=#00CCFF
  hi! CursorVisual guibg=#ff5000
  hi! CursorReplace guibg=red
  " set guicursor=
  "           \n-v-c:block-Cursor/lCursor-blinkon0,
  "           \ve:ver35-CursorVisual,
  "           \o:hor50-Cursor,
  "           \i-ci:ver25-Cursor/lCursor-CursorInsert-blinkwait200-blinkoff150-blinkon200,
  "           \r-cr:hor20-Cursor/lCursor-CursorReplace,
  "           \sm:block-Cursor
  set guicursor=
        \a:block-blinkon0,
        \i-ci:ver25-CursorInsert,
        \r-cr:hor20-CursorReplace,
        \ve:ver35-CursorVisual,
        \o:hor50-Cursor,
        \c:ver30-blinkon300-CursorInsert
  " --- Auto change using autobuffer instead
  " au Insert-blinkwait175-blinkoff150-blinkon175",Leave * hi Cursor guibg=orange
  " au InsertEnter * hi Cursor guibg=#00CCFF
  endfunc
  call MyCursor()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
end

"===================
" ---- PLUGINS ----
"===================

" ---- GUTENTAGS ----
"====================
let g:gutentags_define_advanced_commands = 1
let g:gutentags_trace = 0 " debug
let g:gutentags_ctags_tagfile = '.tags'

" let g:GeeknoteNotebooks=['General', 'Fraser', 'JBR-Engineering', 'Ideas', '!Notebook']

" ---- AIRLINE ----
" =================
" Airline Options
set noshowmode " hide mode using airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" disable tagbar
let g:airline#extensions#tagbar#enabled = 0
" Show just the filename
let g:airline_powerline_fonts = 1
let g:airline_theme = 'badwolf'
" set timeoutlen=50
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
" let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_left_sep = ''
" let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
"let g:airline_right_sep = ''
"let g:airline_symbols.linenr = '☰'
"let g:airline_symbols.maxlinenr = ''
"let g:airline_symbols.readonly = ''
"let g:airline_symbols.crypt = '⚛'
"let g:airline_symbols.branch = 'ᚠ'
let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.notexists = '∄'
"let g:airline_symbols.whitespace = 'Ξ'
"let g:airline_symbols.spell = '♿'

" ---- TAGBAR ----
"====================
let g:tagbar_autoclose = 1
let g:tagbar_width = 30
let g:tagbar_type_arduino = {
            \ 'ctagstype' : 'c++',
            \ 'kinds'     : [
                \ 'd:macros:1:0',
                \ 'p:prototypes:1:0',
                \ 'g:enums',
                \ 'e:enumerators:0:0',
                \ 't:typedefs:0:0',
                \ 'n:namespaces',
                \ 'c:classes',
                \ 's:structs',
                \ 'u:unions',
                \ 'f:functions',
                \ 'm:members:0:0',
                \ 'v:variables:0:0'
            \ ],
            \ 'sro'        : '::',
            \ 'kind2scope' : {
                \ 'g' : 'enum',
                \ 'n' : 'namespace',
                \ 'c' : 'class',
                \ 's' : 'struct',
                \ 'u' : 'union'
            \ },
            \ 'scope2kind' : {
                \ 'enum'      : 'g',
                \ 'namespace' : 'n',
                \ 'class'     : 'c',
                \ 'struct'    : 's',
                \ 'union'     : 'u'
            \ }
        \ }

func! WordProcessorMode()
  setlocal formatoptions=1
  setlocal noexpandtab
  map j gj
  map k gk
  set thesaurus+=~/.vim/mthesaur.txt
  set complete+=sk
  set formatprg=par
  setlocal wrap
  setlocal linebreak
  set background=dark
  colorscheme pencil
  if has("win32")
    set guifont=Cousine:h10
  else
    set guifont=Cousine:h12
  end
  let g:airline_theme = 'pencil'
  let g:airline_powerline_fonts = 1
endfu
"com! WP call WordProcessorMode()
"set ffs=dos " set file system type (when on windows stops funky charactors
" Removes trailing spaces
function! TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

" ---- CTRL P ----
"==================

let g:ctrlp_cmd = 'call CallCtrlP()'
" let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_max_files = 1000 " stops freezeing if started in root

" function defaults to MRU mode but after invoke uses last called state
func! CallCtrlP()
  if exists('s:called_ctrlp')
    CtrlPLastMode
  else
    let s:called_ctrlp = 1
    CtrlPMRU
  endif
endfunc

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_c_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_always_populate_location_list = 1
let g:ycm_auto_trigger = 99
let g:ycm_filetype_blacklist = {'tex':1}
" let g:ycm_key_invoke_completion = '<C-Space>'
:let g:ycm_enable_diagnostic_highlighting = 0
:let g:ycm_show_diagnostics_ui = 0
:let g:ycm_enable_diagnostic_signs = 0

" Syntastic Options
let g:syntastic_check_on_open = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs = 1
" let g:syntastic_c_no_include_search = 1
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_c_include_dirs = [ 'lib', 'libraries', 'inc', 'include','/usr/local/include/avr/include','/usr/local/include/avr/include/avr']
let g:syntastic_cpp_include_dirs = [ 'lib', 'libraries', 'inc', 'include' ]
" let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_remove_include_errors = 1
" let g:syntastic_debug = 1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_mode_map = { "mode": "passive",
      \ "active_filetypes": ['matlab','python','javascript'],
      \ "passive_filetypes": ['html'] }
let g:syntastic_javascript_checkers=['eslint']

" The Silver Searcher
if executable('ag') && !exists(":Ag")
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ackprg = 'ag --vimgrep'

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  " bind K to grep word under cursor
  nnoremap <Leader>ss :Ag <cword> .<CR>
endif

" Quickfix
:botright cwindow "open full window width

" Save backups to tmp and directory swap where I know
if has("win32")
  " let $TMP='C:\tmp'
  " " be explicit about vim/tmp for cygwin and windows crossover
  " set backupdir^=$TMP,C:/cygwin64/tmp,$TEMP,C:/cygwin64/home/John\ Whittington/.vim/tmp
  " set directory^=$TMP,C:/cygwin64/tmp,$TEMP,C:/cygwin64/home/John\ Whittington/.vim/tmp
else
  set backupdir^=/tmp,~/.vim/tmp
  set directory^=/tmp,~/.vim/tmp
endif

" ---------- KEY BINDINGS -----------"
"======================================

"" LEADERS
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>
" Underline the current line with '=' and comment
nmap <silent> <leader>ul :t.<CR>Vr=<leader>cc
nnoremap <C-j> i<CR><ESC> " create a cut to new line
" map leader to ,
" map , <leader>
nmap <space> <leader>
" search
nnoremap <leader>ag :Ack<CR>
vnoremap <Leader>ag y:Ack <C-r>"<CR>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
" buffers
nnoremap <C-Tab> :bnext<CR>
nnoremap <C-l> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <C-h> :bprevious<CR>
nnoremap <leader>] :bnext<CR>
nnoremap <leader>[ :bprevious<CR>
nnoremap <Tab> <C-^> " last used buffer
nmap <leader>bd :bd<CR>
nmap <leader>sc <C-w>q
nmap <leader>ww :w<CR>
" control-p
nmap <leader>pb :CtrlPBuffer<CR>
nmap <leader>pm :CtrlPMRU<CR>
nmap <leader>pf :CtrlP<CR>
nmap <leader>pa :CtrlPMixed<CR>
nmap <leader>pu :CtrlPUndo<CR>
"make commands
nmap <F7> :w<CR>:silent make!<CR>:\|redraw!\|cw<CR>
nmap <F5> :w<CR>:make! upload\|redraw!\|cw<CR>
nmap <F4> :w<CR>:make! upload\|redraw!\|cw<CR>
nnoremap <silent> <F9> :w<CR>:!clear;python %<CR>
nmap <leader>mk :w<CR>:silent make!<CR>:\|redraw!\|cw<CR>
nmap <leader>mu :w<CR>:make! upload\|redraw!\|cw<CR>
nmap <leader>mi :w<CR>:make! ispload\|redraw!\|cw<CR>
" remap the ctrl-a/x to inc/dec ints
nnoremap <C-a> <C-a>
nnoremap <C-x> <C-x>
" Tagbar
nnoremap <leader>tb :TagbarToggle<CR>
" Command repeating
vnoremap . :normal .<CR> " last command
vnoremap ` :normal @a<CR> " last register
" UndoTree
nmap <leader>tt :UndotreeToggle<cr>

function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
" imap <Tab> <C-p>
" select last pasted
noremap gV `[v`]

"" GENERAL
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

if has("gui_macvim") && has("gui_running")
  " Comment toggle mapping
  nmap <D-/> <leader>c<Space>
  vmap <D-/> <leader>c<Space>gv
  " swap to previous buffer, delete current
  nnoremap <C-c> :bp\|bd #<CR>
  " close split
  nnoremap <C-x> <C-w>q
  " Map command-[ and command-] to indenting or outdenting
  " while keeping the original selection in visual mode
  vmap <D-]> >gv
  vmap <D-[> <gv

  nmap <D-]> >>
  nmap <D-[> <<

  omap <D-]> >>
  omap <D-[> <<

  imap <D-]> <Esc>>>i
  imap <D-[> <Esc><<i

  " Bubble single lines
  nmap <D-Up> [e
  nmap <D-Down> ]e
  nmap <D-k> [e
  nmap <D-j> ]e

  " Bubble multiple lines
  vmap <D-Up> [egv
  vmap <D-Down> ]egv
  vmap <D-k> [egv
  vmap <D-j> ]egv

  " Map Command-# to switch tabs
  map  <D-0> 0gt
  imap <D-0> <Esc>0gt
  map  <D-1> 1gt
  imap <D-1> <Esc>1gt
  map  <D-2> 2gt
  imap <D-2> <Esc>2gt
  map  <D-3> 3gt
  imap <D-3> <Esc>3gt
  map  <D-4> 4gt
  imap <D-4> <Esc>4gt
  map  <D-5> 5gt
  imap <D-5> <Esc>5gt
  map  <D-6> 6gt
  imap <D-6> <Esc>6gt
  map  <D-7> 7gt
  imap <D-7> <Esc>7gt
  map  <D-8> 8gt
  imap <D-8> <Esc>8gt
  map  <D-9> 9gt
  imap <D-9> <Esc>9gt
else
  " Comment toggle mapping
  nmap <A-/> <leader>c<Space>
  vmap <A-/> <leader>c<Space>gv
  " swap to previous buffer, delete current
  nnoremap <C-c> :bp\|bd #<CR>
  " close split
  " nnoremap <C-x> <C-w>q " can cause issue over cygwin ssh?
  " Map command-[ and command-] to indenting or outdenting
  " while keeping the original selection in visual mode
  vmap <A-]> >gv
  vmap <A-[> <gv

  nmap <A-]> >>
  nmap <A-[> <<

  omap <A-]> >>
  omap <A-[> <<

  imap <A-]> <Esc>>>i
  imap <A-[> <Esc><<i

  " BubbAe single lines
  nmap <A-Up> [e
  nmap <A-Down> ]e
  nmap <A-k> [e
  nmap <A-j> ]e

  " BubbAe multiple lines
  vmap <A-Up> [egv
  vmap <A-Down> ]egv
  vmap <A-k> [egv
  vmap <A-j> ]egv

  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>

  " Map Control-# to switch tabs
  map  <C-0> 0gt
  imap <C-0> <Esc>0gt
  map  <C-1> 1gt
  imap <C-1> <Esc>1gt
  map  <C-2> 2gt
  imap <C-2> <Esc>2gt
  map  <C-3> 3gt
  imap <C-3> <Esc>3gt
  map  <C-4> 4gt
  imap <C-4> <Esc>4gt
  map  <C-5> 5gt
  imap <C-5> <Esc>5gt
  map  <C-6> 6gt
  imap <C-6> <Esc>6gt
  map  <C-7> 7gt
  imap <C-7> <Esc>7gt
  map  <C-8> 8gt
  imap <C-8> <Esc>8gt
  map  <C-9> 9gt
  imap <C-9> <Esc>9gt
endif

" ---- ARROW KEYS ----
" Map the arrow keys to be based on display lines, not physical lines
" imap <Down> gj
" imap <Up> gk
map <C-j> gj
map <C-k> gk
" Disable arrow keys
nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
" nmap <up> <nop>
" nmap <down> <nop>
" nmap <left> <nop>
" nmap <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
imap <left> <nop>
imap <right> <nop>