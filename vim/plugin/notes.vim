if exists('g:loaded_notes') && &fd
  finish
endif
let g:loaded_notes = 1

if exists('$DROPBOX_ROOT')
  let g:dropbox_root="$DROPBOX_ROOT"
else
  let g:dropbox_root="$HOME/Library/CloudStorage/Dropbox"
endif

if exists('$NOTE_DIR')
  let g:note_dir="$NOTE_DIR"
else
  let g:note_dir=g:dropbox_root.'/Files/notes'
endif

function! Note(...)
  if (a:0)
    let s:file = g:note_dir.'/'.a:1.'.md'
    exec 'edit '.s:file
  else
    let l:fzf_opts = {}
    let l:fzf_opts.sink = 'e'
    let l:fzf_opts.dir = g:note_dir
    let l:fzf_opts.source = 'ls -t $(fd . -e md)'
    let l:fzf_opts.options = '--delimiter ":" --preview="cat '.g:note_dir.'/{1}" --preview-window=right:80'
    call fzf#run(fzf#wrap(l:fzf_opts))
  endif
endfunction

function! NoteSplit(...)
  if (a:0)
    let s:file = g:note_dir.'/'.a:1.'.md'
    exec 'vsplit '.s:file
  else
    let l:fzf_opts = {}
    let l:fzf_opts.sink = 'vsplit'
    let l:fzf_opts.dir = g:note_dir
    let l:fzf_opts.source = 'ls -t $(fd . -e md)'
    let l:fzf_opts.options = '--delimiter ":" --preview="cat '.g:note_dir.'/{1}" --preview-window=right:80'
    call fzf#run(fzf#wrap(l:fzf_opts))
  endif
endfunction

function! AgNote(search)
  let l:fzf_opts = {}
  let l:fzf_opts.sink = 'e'
  let l:fzf_opts.dir = g:note_dir
  let l:fzf_opts.source = 'ls -t $(ag --nobreak --nonumbers --noheading --markdown -l "'.a:search.'" .'g:note_dir.')'
  let l:fzf_opts.options = '--delimiter ":" --preview="cat '.g:note_dir.'/{1}" --preview-window=right:80'
  call fzf#run(fzf#wrap(l:fzf_opts))
endfunction

function! Journal(name)
  let s:file = $JOURNAL_DIR.'/'.a:name.'.md'
  exec 'edit '.s:file
endfunction

" check does not already exist as my fzf.lua for nvim has this
if !exists(':Note')
  command -nargs=? -complete=command Note :call Note(<f-args>)
  command -nargs=? -complete=command SNote :call NoteSplit(<f-args>)
  command -nargs=1 -complete=command AgNote :call AgNote(<f-args>)
  command -nargs=1 -complete=command Journal :call Journal(<f-args>)
endif
