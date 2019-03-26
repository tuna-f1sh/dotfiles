# John’s dotfiles

![Screenshot of my shell prompt](http://i.imgur.com/klQaU1Z.png)

## Installation

```bash
git clone https://github.com/tuna-f1sh/dotfiles && cd dotfiles
git submodule init
git submodule update
./mklink.sh # Make symbolic links of dotfiles to home
./mklink.sh .config # Make symbolic links of .config folders to .config (or
other folder)
./misc.sh # Run other setup items
./macos # Configure MacOS if using
```

Edit ~/.secrets to add machine only stuff and API keys.

# Notes

* `mkdir ~/.vim/.vimundo` for vim undo to work
* [Powerline Fonts](https://github.com/powerline/fonts)
* `.zshenv` is sourced as every spawn. Should include non-interactive exports.
  Not in the links dir - see note on this in notes dropbox.

## Useful Terminal Progs

* `fd` - easy to use `find`
* `ncdu` - visual `du`
* `bat` - nicer `cat`
* `up` - pipe tester
* `crex` - regex test [crex](https://octobanana.com/software/crex)
* `peaclock` - binary clock for CLI
  [peaclock](https://octobanana.com/software/peaclock)

## macOS

* base16-shell won't work in terminal because it's not full colour. Use
  profile in './support'.

## Linux

* usermod -a -G uucp _reguser_ - add user to USB serial devices
* `pacman -Qqe | grep -vx "$(pacman -Qqm)" > Packages` # backup pacman non-AUR
* `pacman -Qqm > Packages.aur` # backup AUR packages
* `pacman -S - < pkglist.txt` # re-install from list

## Windows

* [babun shell](http://babun.github.io/)
* [conemu terminal for quake style](https://conemu.github.io/)
* Make `$HOME` windows user profile directory
* `CYGWIN=winsymlinks:nativestrict` env variable before running link script
  but then remove for proper operation of ZSH.
