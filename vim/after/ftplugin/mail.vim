setlocal complete+=sk
setlocal colorcolumn=0
setl tw=0
" setl fo=aw " w adds white space and auto reformat paragraphs
setl fo-=t
setl spell

function IsReply()
    if line('$') > 1
        :g/^>\s\=--\s\=$/,$ delete
        :%s/^.\+\ze\n\(>*$\)\@!/\0 /e
        :%s/^>*\zs\s\+$//e
        :1
        :put! =\"\n\n\"
        :1
    endif
endfunction

augroup mail_filetype
    autocmd!
    autocmd VimEnter /tmp/mutt* :call IsReply()
    autocmd VimEnter /tmp/mutt* :exe 'startinsert'
    autocmd VimEnter /private/tmp/mutt* :call IsReply()
    autocmd VimEnter /private/tmp/mutt* :exe 'startinsert'
augroup END

" Mark trailing spaces, so we know we are doing flowed format right
match ErrorMsg '\s\+$'
