stty -ixon # fixes suspension of terminal on crtl-s

check(){
  command -v "$1" >/dev/null 2>&1
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
# many other tests omitted
else
  case $(ps -o comm= -p "$PPID") in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

# Genralised options
unset REPORTTIME
unsetopt NOTIFY # disables comman finish notifications
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
# setopt correct

export COMPLETION_WAITING_DOTS=true
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTFILE=${HISTFILE:-"$HOME/.zsh_history"}
export VISUAL=vim
export LISTPROMPT=""
export VI_MODE_SET_CURSOR=true
export HASTEBIN_CLIPPER="wl-copy"

MODE_CURSOR_VIINS="blinking bar"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_VICMD="block"
MODE_CURSOR_SEARCH="steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD block"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL"

# printf '\n%.0s' {1..$LINES}
# Transient fns in zsh
function zle-line-init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0

  while true; do
    zle .recursive-edit

    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done

  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  # PROMPT='ﬦ '
  PROMPT='󰘧 '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}

zle -N zle-line-init
precmd() { printf "" }

check nvim && export VISUAL=nvim
export EDITOR=$VISUAL

[ -f "$HOME/.shell/path" ] && source "$HOME/.shell/path"
plugins_path="$HOME/.zsh_plugins"

[ -d "$plugins_path" ] || mkdir -p "$plugins_path"
[[ -r "$plugins_path/znap/znap.zsh" ]] ||
  git clone --depth 1 -- \
      https://github.com/marlonrichert/zsh-snap.git "$plugins_path/znap/"

source "$plugins_path/znap/znap.zsh"

znap_update() {
  unset cd
  unset -f cd
  znap pull
  exec zsh
}

# Prompt
# znap eval starship 'starship init zsh --print-full-init'
# znap prompt
eval "$( starship init zsh --print-full-init )" # znap needs fix

znap source Aloxaf/fzf-tab
znap source zsh-users/zsh-autosuggestions
znap source z-shell/F-Sy-H
znap source chrissicool/zsh-256color
znap source zsh-users/zsh-completions
znap source MichaelAquilina/zsh-you-should-use

if [ "$SESSION_TYPE" != "remote/ssh" ]; then
  znap source kutsan/zsh-system-clipboard
fi

znap source softmoth/zsh-vim-mode
znap source ohmyzsh/ohmyzsh lib/theme-and-appearance

znap source ohmyzsh/ohmyzsh plugins/sudo
znap source ohmyzsh/ohmyzsh plugins/colored-man-pages
znap source ohmyzsh/ohmyzsh plugins/safe-paste

# Completions
znap function _starship starship 'eval "$( starship completions zsh )"'
compctl -K _starship starship

znap function _rclone rclone 'eval "$( rclone completion zsh - )"'
compctl -K _rclone rclone

znap function _npm npm 'eval "$( npm completion )"'
compctl -K _npm npm

znap function _zellij zellij 'eval "$( zellij setup --generate-completion zsh )"'
compctl -K _zellij zellij

znap function _fnm fnm 'eval "$( fnm completions --shell zsh )"'
compctl -K _fnm fnm

check fnm && eval "$(fnm env --use-on-cd)"
 
alias history="history 0"
# bindkey '^l' autosuggest-accept     # control-l to accept autocompletions
bindkey '^ ' autosuggest-accept     # control-l to accept autocompletions

bindkey '^[j' fzf-tab-complete         # Alt-j to show tab completions and select
bindkey '^[k' fzf-tab-complete # Alt-k to show tab completions and select in reverse order

# using j,k,h,l in tab completion movement
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M viins 'jk' vi-cmd-mode
# extra sourcing
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh
[ -f /usr/share/doc/find-the-command/ftc.zsh ] && source /usr/share/doc/find-the-command/ftc.zsh noprompt quiet noupdate

[ -f "$HOME/.cache/wal/sequences" ] && /usr/bin/cat "$HOME/.cache/wal/sequences"

[ -f "$HOME/.shell/fzf.zsh" ] && source "$HOME/.shell/fzf.zsh"
[ -f "$HOME/.shell/aliases" ] && source "$HOME/.shell/aliases"
[ -f "$HOME/.extra-stuff" ] && source "$HOME/.extra-stuff"

