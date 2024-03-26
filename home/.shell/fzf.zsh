# force sourcing default keymaps
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
[ -f /usr/share/fzf/completions.zsh ] && source /usr/share/fzf/completions.zsh

check (){
  command -v "$1" >/dev/null
}

TREE="tree -C"
check lsd && TREE="lsd --tree --depth 2"

check wl-copy && CLIP="wl-copy" || CLIP="xclip -selection clipboard"
check pbcopy && CLIP="pbcopy"

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
  --header 'Press CTRL-Y to copy command into clipboard'"

# variables
export FZF_DEFAULT_OPTS="$FZF_CUSTOM_BINDS_STR --no-height --no-reverse"
export FZF_CTRL_T_OPTS="$FZF_CUSTOM_BINDS_STR $FZF_CUSTOM_PREVIEW --layout=reverse"
export FZF_ALT_C_OPTS="$FZF_CUSTOM_BINDS_STR $FZF_CUSTOM_PREVIEW --layout=reverse"
export FZF_CTRL_T_COMMAND="find ./ -type f -not -path '*/\.git*'"
export FZF_ALT_C_COMMAND="find $dirPath -maxdepth 1 -not -path '*/\.git*' -type d"

check fd && {
	export FZF_CTRL_T_COMMAND="fd -H -tf --follow --exclude .git"
  export FZF_ALT_C_COMMAND="fd $dirPATH -H -td --exclude .git"
} || echo "For better fzf experience make sure you have fd install"

check zoxide && export _ZO_FZF_OPTS="$FZF_CUSTOM_BINDS $(preview_str -1) --height=60%"

# Utils Functions
gd() {
  preview="git diff $@ --color=always -- {-1}"
  check delta && preview="git diff $@ --color=always -- {-1} | delta"
  git diff $@ --name-only | fzf ${mopts[*]} -m --ansi --preview $preview
}

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
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
