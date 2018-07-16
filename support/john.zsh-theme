# vim:ft=zsh ts=2 sw=2 sts=2

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER="%F{green}%n%f"
  PR_USER_OP="%F{green}%#%f"
  PR_PROMPT="%f$ %f"
else # root
  PR_USER="%F{red}%n%f"
  PR_USER_OP="%F{red}%#%f"
  PR_PROMPT="%F{red}%$ %f"
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST="%F{red}%M%f" # SSH
else
  PR_HOST="%F{green}%M%f" # no SSH
fi

local user_host="$PR_USER%F{cyan}@$PR_HOST"

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return

  # Checks if working tree is dirty
  local STATUS=''
  local FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi

  if [[ -n $STATUS ]]; then
    GIT_PROMPT_COLOR="$ZSH_THEME_GIT_PROMPT_DIRTY"
    GIT_DIRTY_STAR="*"
  else
    GIT_PROMPT_COLOR="$ZSH_THEME_GIT_PROMPT_CLEAN"
    unset GIT_DIRTY_STAR
  fi

  echo "$GIT_PROMPT_COLOR$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$GIT_DIRTY_STAR$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT='
╭─[${user_host} %{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%} $(git_prompt_info)]
╰─[%{$fg_bold[blue]%}%*%{$reset_color%}]$PR_PROMPT'

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%}"
