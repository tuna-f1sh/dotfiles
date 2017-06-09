#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".macos" \
		--exclude "bootstrap.sh" \
		--exclude "antigen" \
		--exclude "support" \
		--exclude "brew.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . "$1";
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt "~";
elif [ "$1" == "--test" -o "$1" == "-t" ]; then
  doIt "./test/";
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
else
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt "~";
	fi;
fi;

unset doIt;
