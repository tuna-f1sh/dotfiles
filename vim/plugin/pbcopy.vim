if exists('g:loaded_pbcopy')
  finish
endif
let g:loaded_pbcopy = 1

function! s:PandocRTF()
  exec '!pandoc % -t html5 -s -H ${HOME}/dotfiles/support/pandoc/templates/rtf.html --highlight-style pygments --quiet | textutil -stdin -format html -convert rtf -stdout | pbcopy'
  echomsg "Copied as RTF"
endfunction

command! -range=% CopyRTF :call s:CopyRTF(bufnr('%'),<line1>,<line2>)
command! -range=% PandocRTF :call s:PandocRTF()
