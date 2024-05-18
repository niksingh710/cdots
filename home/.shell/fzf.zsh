# force sourcing default keymaps
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
[ -f /usr/share/fzf/completions.zsh ] && source /usr/share/fzf/completions.zsh

check (){
  command -v "$1" >/dev/null
}

TREE="tree -C"
check lsd && TREE="lsd --tree --depth 2"
check eza && TREE="eza --tree -L 2"

check wl-copy && CLIP="wl-copy" || CLIP="xclip -selection clipboard"
check pbcopy && CLIP="pbcopy"

check rg && {
  export FZF_DEFAULT_COMMAND="rg -uu \
          --files \
          -H"
}

check preview && {
  function preview_str() {
    # echo "--preview='preview --ueberzugpp {$1}; preview --cleanup'"
    echo "--preview='preview --sixel {$1}'"
  }
  zstyle ':fzf-tab:complete:*' fzf-preview 'preview --sixel $realpath'
}

export FZF_CUSTOM_BINDS=(
  "--bind=ctrl-d:preview-down"
  "--bind=ctrl-u:preview-up"
  "--bind=ctrl-space:select"
  "--bind=ctrl-/:deselect"
  "--bind=ctrl-p:change-preview-window(down|hidden|)"
  "--bind=ctrl-s:preview-page-down"
  "--bind=alt-p:toggle-preview"
  "--bind=ctrl-a:preview-page-up"
  "--bind=ctrl-u:half-page-up+refresh-preview"
  "--bind=alt-u:page-up+refresh-preview"
  "--bind=alt-d:page-down+refresh-preview"
  "--bind=alt-y:yank"
  "--bind=ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)"
  "--bind=alt-g:ignore"
  "--bind=ctrl-g:top"
  "--bind=alt-a:toggle-all"
  "--bind=alt-s:toggle-sort"
  "--bind=alt-h:backward-char+refresh-preview"
  "--bind=alt-l:forward-char+refresh-preview"
  "--bind=ctrl-l:clear-screen"
)

FZF_CUSTOM_BINDS_STR=""

# NOTE: Don't ask me why this is there just to make fzf accept custom and options binding together
for bind in "${FZF_CUSTOM_BINDS[@]}"; do
  key="${bind%%=*}"
  value="${bind#*=}"
  FZF_CUSTOM_BINDS_STR="$FZF_CUSTOM_BINDS_STR $key '$value'"
done

export FZF_CUSTOM_BINDS_STR
export FZF_CUSTOM_PREVIEW="$(preview_str)"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-p:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | $CLIP)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'
  --height=50%
  "

# variables
export FZF_DEFAULT_OPTS="$FZF_CUSTOM_BINDS_STR --no-height --no-reverse --info inline-right \
  --layout reverse --marker ▏ --pointer ▌ --prompt '▌ ' \
  --highlight-line --color gutter:-1,selected-bg:238,selected-fg:146,current-fg:189"
if [[ -z "$DISPLAY" ]]; then
  FZF_DEFAULT_OPTS+="
  --color=info:1 \  
  --color=prompt:2 \
  --color=pointer:3 \
  --color=hl+:4 \
  --color=marker:6 \
  --color=spinner:7 \
  --color=header:8 \
  --color=border:9 \
  --color=hl:122 \
  --color=preview-fg:11 \
  --color=fg:13 \
  --color=fg+:14"
fi

export FZF_CTRL_T_OPTS="$FZF_CUSTOM_BINDS_STR $FZF_CUSTOM_PREVIEW --layout=reverse"
export FZF_ALT_C_OPTS="$FZF_CUSTOM_BINDS_STR $FZF_CUSTOM_PREVIEW --layout=reverse"
export FZF_CTRL_T_COMMAND="find ./ -type f -not -path '*/\.git*' | sort -nr"
export FZF_ALT_C_COMMAND="find $dirPath -maxdepth 1 -not -path '*/\.git*' -type d"

check fd && {
  exclude_list=(
    "--exclude .git"
    "--exclude go"
  )
  export FZF_CTRL_T_COMMAND="fd -H -tf --follow ${exclude_list[*]} | xargs ls -t"
  export FZF_ALT_C_COMMAND="fd $dirPATH -td ${exclude_list[*]} | xargs ls -dt"
} || echo "For better fzf experience make sure you have fd install"

check zoxide && export _ZO_FZF_OPTS="$FZF_CUSTOM_BINDS $(preview_str -1) --height=60%"

# Utils Functions
gd() {
  preview="git diff $@ --color=always -- {-1}"
  check delta && preview="git diff $@ --color=always -- {-1} | delta"
  git diff $@ --name-only | fzf ${mopts[*]} -m --ansi --preview $preview
}

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle '*:fzf-tab:*' fzf-min-height 30
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd

zstyle ':fzf-tab:complete:cat:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'preview --sixel $realpath'

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:cp:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:mv:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:advcp:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:advmv:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:e:*' fzf-preview 'preview --sixel $realpath'

zstyle ':fzf-tab:complete:lsd:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'preview --sixel $realpath'
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'



check pacman && {

  pkmgr="pacman"
  check yay && pkmgr="yay"

  search-install() {
    $pkmgr -Slq | fzf $FZF_CUSTOM_BINDS --multi --preview "$pkmgr -Si {1}" | xargs -ro $pkmgr -S --needed
    zle reset-prompt
  }
  search-remove() {
    $pkmgr -Qq | fzf $FZF_CUSTOM_BINDS --multi --preview "$pkmgr -Qil {1}" | xargs -ro $pkmgr -Rcns
    zle reset-prompt
  }

  zle -N search-install search-install
  bindkey '^_' search-install # maps ctrl-/

  zle -N search-remove search-remove
  bindkey '^[^_' search-remove # maps ctrl-alt-/

  zstyle ':fzf-tab:complete:*yay*' fzf-preview 'yay -Si $desc'
  zstyle ':fzf-tab:complete:*pacman*' fzf-preview 'pacman -Si $desc'
}


fzf-man-widget() {
  batman="man {1} | col -bx | bat --language=man --plain --color always --theme=\"Monokai Extended\""
   man -k . | sort \
   | awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue;} 1' \
   | fzf  \
      -q "$1" \
      --ansi \
      --tiebreak=begin \
      --prompt=' Man > '  \
      --preview-window '50%,rounded,<50(up,85%,border-bottom)' \
      --preview "${batman}" \
      --bind "enter:execute(${batman})" \
      --bind "alt-c:+change-preview(cht.sh {1})+change-prompt(ﯽ Cheat > )" \
      --bind "alt-m:+change-preview(${batman})+change-prompt( Man > )" \
      --bind "alt-t:+change-preview(tldr --color=always {1})+change-prompt(ﳁ TLDR > )"
  zle reset-prompt
}
# `Ctrl-H` keybinding to launch the widget (this widget works only on zsh, don't know how to do it on bash and fish (additionaly pressing`ctrl-backspace` will trigger the widget to be executed too because both share the same keycode)
bindkey '^[m' fzf-man-widget
zle -N fzf-man-widget
  
man () {
  if [ $# -eq 0 ]; then
    fzf-man-widget
  fi
  check bat && {
    /usr/bin/man "$@" | col -bx | bat --language=man --plain --color always --theme="Monokai Extended"
  } || {
    colored $0 "$@"
  }

}

# Icon used is nerdfont

