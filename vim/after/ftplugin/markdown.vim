setlocal wrap
setlocal linebreak
setlocal autoindent
setlocal shiftwidth=4
setlocal tabstop=4
setlocal complete+=sk
setlocal colorcolumn=78
" setlocal textwidth=78
" setlocal makeprg=markdown\ %\ >\ %<.html
setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/pandoc/css/github.css\ --highlight-style=haddock\ --self-contained\ --output\ %<.html
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

function! PandocGithub()
  setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/pandoc/css/github.css\ --css=${HOME}/dotfiles/support/pandoc/css/github-syntax.css\ --highlight-style=haddock\ --self-contained\ --output\ %<.html
endfunction

function! PandocGeorgia()
  setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/pandoc/css/georgia.css\ --highlight-style=pygments\ --self-contained\ --output\ %<.html
endfunction

function! PandocKultiad()
  setlocal makeprg=pandoc\ %\ --to=html5\ --template=${HOME}/dotfiles/support/pandoc/templates/html.template --css=${HOME}/dotfiles/support/pandoc/css/kultiad-serif.css\ --highlight-style=pygments\ --self-contained\ --output\ %<.html
endfunction
