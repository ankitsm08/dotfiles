alias cat='bat'
alias mman='bat -pl man'

# global aliases for help output
alias -g -- -h='-h 2>&1 | bat --color=always -Ppl help'
alias -g -- --help='--help 2>&1 | bat --color=always -Ppl help'
