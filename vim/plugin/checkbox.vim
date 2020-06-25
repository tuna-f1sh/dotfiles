if exists('g:loaded_checkbox')
  finish
endif

if !exists('g:checkbox_states')
  let g:checkbox_states = [' ', 'x']
endif


if !exists('g:insert_checkbox')
  "let g:insert_checkbox = '^'
  "let g:insert_checkbox = '$'
  let g:insert_checkbox = '\<'
endif

if !exists('g:insert_checkbox_prefix')
  let g:insert_checkbox_prefix = ''
endif

if !exists('g:insert_checkbox_suffix')
  let g:insert_checkbox_suffix = ' '
endif

fu! checkbox#ToggleCB()
  let line = getline('.')

  if(match(line, '\[.\]') != -1)
    let states = copy(g:checkbox_states)
    call add(states, g:checkbox_states[0])

    for state in states
      if(match(line, '\[' . state . '\]') != -1)
        let next_state = states[index(states, state) + 1]
        let line = substitute(line, '\[' . state . '\]', '[' . next_state . ']', '')
        break
      endif
    endfor
  else
    if g:insert_checkbox != ''
      let line = substitute(line, g:insert_checkbox, g:insert_checkbox_prefix . '[' . g:checkbox_states[0] . ']' . g:insert_checkbox_suffix, '')
    endif
  endif

  call setline('.', line)
endf

command! ToggleCB call checkbox#ToggleCB()

let g:loaded_checkbox = 1
