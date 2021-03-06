" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
" John's .vimrc file

" Notes
" ]e move line
"
" remember to use marks!
"
" gqip or gwip - format current paragraph
" vipJ - unformat current paragraph
" ggVGgq - format all paragraphs in buffer
" :%norm vipJ - unformat all paragraphs in buffer

"=================================
" --- OS SPECIFIC SETTINGS ---- "
"=================================

if has('win64') || has('win32') || has('win16')
    let g:ENV = 'WINDOWS'
else
   let g:ENV = toupper(substitute(system('uname'), '\n', '', ''))
endif
let g:HOST = hostname()

if (g:ENV =~# 'WINDOWS')
  " Enable Windows specific settings/plugins
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin

  "Set Shell Cgywin
  set shell=/bin/bash   " set shell Bash, helps with compatability with no POSIX
  " set shell=C:\\cygwin64\\bin\\bash.exe
  let &shellcmdflag='-c'
  set shellxescape="\"&|<>()@^"
  set shellpipe=2>&1\|tee
  set shellredir=>%s\ 2>&1
  set shellxquote=\"
  set shellslash
elseif (g:ENV =~# 'LINUX')
  " Enable Linux specific settings/plugins
elseif (g:ENV =~# 'DARWIN')
  " Enable MacOS specific settings/plugins
  set dictionary=/usr/share/dict/words
else
  " Other cases I can't think of like MINGW
endif

"=================================
" --- PLUG ---- "
"=================================

filetype off

" Neovim and Vim have different base installs to prevent conflict
if has("nvim")
  let plug_install='~/.local/share/nvim/site/autoload/plug.vim'
  let plug_path='~/.config/nvim/plugged'
elseif (g:ENV =~# 'WINDOWS')
  " Enable Windows specific settings/plugins
  let plug_install='$USERPROFILE/vimfiles/autoload/plug.vim'
  let plug_path='$USERPROFILE/.vim/plugged'
else
  let plug_install='~/.vim/autoload/plug.vim'
  let plug_path='~/.vim/plugged'
endif

" auto download vim-plug
if empty(glob(plug_install))
  execute "!curl -fLo " . plug_install . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(plug_path)

" Plugins
Plug 'tpope/vim-commentary' " easy comment stuff
" Plug 'w0rp/ale' " linter faster than syntastic
Plug 'majutsushi/tagbar' " Function preview window
Plug 'mbbill/undotree' " See undo history like commit history
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive' " Git plugin
Plug 'tpope/vim-unimpaired' " Shortcuts etc.
Plug 'junegunn/vim-peekaboo' " Register viewer
Plug 'tpope/vim-surround' " Surround stuff
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' } " FZF supporting functions install for vim
Plug 'junegunn/fzf.vim' " FZF plugin - better than Ctrl-P
Plug 'junegunn/goyo.vim' " Frame window for writting
Plug 'junegunn/limelight.vim' " Highlight only current paragraph for writting
Plug 'qpkorr/vim-bufkill' " Kill buffers whilst keeping splits
Plug 'christoomey/vim-tmux-navigator' " Tmux pane swap shortcuts and save on loose focus
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  } " live preview markdown in browser
" Plug 'reedes/vim-pencil' " writing (markdown) utilites, think I've covered most manually
Plug 'tpope/vim-dispatch' " async dispatch commands
Plug 'michaeljsmith/vim-indent-object' " define 'indent' object eg `ai` 'An Identation level and live above'
Plug 'SirVer/ultisnips' " Track the engine.
Plug 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them:
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" Syntax/Filetypes
Plug 'lervag/vimtex'
Plug 'pangloss/vim-javascript'
Plug 'torrancew/vim-openscad'
Plug 'chrisbra/csv.vim'
Plug 'darfink/vim-plist'

" Colours
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'
Plug 'endel/vim-github-colorscheme'
Plug 'romainl/flattened'
Plug 'chriskempson/base16-vim'
Plug 'yuttie/hydrangea-vim'
Plug 'Lokaltog/vim-monotone'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'reedes/vim-colors-pencil'

" All of your Plugins must be added before the following line
call plug#end()            " required

" My vim runtimes are in dotfiles managed by git
set runtimepath+=~/dotfiles/vim/,~/dotfiles/vim/after

" Vim built-in packages
runtime macros/matchit.vim

"=====================
" ---- INTERFACE ----
"=====================

set title " set terminal title as file
" Set 256 colours for terminals that have it
if &t_Co >= 256
  colorscheme vim-monokai-tasty
  let g:solarized_termcolors=256
  let g:rehash256 = 1
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
  let g:solarized_contrast="high"
  let g:solarized_visibility="high"
  let g:pencil_higher_contrast_ui = 1
  let base16colorspace=256  " Access colors present in 256 colorspace
endif
" Otherwise just put syntax highlighting on it some colour
if &t_Co > 2
  syntax on
endif

if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif

" Use base16 theme if set in shell
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

" --- GENERAL SETTINGS ---

set background=dark   " Dark background
set ruler             " Show line and column number
set encoding=utf-8    " Set default encoding to UTF-8
set autoread          " autoload external file changes
set history=100       " keep 100 lines of command line history
set backspace=indent,eol,start    " backspace through everything in insert mode
set autochdir         " autochange directory
set scrolloff=1000    " center the cursor in window
set wildmenu          " make command autocomplete easier
set shortmess +=Ic     " remove the start up message and short messages for complete
set splitbelow        " split below current buffer
set splitright        " split to right of current buffer
set vb t_vb=          " set visual bell
set lazyredraw        " improve performance, don't redraw while moving
set relativenumber "with number and relative creates hybrid
set number            " Line Numbering
set cursorline "highlight current line (slow in term)
set cursorcolumn
" always show signcolumns
set signcolumn=yes

set omnifunc=syntaxcomplete#Complete

" CTAGS location search
set tags=./.git/tags,.tags,tags,./.tags;,./tags;

" project path recursively
set path+=**

"" Searching
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter
imap <C-x><C-l> <plug>(fzf-complete-line)

"" undo
set undolevels=1000 " 1000 undos
set noundofile " no persistent undo

if has("persistent_undo")
  " if !isdirectory('~/.vim/.vimundo')
  "   call mkdir('~/.vim/.vimundo')
  " endif
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
set listchars=tab:>-,eol:¬,trail:-,extends:»,precedes:«,nbsp:+

" Set region to British English
set spelllang=en_gb

" Ignore types
set wildignore=*.swp,*.bak,*.pyc,*.class,*.asv

" Folding
nmap <leader>fs :set foldmethod=syntax<CR>
" set foldlevelstart=10 " start folding at > 10
set foldnestmax=1 "only 1 fold per syntax

" Save backups to tmp and directory swap where I know
if (g:ENV =~# 'WINDOWS')
  let $TMP='C:\tmp'
  " be explicit about vim/tmp for cygwin and windows crossover
  set backupdir^=$TMP,C:/cygwin64/tmp,$TEMP,C:/cygwin64/home/John\ Whittington/.vim/tmp
  set directory^=$TMP,C:/cygwin64/tmp,$TEMP,C:/cygwin64/home/John\ Whittington/.vim/tmp
else
  set backupdir^=/tmp,~/.vim/tmp
  set directory^=/tmp,~/.vim/tmp
endif

" ---- AUTOCMD ----

if has("autocmd")
  "Auto change to current directory on open
  autocmd! BufEnter * silent! lcd %:p:h

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  au! BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
end

"===================
" ---- PLUGINS ----
"===================

" The Silver Searcher
if executable('rg')
  " Use rg over ag
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
elseif executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ---- COC ----
"==============

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }



" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" ---- ALE ----
"==============

" Write this in your vimrc file
" let g:ale_lint_on_text_changed = 'never'
" " You can disable this option too
" " if you don't want linters to run on opening a file
" let g:ale_lint_on_enter = 0
" let g:ale_lint_on_save = 1
" let g:ale_open_list = 0

" " Disable linters for C/C++ and specify others
" let g:ale_linters = {
" \   'javascript': ['eslint'],
" \   'python': ['pylint'],
" \   'cpp': ['cppcheck'],
" \   'c': ['cppcheck'],
" \}

" let g:ale_javascript_eslint_options = '--quiet'

" augroup Linting
"   autocmd BufWritePost *.py,*.js silent make! <afile> | silent redraw!
"   autocmd QuickFixCmdPost [^l]* cwindow
" augroup END

" ---- AIRLINE / LIGHTLINE ----
" =================

" set noshowmode " hide mode using airline
set laststatus=2
let g:lightline = {
\ 'colorscheme': 'monokai_tasty',
\ }

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

" ---------- TMUX -------------------"
"======================================

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-a><c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-a><c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-a><c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-a><c-l> :TmuxNavigateRight<cr>

" ---- GIT ----
"==============

command! -nargs=* Glg Git! log --graph --pretty=format:'\%h - (\%ad)\%d \%s <\%an>' --abbrev-commit --date=local <args>

" ---- ULTISNIP ----
"==============
let g:UltiSnipsExpandTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"======================================
" ---------- MAPPING -----------"
"======================================

" i always, ALWAYS hit ":W" instead of ":w"
command! Q q
command! W w

" Macros
nmap \q :nohlsearch<CR>
nmap \l :setlocal number!<CR>:setlocal number?<CR>
nmap \z :w<CR>:!open %<CR><CR>
nmap \g :Gstatus<CR>

" having Ex mode start or showing me the command history
" is a complete pain in the ass if i mistype
" map Q  <silent>
" map q: <silent>
" map K  <silent>
"map q <silent>

"" LEADERS
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>
nnoremap <C-j> i<CR><ESC> " create a cut to new line
nmap <space> <leader>
" search replace
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
" buffers
nnoremap <leader>] :bnext<CR>
nnoremap <leader>[ :bprevious<CR>
nmap <leader>ww :w<CR>
" control-p / FZF
nmap <leader>; :Buffers<CR>
nmap <leader>pb :BLines<CR>
nmap <leader>pl :Marks<CR>
nmap <leader>pm :History<CR>
nmap <leader>pf :Files<CR>
nmap <leader>pt :Tags<CR>
nmap <leader>pg :GFiles<CR>
nmap <leader>ag :Ag <cword><CR>
vmap <leader>ag :Ag <C-R><CR>
"make commands
nmap <leader>mr :w<CR>:!clear;python %<CR>
nmap <leader>mk :w<CR>:silent make!<CR>:\|redraw!\|cw<CR>
nmap <leader>mu :w<CR>:make! upload\|redraw!\|<CR>
nmap <leader>mi :w<CR>:make! ispload\|redraw!\|<CR>

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
" Window manipulation
" swap to previous buffer, delete current
nnoremap <C-c> :BD<cr>
" close split
nnoremap <C-x> <C-w>q

" inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
" imap <Tab> <C-p>
" select last pasted
noremap gV `[v`]

"" GENERAL
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" ---- MOVEMENT ----
" Map the arrow keys to be based on display lines, not physical lines
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
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
