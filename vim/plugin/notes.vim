function! Note()
  let l:fzf_opts = {}
  let l:fzf_opts.sink = 'e'
  let l:fzf_opts.dir = $NOTE_DIR
  let l:fzf_opts.source = 'ls -td $(fd . -e md)'
  let l:fzf_opts.options = '--delimiter ":" --preview="cat $NOTE_DIR/{1}" --preview-window=right:80'
  call fzf#run(fzf#wrap(l:fzf_opts))
endfunction

function! NoteSplit()
  let l:fzf_opts = {}
  let l:fzf_opts.sink = 'vsp'
  let l:fzf_opts.dir = $NOTE_DIR
  let l:fzf_opts.source = 'ls -td $(fd . -e md)'
  let l:fzf_opts.options = '--delimiter ":" --preview="cat $NOTE_DIR/{1}" --preview-window=right:80'
  call fzf#run(fzf#wrap(l:fzf_opts))
endfunction
