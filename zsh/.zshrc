# Profiler start
# zmodload zsh/zprof

# Source/Load zinit
source /usr/share/zinit/zinit.zsh

eval "$(starship init zsh)"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Keybindings
bindkey -e
bindkey '^@' leader-key
bindkey -s '\el' ' ls\n'

# Fix Ctrl+W to stop at *?_-.[]~=/&;!#$%^(){}<> characters
export WORDCHARS=''

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
# [Delete] - delete forward
bindkey -M emacs "^[[3~" delete-char
bindkey -M emacs "^[3;5~" delete-char
# [Ctrl-Delete] - delete whole forward-word
bindkey '^[[3;5~' kill-word
# [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey '^[[1;5D' backward-word

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word

# Completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# [Space] - don't do history expansion
bindkey ' ' magic-space

# Keybinds

# History setup
HIST_STAMPS="dd/mm/yyyy"
HISTFILE=$HOME/.zsh_history
SAVEHIST=30000
HISTSIZE=5000
HISTDUP=erase

setopt appendhistory
setopt inc_append_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt hist_verify
setopt hist_ignore_space

# Plugins for zsh
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=25
export ZSH_AUTOSUGGEST_USE_ASYNC=true
COMPLETION_WAITING_DOTS=true

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

zinit wait lucid for \
  atload'source ~/.config/aliases/eza.sh' \
  OMZL::directories.zsh \
  OMZL::git.zsh \
  OMZL::grep.zsh \
  OMZL::clipboard.zsh \
  OMZP::sudo \
  OMZP::man \
  OMZP::tldr \
  atload'source ~/.config/aliases/git.sh' \
  OMZP::git \
  OMZP::cp \
  OMZP::safe-paste \
  OMZP::copyfile \
  OMZP::copybuffer \
  OMZP::colored-man-pages \
  OMZP::dotenv \
  OMZP::command-not-found

# zinit snippet OMZL::...

# Dump completion cache into cache folder instead of home
export ZSH_COMPDUMP="$HOME/.cache/zsh/.zcompdump-$HOST"

# Load completions
fpath+=~/.zfunc;
autoload -Uz compinit && compinit -C

zinit cdreplay -q

# Custom zsh editing aliases
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# Editor & pager
alias snvim='sudoedit'

# Modern shell tools
source <(fzf --zsh)
eval "$(zoxide init zsh --no-cmd)"

alias z='__zoxide_zi'
# open to editor
ze() {
  DIR=$(zoxide query -i "$@")
  [ -n "$DIR" ] && cd "$DIR" && nvim .
}

# fzf catppuccin theme, no bg color
export FZF_DEFAULT_OPTS=" \
  --height 60% \
  --color=spinner:#F5E0DC,hl:#F38BA8 \
  --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
  --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
  --color=selected-bg:#45475A \
  --color=border:#6C7086,label:#CDD6F4"

# fzf config
exclude="--exclude .git --exclude node_modules --exclude .venv"
fd_args="--no-require-git --no-ignore-parent --hidden --strip-cwd-prefix"
export FZF_DEFAULT_COMMAND="fd --max-depth=4 $fd_args $exclude"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --max-depth=6 --type=d $fd_args $exclude"

show_file_preview="bat -n --color=always --line-range :500 {}"
show_dir_preview="eza --tree --level 2 --color=always {} | head -200"
show_file_or_dir_preview="if [ -d {} ]; then $show_dir_preview; else $show_file_preview; fi"
change_preview_window="ctrl-/:change-preview-window(down|hidden|)"

# preview options
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview' --bind '$change_preview_window'"
export FZF_ALT_C_OPTS="--preview '$show_dir_preview' --bind '$change_preview_window'"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --max-depth=4 --no-require-git --no-ignore-parent --hidden --exclude .git --exclude node_modules --exclude .venv . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --max-depth=6 --type=d --no-require-git --no-ignore-parent --hidden --exclude .git --exclude node_modules --exclude .venv . "$1"
}

# fzf + git integration
# https://github.com/junegunn/fzf-git.sh
[[ -f ~/.local/share/fzf-git.sh/fzf-git.sh ]] && source ~/.local/share/fzf-git.sh/fzf-git.sh

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd|z[e]|l[s,l]|eza)     fzf --preview "$show_dir_preview"         "$@" ;;
    cat|bat|vim|nvim)       fzf --preview "$show_file_or_dir_preview" "$@" ;;
    export|unset)           fzf --preview "eval 'echo \${}'"          "$@" ;;
    ssh)                    fzf --preview "dog --colour=always -- {}" "$@" ;;
    *)                      fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

completion_show_file_preview='bat -n --color=always --line-range :500 $realpath'
completion_show_dir_preview='eza --tree --level 2 --color=always $realpath | head -200'
completion_show_file_or_dir_preview="if [ -d \$realpath ]; then $completion_show_dir_preview; else $completion_show_file_preview; fi"

# _complete is base completer
# _extensions will complete glob patters with extensions
zstyle ':completion:*' completer _extensions _complete

zstyle ':completion:*' menu select  # menu with selection
zstyle ':completion:*' increment yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' squeeze-slashes yes  # replace // with /

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colored files and directories, blue selection box
zstyle ':completion:*' file-sort modification  # show recently used files first
zstyle ':completion:*' list-dirs-first yes
zstyle ':completion:*' ignored-patterns '.git'

zstyle ':completion:*' rehash false  # improves performance
zstyle ':completion:*' use-cache true

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags --height=60% --preview-window=right:60%:wrap
zstyle ':fzf-tab:complete:(cd|z|ls|eza):*' fzf-preview "$completion_show_dir_preview"
zstyle ':fzf-tab:complete:(cat|bat|vim|nvim):*' fzf-preview "$completion_show_file_or_dir_preview"

# Basic aliases
alias grep='grep --color=auto'

# eza - the better ls
source ~/.config/aliases/eza.sh

# Editor and Pager
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-X -igRS -j8 -x2 -#2 -z-10'

# bat - the better cat
export BAT_THEME="Catppuccin Mocha"
source ~/.config/aliases/bat.sh

# Set bat as the default man page viewer (colored man pages on steroids)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# source fvm
eval "$(fnm env --use-on-cd --shell zsh)"

# docker + git + tmux
source ~/.config/aliases/paru.sh
source ~/.config/aliases/systemctl.sh
source ~/.config/aliases/journalctl.sh
source ~/.config/aliases/file-folders.sh
source ~/.config/aliases/tmux.sh
source ~/.config/aliases/git.sh
source ~/.config/aliases/docker.sh

# My custom aliases
source ~/.config/aliases/homelab.sh
source ~/.config/aliases/lqip-auto.sh
source ~/.config/aliases/cht.sh

# Helper function to execute commands properly from ZLE
_run_cmd() {
  BUFFER="$1"
  zle accept-line
}
# Leader key actions
leader-key() {
  if ! read -k 1 -t 1 key; then
    zle beep
    return
  fi
  case $key in
    $'\C-f') _run_cmd " tmux-sessionizer" ;;
    $'\C-g') _run_cmd " lazygit || git status" ;;
    $'\C-n') _run_cmd " nvim || vim || vi || nano" ;;
    $'\C-o') _run_cmd " opencode" ;;
    c) _run_cmd " cht-enable" ;;
    d) _run_cmd " lazydocker || docker ps" ;;
    f) _run_cmd " tmux-sessionizer" ;;
    g) _run_cmd " lazygit || git status" ;;
    n) _run_cmd " nvim || vim || vi || nano" ;;
    o) _run_cmd " opencode" ;;
    b) _run_cmd " rbw unlock" ;;
    q) _run_cmd " exit" ;;
    s) _run_cmd " lazyssh" ;;
    t) _run_cmd " btop || htop || top" ;;
    *) zle beep ;;
  esac
}
zle -N leader-key

# Profiler end
# zprof

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$HOME/gems/bin:$PATH"
