setlocal wrap
setlocal linebreak
setlocal autoindent
setlocal shiftwidth=4
setlocal tabstop=4
setlocal complete+=sk
setlocal colorcolumn=78
" setlocal textwidth=78
" setlocal makeprg=markdown\ %\ >\ %<.html
setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/pandoc/css/github.css\ --highlight-style=haddock\ --metadata=title=%\ --self-contained\ --output\ %<.html
let g:pencil#textwidth = 78
" setlocal spell
" let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html', 'c', 'python']
let g:pencil#wrapModeDefault = 'soft' " will auto to hard if detected
" call pencil#init()

noremap <buffer> j gj
noremap <buffer> k gk

function! Grip()
  :term grib -b %<cr>
endfunction

if exists(':CocStart')
  call CocSetup()
endif

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
