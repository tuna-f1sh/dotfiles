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

## Useful Terminal Progs

* `fd` - easy to use `find`
* `ncdu` - visual `du`
* `bat` - nicer `cat`

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

## Thanks to…

* Originally forked from [Mathias
  dotfiles](https://github.com/mathiasbynens/dotfiles) - heavy changes.
* @ptb and [his _OS X Lion Setup_ repository](https://github.com/ptb/Mac-OS-X-Lion-Setup)
* [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Chris Gerke](http://www.randomsquared.com/) and his [tutorial on creating an OS X SOE master image](http://chris-gerke.blogspot.com/2012/04/mac-osx-soe-master-image-day-7.html) + [_Insta_ repository](https://github.com/cgerke/Insta)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](http://gf3.ca/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* [Lauri ‘Lri’ Ranta](http://lri.me/) for sharing [loads of hidden preferences](http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](http://hotfusion.nl/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](http://sindresorhus.com/)
* [Tom Ryder](https://sanctum.geek.nz/) and his [dotfiles repository](https://sanctum.geek.nz/cgit/dotfiles.git/about)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [OSXDefaults project](https://github.com/kevinSuttle/OSXDefaults), which aims to provide better documentation for [`~/.macos`](https://mths.be/macos)
* [Haralan Dobrev](http://hkdobrev.com/)
* anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
