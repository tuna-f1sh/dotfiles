#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install Bash 4
brew install bash
brew tap homebrew/versions
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

# Bins I use
brew install aircrack-ng
brew install ack
brew install archey
brew install arduino-mk
brew install automake
brew install avr-binutils
brew install avr-gcc
brew install avr-libc
brew install avrdude
brew install bash-completion
brew install binwalk
brew install cmake
brew install ctags
brew install dfu-util
brew install dos2unix
brew install ext2fuse
brew install fish
brew install gcc-arm-none-eabi
brew install git
brew install htop-osx
brew install iperf
brew install libftdi
brew install libftdi0
brew install libusb
brew install libusb-compat
brew install markdown
brew install minicom
brew install nettle
brew install ngrep
brew install nmap
brew install node
brew install openssl
brew install picocom
brew install pv
brew install python
brew install python3
brew install readline
brew install rename
brew install ruby
brew install the_silver_searcher
brew install tcptrace
brew install tmux
brew install xz
brew install zsh # homebrew zsh
brew install opfli

# Remove outdated versions from the cellar.
brew cleanup
