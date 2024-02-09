if exists('g:loaded_coc_control')
  finish
endif
let g:loaded_coc_control = 1

function! CocSetup()
  if exists(':CocStart')
    CocStart
      " if hidden is not set, TextEdit might fail.
    set hidden

    " set tag func
    set tagfunc=CocTagFunc

    " May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
    " utf-8 byte sequence
    set encoding=utf-8

    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " Better display for messages
    set cmdheight=2

    " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    " delays and poor user experience
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    " always show signcolumns
    set signcolumn=yes

    " show status line information
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Use `[c` and `]c` to navigate diagnostics
    nmap <silent> [w <Plug>(coc-diagnostic-prev)
    nmap <silent> ]w <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)
    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)
    " Format selected
    nmap <leader>cf  <Plug>(coc-fix-current)
    xmap <leader>cf  <Plug>(coc-fix-current)

    " Run the Code Lens action on the current line.
    nmap <leader>cl  <Plug>(coc-codelens-action)

    " Use <C-l> for trigger snippet expand.
    " imap <C-l> <Plug>(coc-snippets-expand)

    " Use <C-s> for select text for visual placeholder of snippet.
    " vmap <C-s> <Plug>(coc-snippets-select)

    " Use <C-j> for jump to next placeholder, it's default of coc.nvim
    " let g:coc_snippet_next = '<c-j>'

    " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
    " let g:coc_snippet_prev = '<c-k>'

    " Use <C-j> for both expand and jump (make expand higher priority.)
    " imap <C-j> <Plug>(coc-snippets-expand-jump)

    " disable copilot default
    let g:copilot_no_tab_map = v:true
    imap <silent><script><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : copilot#Accept("\<C-e>")

    " new for tab but I actually prefer C-j, k to scroll and C-l to confirm
    " Use tab for trigger completion with characters ahead and navigate
    " NOTE: There's always complete item selected by default, you may want to enable
    " no select by `"suggest.noselect": true` in your configuration file
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#_select_confirm() :
          \ exists('b:_copilot.suggestions') ? copilot#Accept("\<Tab>") :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    " inoremap <silent><expr> <TAB>
    "       \ coc#pum#visible() ? coc#pum#next(1) :
    "       \ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
    "       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    "       \ CheckBackspace() ? "\<Tab>" :
    "       \ coc#refresh()
    " inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice.
    " inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
    "       \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    let g:coc_snippet_next = '<tab>'

    command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call CocAction('fold', <f-args>)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap <C-f> and <C-b> for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif
  endif
endfunction

command! -nargs=? -complete=command CocSetup :call CocSetup()
