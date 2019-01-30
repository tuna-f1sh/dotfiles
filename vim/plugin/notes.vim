if exists('g:loaded_notes') && &fd
  finish
endif
let g:loaded_notes = 1

function! Note(...)
  if (a:0)
    let s:file = $NOTE_DIR.'/'.a:1.'.md'
    exec 'edit '.s:file
  else
    let l:fzf_opts = {}
    let l:fzf_opts.sink = 'e'
    let l:fzf_opts.dir = $NOTE_DIR
    let l:fzf_opts.source = 'ls -td $(fd . -e md)'
    let l:fzf_opts.options = '--delimiter ":" --preview="cat $NOTE_DIR/{1}" --preview-window=right:80'
    call fzf#run(fzf#wrap(l:fzf_opts))
  endif
endfunction

function! NoteSplit()
  if (a:0)
    let s:file = $NOTE_DIR.'/'.a:1.'.md'
    exec 'vsplit '.s:file
  else
    let l:fzf_opts = {}
    let l:fzf_opts.sink = 'vsp'
    let l:fzf_opts.dir = $NOTE_DIR
    let l:fzf_opts.source = 'ls -td $(fd . -e md)'
    let l:fzf_opts.options = '--delimiter ":" --preview="cat $NOTE_DIR/{1}" --preview-window=right:80'
    call fzf#run(fzf#wrap(l:fzf_opts))
  endif
endfunction

command! -nargs=? -complete=command Note :call Note(<f-args>)
command! -nargs=? -complete=command SNote :call NoteSplit(<f-args>)
