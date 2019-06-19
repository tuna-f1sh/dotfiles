#!/usr/bin/env bash

if [ ! -e "$HOME/.vim/.vimundo" ]; then
  # Create vim undo dir
  echo "Creating .vim/.vimundo"
  mkdir $HOME/.vim/.vimundo
fi

if [ ! -e "$HOME/.tmux" ]; then
  mkdir $HOME/.tmux
fi

if [ ! -e "$HOME/.tmux/plugins" ]; then
  mkdir $HOME/.tmux/plugins
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
