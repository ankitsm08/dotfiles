#!/usr/bin/env bash
set -euo pipefail

command -v pacman >/dev/null || {
  echo "Not Arch. Aborting."
  exit 1
}

echo "
                   -`
                  .o+`
                 `ooo/
                `+oooo:
               `+oooooo:
               -+oooooo+:
             `/:-:++oooo+:
            `/++++/+++++++:
           `/++++++++++++++:
          `/+++ooooooooooooo/`
         ./ooosssso++osssssso+`
        .oossssso-````/ossssss+`
       -osssssso.      :ssssssso.
      :osssssss/        osssso+++.
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/

   Arch system bootstrap starting...
"

cd ~
pacmani() {
  if [[ -n "$DRY_RUN" ]]; then
    echo "pacman -S $*"
  else
    sudo pacman -S --needed --noconfirm "$@"
  fi
}

echo "Installing packages..."

./install/base.sh
./install/fonts.sh
./install/dev.sh
./install/desktop.sh
./install/media.sh

echo "Enabling services..."

./services/enable.sh
./system/sysctl.sh

echo "Applying dotfiles..."

./dotfiles/pre.sh
chezmoi apply
./dotfiles/post.sh

echo "Configuring devtools..."

./configure/shell.sh
./configure/tmux.sh
./configure/neovim.sh

echo "System ready. Touch grass or write code."

