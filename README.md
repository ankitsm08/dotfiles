<div align="center">

# dotfiles

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat-square&logo=arch-linux&logoColor=white)
![WM: Hyprland](https://img.shields.io/badge/WM-Hyprland-00DDB3?style=flat-square)
![Editor: Neovim](https://img.shields.io/badge/Editor-Neovim-57A143?style=flat-square&logo=neovim&logoColor=white)
![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-78909C?style=flat-square)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)
![Maintenance](https://img.shields.io/badge/Maintained-daily-ff69b4?style=flat-square)

</div>

Personal configuration for Arch Linux machines. Every file here is in daily use. Nothing is decorative.

## Contents

- [Stack](#stack)
- [Layout](#layout)
- [stank: the stow manager](#stank-the-stow-manager)
- [Fresh install](#fresh-install)
- [Notes & gotchas](#notes--gotchas)
- [Philosophy](#philosophy)
- [License](#license)

## Stack

| Role                 | Choice                                    |
| -------------------- | ----------------------------------------- |
| Distro               | Arch Linux                                |
| Window Manager       | Hyprland                                  |
| Terminal             | Ghostty, Foot (floating)                  |
| Shell                | Zsh (interactive), Bash (scripts)         |
| Multiplexer / Prompt | Tmux, Starship                            |
| Editor               | Neovim (daily), VSCodium (edge cases)     |
| Bar / Launcher       | Waybar, Vicinae                           |
| Notifications / OSD  | SwayNC, SwayOSD                           |
| Theme / Font         | Catppuccin Mocha, JetBrainsMono NF, Inter |
| AUR helper           | paru                                      |
| File manager         | Yazi (TUI), Nautilus (graphical)          |

## Layout

One directory per application, deployed with GNU Stow. Each package mirrors `$HOME`:

```
dotfiles/
  hypr/                -> ~/.config/hypr
  nvim/                -> ~/.config/nvim
  zsh/                 -> ~/.zshrc
  bin/                 -> ~/.local/bin
  system/              -> /  (machine-wide config, see below)
  stank                -> symlink to bin/.local/bin/stank (bootstrap entry point)
  .stank.conf          -> stank configuration
  dev/dev/setup/arch/  -> Arch bootstrap modules (packages, services, fonts)
```

`system/` is the exception: it stows to `/`, not `$HOME`. It holds system files that live in `/etc/`. See `system/README.md` for per-machine notes.

Packages I only partially own track individual files. Everything else tracks whole directories, with secrets and generated files excluded via per-package `.gitignore` files.

## stank: the stow manager

`stank` is the only command used to link or unlink anything in this repo. It wraps `stow` with `fzf` selection, per-package settings, and safe conflict handling. No raw `stow` invocations, no manual `rm` before linking.

```bash
stank                         # interactive: pick packages, pick action
stank deploy nvim hypr        # link packages
stank restow foot             # unlink + relink
stank undeploy wlogout        # remove links
stank adopt ghostty           # move live files into the repo, then link
stank status                  # show what is currently linked
```

Flags: `--dry-run`, `--all` (apply one conflict choice to the rest), `--yes` (non-interactive, default choice), `--verbose`.

How it works:

- **Targets.** Everything links to `$HOME` except `system`, which links to `/` via `sudo`. The two are never mixed in a single `stow` call.
- **Folding.** Default is whole-directory links, so new config files land in the repo automatically. `discord` and `gpg` are opted out (`--no-folding`): only the tracked files link, app caches and key material never enter the repo. Configured in `.stank.conf`.
- **Conflicts.** If a target already exists as a regular file, `stank` asks per package: overwrite (moved aside to `/tmp/stank-<timestamp>/`, never deleted), back up to `.bak`, adopt into the repo, or skip. Overwrite is the default.
- **After sudo.** Repo files touched by privileged runs are `chown`ed back.
- **Deliberately out of scope.** No commits, no package installs or removals, no kernel/grub rebuilds. It prints reminders for those (`grub-mkconfig` on the GRUB machine, `mkinitcpio -P` after initramfs edits) and stops there.

On a new machine the entry point needs no setup:

```bash
git clone <url> ~/dotfiles
~/dotfiles/stank    # deploy `bin` first, then the rest
```

## Fresh install

1. Base Arch install, user in the `sudo` group.
2. Clone the repo and run `./stank` (see above). Deploy `bin` first so `stank` is on `PATH` afterwards.
3. Optional: `dev/dev/setup/arch/bootstrap.sh` installs packages and services module by module (mirrors, base, shell, desktop, fonts, apps). Read a module before running it; comment out lines to skip.
4. Deploy the system package: `stank deploy system` (prompts for sudo), then follow the printed reminders for your bootloader.

Read scripts before running them. This repo assumes you know what `stow -D` does and are comfortable fixing a broken shell.

## Notes & gotchas

- `mkinitcpio.conf` is shared between machines (generic `udev`-based hooks, hardware autodetected at build time). If one machine ever needs encrypted-root hooks or special modules, split the config per host.
- `/etc/default/grub` and the GRUB theme are dead weight on the systemd-boot machine. Harmless, just never run `grub-mkconfig` there.
- `.pacnew` files appear when a package ships a new default config. Diff them, decide, delete. Don't let them pile up.
- GNOME Keyring unlock via SDDM requires the manual `pam_gnome_keyring` lines in `system/etc/pam.d/sddm`. SDDM does not set this up itself.

## Philosophy

- Keyboard first, mouse when it earns it.
- Explicit over magical. Fewer tools, deeper knowledge of each.
- If a task repeats, it gets scripted. If a keybind chafes, it gets replaced.
- Boring technology for the base, experiments at the edges.

## License

[MIT](LICENSE). Take whatever is useful; credit is appreciated but not required.
