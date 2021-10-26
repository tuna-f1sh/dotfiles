" function! FormatJSON()
"   :%!python -m json.tool
" endfunction

" command! -nargs=0 -complete=command FormatJSON :call FormatJSON()
