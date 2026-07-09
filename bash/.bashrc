# Only run in interactive shells
[[ $- != *i* ]] && return

# Starship prompt
eval "$(starship init bash)"

# Keybindings (emacs mode)
set -o emacs
# kill-region equivalent (Alt+w)
bind '"\ew": kill-region'

# Completion using arrow keys (based on history search)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# History setup
HISTFILE=$HOME/.bash_history
HISTSIZE=5000
HISTFILESIZE=30000
shopt -s histappend       # append to history
shopt -s cmdhist          # multiline commands as one entry
shopt -s histreedit       # re-edit failed history
shopt -s histverify       # verify before execution
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%d/%m/%Y %T '

# Bash completion
[[ -f /etc/bash_completion ]] && source /etc/bash_completion

# Modern shell tools
source <(fzf --bash)
eval "$(zoxide init bash)"

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
fd_args="--no-require-git --no-ignore-parent --hidden --follow --strip-cwd-prefix"
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

# fzf + git integration
# https://github.com/junegunn/fzf-git.sh
[[ -f ~/.local/share/fzf-git.sh/fzf-git.sh ]] && source ~/.local/share/fzf-git.sh/fzf-git.sh

# reload / edit bashrc
alias reload-bash='source ~/.bashrc'
alias edit-bash='nvim ~/.bashrc'

# Editor & pager
export PAGER='less'
export EDITOR='nvim'
export VISUAL='nvim'
alias snvim='sudoedit'

# Basic aliases
alias grep='grep --color=auto'

# bat - the better cat
export BAT_THEME="Catppuccin Mocha"
[[ -f ~/.config/aliases/bat.sh ]] && source ~/.config/aliases/bat.sh

# Set bat as the default man page viewer (colored man pages on steroids)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# eza - the better ls
[[ -f ~/.config/aliases/eza.sh ]] && source ~/.config/aliases/eza.sh

# source fvm
eval "$(fnm env --use-on-cd --shell bash)"

# chezmoi alias for ease of use
alias cm='chezmoi'

# bitwarden unlock alias (auto exports session token)
alias bwu='export BW_SESSION="$(bw unlock --raw)"'


[[ -f ~/.config/aliases/git.sh ]] && source ~/.config/aliases/git.sh
[[ -f ~/.config/aliases/docker.sh ]] && source ~/.config/aliases/docker.sh

# my custom aliases
[[ -f ~/.config/aliases/homelab.sh ]] && source ~/.config/aliases/homelab.sh
[[ -f ~/.config/aliases/lqip-auto.sh ]] && source ~/.config/aliases/lqip-auto.sh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/ank/.lmstudio/bin"
# End of LM Studio CLI section

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
