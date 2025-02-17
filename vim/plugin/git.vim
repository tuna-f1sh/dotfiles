" only load if fugitive plugin installed and script not already run
if exists('g:loaded_git')
  finish
endif

let g:loaded_git = 1

" sets b:git_dir to the git directory of the current file
"
" uses fugitive if available, otherwise searches for .git directory
function! Gitdir()
  if !exists('b:git_dir')
    if exists('g:loaded_fugitive')
      call FugitiveGitDir()
    else
      let git_folder=fnameescape(fnamemodify(finddir('.git', escape(expand('%:p:h'), ' ') . ';'), ':p:h'))
      if isdirectory(git_folder)
        let b:git_dir = b:project_root.'/.git'
      endif
    endif
  endif

  if exists('b:git_dir')
    let b:project_root = fnamemodify(b:git_dir.'/../', ':p:h')
    return b:git_dir
  endif

  return ''
endfunction

" cd to b:git_dir/../
function! Cdproject()
  if !exists('b:git_dir')
    call Gitdir()
  endif
  if !exists('b:git_dir')
    return
  endif
  if isdirectory(b:git_dir)
    exec "cd ".b:git_dir.'/../'
  endif
endfunction

function! Lcdproject()
  if !exists('b:git_dir')
    call Gitdir()
  endif
  if !exists('b:git_dir')
    return
  endif
  if isdirectory(b:git_dir)
    exec "lcd ".b:git_dir.'/../'
  endif
endfunction

function! SetupGitProject()
  " should get cached git directory
  if !exists('b:git_dir')
    call Gitdir()
  endif
  if !exists('b:git_dir')
    return
  endif
  if !empty(b:git_dir)
    if !exists('b:project_root')
      let b:project_root = fnamemodify(b:git_dir.'/../', ':p:h')
    endif
    exec "setlocal tags-=.git/tags"
    exec "setlocal tags^=".b:git_dir."/tags,".b:project_root."/tags"
    exec "setlocal path+=".b:project_root."/**"
    exec "setlocal path-=**"
  endif
endfunction

function! SetupGitMakeprg()
  if !exists('b:git_dir')
    call Gitdir()
  endif
  if !exists('b:git_dir')
    return
  endif
  if !empty(b:git_dir)
    let &makeprg = "if [ -f '%:p:h'/Makefile ]; then NO_COLOR=1 make DIAGNOSTICS_COLOR_WHEN=never -C '%:p:h' $*; else NO_COLOR=1 make DIAGNOSTICS_COLOR_WHEN=never -C ".escape(b:git_dir, ' ')."/ $*; fi"
  endif
endfunction


command! -nargs=? -complete=command SetGitDir :call SetupGitProject()
command! -nargs=? -complete=command Cdp :call Cdproject()
command! -nargs=? -complete=command Lcdp :call Lcdproject()

augroup git
  autocmd BufNewFile,BufReadPost * call SetupGitProject()
  autocmd BufNewFile,BufReadPost *.c,*.h,*.cpp,*.ino call SetupGitMakeprg()
augroup END
