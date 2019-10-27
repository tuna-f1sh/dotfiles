if exists('g:loaded_pbcopy')
  finish
endif
let g:loaded_pbcopy = 1

" copy the current buffer or selected text as RTF
"
" bufnr - the buffer number of the current buffer
" line1 - the start line of the selection
" line2 - the ending line of the selection
function! s:CopyRTF(bufnr, line1, line2)
  " save the alternate file and restore it at the end
  let l:alternate=bufnr(@#)
    " open a new scratch buffer
    let orig_ft = &ft
    let l:orig_bg = &background
    let l:orig_nu = &number
    let l:orig_nuw = &numberwidth
    if exists("b:is_bash")
      let l:is_bash = b:is_bash
    endif
    new __copy_as_rtf__
    " enable the same syntax highlighting
    if exists("l:is_bash")
      let b:is_bash=l:is_bash
    endif
    let &ft=orig_ft
    let &background=l:orig_bg
    let &number=l:orig_nu
    let &numberwidth=l:orig_nuw
    set buftype=nofile
    set bufhidden=hide
    setlocal noswapfile

    " copy the selection into the scratch buffer
    call setline(1, getbufline(a:bufnr, a:line1, a:line2))

    silent exe "!pandoc % -t html -s --highlight-style pygments -H ~/dotfiles/support/pandoc/templates/rtf.html | pbcopy"
    silent bd!
    silent bd!

  let @# = l:alternate
  echomsg "RTF copied to clipboard"
endfunction

function! s:PandocRTF()
  silent exec '!pandoc % -t html5 -s --highlight-style pygments --quiet | textutil -stdin -font Helvetica -format html -convert rtf -stdout | pbcopy'
  echomsg "Copied as RTF"
endfunction


command! -range=% CopyRTF :call s:CopyRTF(bufnr('%'),<line1>,<line2>)
command! -range=% PandocRTF :call s:PandocRTF()
