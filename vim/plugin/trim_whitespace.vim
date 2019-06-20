function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

command! -nargs=0 -complete=command StripTrailingWhitespace :call StripTrailingWhitespace()
