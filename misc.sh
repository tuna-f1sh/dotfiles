#!/usr/bin/env bash

if [ ! -e "$HOME/.vim/.vimundo" ]; then
  # Create vim undo dir
  echo "Creating .vim/.vimundo"
  mkdir $HOME/.vim/.vimundo
fi
