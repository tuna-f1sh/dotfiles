autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt,text} setlocal ft=markdown

autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
