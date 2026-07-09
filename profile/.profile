# .profile

# custom local script path for user
. $HOME/.local/bin/path-add
path-add "$HOME/.local/bin"

# Editor and Pager
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-X -igRS -j8 -x2 -#2 -z-10'

# bat - the better cat
export BAT_THEME="Catppuccin Mocha"

# Set bat as the default man page viewer (colored man pages on steroids)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

path-add "$HOME/.lmstudio/bin"

