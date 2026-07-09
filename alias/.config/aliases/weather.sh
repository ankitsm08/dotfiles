weather() {
  if [ -z "$1" ]; then
    curl -s wttr.in/$1 | grep -v Follow
  else
    curl -s wttr.in | grep -v Follow
  fi
}
