if exists('g:loaded_tab_wrapper')
  finish
endif
let g:loaded_tab_wrapper = 1

function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
