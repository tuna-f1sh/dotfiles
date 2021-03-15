if exists('g:loaded_git')
  finish
endif
let g:loaded_git = 1

function! Gitdir()
  let g:gitdir=fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' ') . ';'), ':h'))
  set tags=.git/tags,.tags,tags,./tags;
  if g:gitdir != '' && isdirectory(g:gitdir) && index(split(&path, ","),g:gitdir) < 0
    exec "setlocal tags^=".g:gitdir."/.git/tags"
    exec "setlocal path+=".g:gitdir."/**"
    " let &makeprg = "if [ -f '%:p:h'/Makefile ]; then make DIAGNOSTICS_COLOR_WHEN=never -C '%:p:h' $*; else make DIAGNOSTICS_COLOR_WHEN=never -C ".g:gitdir." $*; fi"
  endif
endfunction

function! SetupGitProject()
  " should get cached git directory
  if g:loaded_fugitive
    let dir = FugitiveGitDir()
    if !empty(dir)
      exec "setlocal tags^=".dir."/tags"
      exec "setlocal path+=".dir."/../**"
      " let &makeprg = "if [ -f '%:p:h'/Makefile ]; then make DIAGNOSTICS_COLOR_WHEN=never -C '%:p:h' $*; else make DIAGNOSTICS_COLOR_WHEN=never -C ".dir."/../ $*; fi"
    endif
  endif
endfunction

" command! -nargs=0 -complete=command GitDir :call Gitdir()
command! -nargs=0 -complete=command SetGitDir :call SetupGitProject()

function! SetupGitMakeprg()
  let dir = FugitiveGitDir()
  if !empty(dir)
    let &makeprg = "if [ -f '%:p:h'/Makefile ]; then make DIAGNOSTICS_COLOR_WHEN=never -C '%:p:h' $*; else make DIAGNOSTICS_COLOR_WHEN=never -C ".dir."/../ $*; fi"
  endif
endfunction


augroup git
  autocmd BufNewFile,BufReadPost * if g:loaded_fugitive | call SetupGitProject() | endif
  autocmd BufNewFile,BufReadPost *.c,*.h,*.cpp,*.ino if g:loaded_fugitive | call SetupGitMakeprg() | endif
augroup END
