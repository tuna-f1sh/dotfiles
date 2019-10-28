if exists('g:loaded_pbcopy')
  finish
endif
let g:loaded_pbcopy = 1

" Set this to 1 to tell copy_as_rtf to use the local buffer instead of a scratch
" buffer with the selected code. Use this if the syntax highlighting isn't
" correctly handling your code when removed from its context in its original
" file.
if !exists('g:copy_as_rtf_using_local_buffer')
  let g:copy_as_rtf_using_local_buffer = 0
endif

let s:pandoc_cmd = 'pandoc -t html5 -s -H ${HOME}/dotfiles/support/pandoc/templates/rtf.html --highlight-style pygments --quiet'
let s:textutil_cmd = 'textutil -stdin -format html -convert rtf -stdout'

" copy the current buffer or selected text through pandoc as RTF
"
" bufnr - the buffer number of the current buffer
" line1 - the start line of the selection
" line2 - the ending line of the selection
function! s:CopyRTF(bufnr, line1, line2, type)

  " save the alternate file and restore it at the end
  let l:alternate=bufnr(@#)

  if g:copy_as_rtf_using_local_buffer
    let lines = getline(a:line1, a:line2)

    if a:type == 'raw'
      call tohtml#Convert2HTML(1, line('$'))
      silent exe '%!'.s:textutil_cmd.' | pbcopy'
      " delete the html buffer from tohtml command
      silent bd!
    else
      silent exe '%!'.s:pandoc_cmd.' | '.s:textutil_cmd.' | pbcopy'
    endif

    silent call setline(a:line1, lines)
  else

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

    if a:type == 'raw'
      call tohtml#Convert2HTML(1, line('$'))
      silent exe '%!'.s:textutil_cmd.' | pbcopy'
      " delete the html buffer from tohtml command
      silent bd!
    else
      silent exe '%!'.s:pandoc_cmd.' | '.s:textutil_cmd.' | pbcopy'
    endif

    silent bd!
  endif

  let @# = l:alternate
  echomsg "RTF copied to clipboard"
endfunction

command! -range=% CopyRTF :call s:CopyRTF(bufnr('%'),<line1>,<line2>, 'raw')
command! -range=% PandocCopyRTF :call s:CopyRTF(bufnr('%'),<line1>,<line2>, 'pandoc')
