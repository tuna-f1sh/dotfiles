setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/pandoc/css/github.css\ --highlight-style=haddock\ --metadata=title=%\ --self-contained\ --output\ %<.html
let g:pencil#textwidth = 78
let g:pencil#wrapModeDefault = 'soft' " will auto to hard if detected

" jump over wrapped lines
noremap <buffer> j gj
noremap <buffer> k gk

function! Glow()
  :term glow %
endfunction

function! ZenMode()
  if !exists("b:zen")
    let b:zen = 0
  endif
  :lua require("zen-mode").toggle(require("zen"))
  if !b:zen
    colorscheme PaperColor
    let b:zen = 1
  else
    colorscheme vim-monokai-tasty
    let b:zen = 0
  endif
endfunction


command! -buffer Render :call Glow()
command! -buffer Zen :call ZenMode()

function! PandocGithub()
  setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/pandoc/css/github.css\ --css=${HOME}/dotfiles/support/pandoc/css/github-syntax.css\ --highlight-style=haddock\ --metadata=title=%\ --self-contained\ --output\ %<.html
  exec 'make'
endfunction

function! PandocGeorgia()
  setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/pandoc/css/georgia.css\ --highlight-style=pygments\ --self-contained\ --quiet\ --output\ %<.html
  exec 'make'
endfunction

function! PandocKultiad()
  setlocal makeprg=pandoc\ %\ --to=html5\ --template=${HOME}/dotfiles/support/pandoc/templates/html.template --css=${HOME}/dotfiles/support/pandoc/css/kultiad-serif.css\ --highlight-style=pygments\ --self-contained\ --quiet\ --output\ %<.html
  exec 'make'
endfunction

function! PandocPdf()
  setlocal makeprg=pandoc\ %\ -f\ gfm\ -V\ linkcolor\:blue\ -V\ geometry\:a4paper\ -V\ geometry\:margin=2cm\ -V\ mainfont="Helvetica"\ -V\ monofont="Monaco"\ --pdf-engine=xelatex\ --output\ %<.pdf
  exec 'make'
endfunction

map <silent> <leader>tt :call checkbox#ToggleCB()<cr>
