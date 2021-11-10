# clone your plugin, set up an init.zsh, source it, and add to your fpath
function plugin-load () {
  local giturl="$1"
  local plugin_name=${${1##*/}%.git}
  local plugindir="${ZPLUGINDIR:-$HOME/.zsh/plugins}/$plugin_name"

  # clone if the plugin isn't there already
  if [[ ! -d $plugindir ]]; then
    command git clone --depth 1 --recursive --shallow-submodules $giturl $plugindir
    [[ $? -eq 0 ]] || { >&2 echo "plugin-load: git clone failed; $1" && return 1 }
  fi

  # symlink an init.zsh if there isn't one so the plugin is easy to source
  if [[ ! -f $plugindir/init.zsh ]]; then
    local initfiles=(
      # look for specific files first
      $plugindir/$plugin_name.plugin.zsh(N)
      $plugindir/$plugin_name.zsh(N)
      $plugindir/$plugin_name(N)
      $plugindir/$plugin_name.zsh-theme(N)
      # then do more aggressive globbing
      $plugindir/*.plugin.zsh(N)
      $plugindir/*.zsh(N)
      $plugindir/*.zsh-theme(N)
      $plugindir/*.sh(N)
    )
    [[ ${#initfiles[@]} -gt 0 ]] || { >&2 echo "plugin-load: no plugin init file found" && return 1 }
    command ln -s ${initfiles[1]} $plugindir/init.zsh
  fi

  # source the plugin
  source $plugindir/init.zsh

  # modify fpath
  fpath+=$plugindir
  [[ -d $plugindir/functions ]] && fpath+=$plugindir/functions
}

# if you want to compile your plugins you may see performance gains
function plugin-compile () {
  local plugindir="${ZPLUGINDIR:-$HOME/.zsh/plugins}"
  autoload -U zrecompile
  local f
  for f in $plugindir/**/*.zsh{,-theme}; do
    zrecompile -pq "$f"
  done
}

