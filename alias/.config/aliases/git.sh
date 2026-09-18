alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'

# git-cd "Sep 15" == git cd "Sep 15" (same ~/.local/bin/git-cd binary).
# Prefer the `git-cd` form interactively: it gets commit-flag completion,
# while `git cd` goes through _git which can't complete custom subcommands
_git-cd() {
  if (( CURRENT == 2 )); then
    _message -e dates 'date (e.g. "Sep 15", "3:24pm", "2 hours ago")'
  else
    words=(git commit "${words[@]:2}")
    (( CURRENT-- ))
    _git
  fi
}
(( $+functions[compdef] )) && compdef _git-cd git-cd
