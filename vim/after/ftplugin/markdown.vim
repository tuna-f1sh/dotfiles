setlocal wrap
setlocal linebreak
setlocal autoindent
setlocal shiftwidth=4
setlocal tabstop=4
setlocal complete+=sk
setlocal colorcolumn=78
setlocal textwidth=78
setlocal makeprg=markdown\ %\ >%<.html
" setlocal makeprg=pandoc\ %\ --to=html5\ --css=${HOME}/dotfiles/support/github.css\ --highlight-style=haddock\ --self-contained\ --output\ >%<.html
let g:pencil#textwidth = 78
" setlocal spell
" let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html', 'c', 'python']
" let g:pencil#wrapModeDefault = 'soft' " will auto to hard if detected
" call pencil#init()
