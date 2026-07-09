# update mirrorlist first
pacmani reflector
sudo reflector --country India --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# initial full system upgrade
pacmani -yu

# install linux kernel and headers
pacmani linux linux-headers

# install paru (main package manager)
# only install if not installed
if ! command -v paru &> /dev/null; then
  pacmani base-devel # AUR + builds
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ..
  rm -rf paru

  cd ~
fi

# change package manager to paru (for the bootstrap script)
parui() {
  if [[ -n "$DRY_RUN" ]]; then
    echo "paru -S $*"
  else
    paru -S --needed --noconfirm "$@"
  fi
}

# update all packages with paru
parui -yu

# install yay (only as a backup/secondary option)
parui yay

# keyring for applications
parui gnome-keyring

# hyprland specifics
parui xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprpolkitagent

# system utils
parui zip unzip 7zip rsync wget expac dos2unix less

# dotfiles
parui chezmoi
