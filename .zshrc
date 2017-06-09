source $HOME/dotfiles/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle colored-man-pages
antigen bundle wd
antigen bundle z
antigen bundle vi-mode

antigen theme $HOME/dotfiles/support john --no-local-clone

antigen apply

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

printf "$fg[yellow]
██╗    ██╗ █████╗ ███████╗███████╗███████╗██████╗ 
██║    ██║██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗
██║ █╗ ██║███████║█████╗  █████╗  █████╗  ██████╔╝ J.WHITTINGTON
██║███╗██║██╔══██║██╔══╝  ██╔══╝  ██╔══╝  ██╔══██╗   _____   __o
╚███╔███╔╝██║  ██║██║     ██║     ███████╗██║  ██║-------    -\<,
 ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝ ------ ( )/ ( )
"

#========
# ALIASES
#========

alias reload=". ~/.zshrc"

source ~/.aliases

#========
# EXPORTS
#========

source ~/.exports
source ~/.secrets

#========
# FUNCTIONS
#========

source ~/.functions
