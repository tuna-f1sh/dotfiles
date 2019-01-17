setlocal wrap
setlocal linebreak
setlocal autoindent
setlocal colorcolumn=80
setlocal shiftwidth=4
setlocal tabstop=4
setlocal complete+=sk
let g:pencil#textwidth = 80
" setlocal spell
" let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html', 'c', 'python']
" let g:pencil#wrapModeDefault = 'soft' " will auto to hard if detected
call pencil#init()
