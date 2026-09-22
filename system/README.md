# system/ - machine-wide config (target: `/`, NOT `$HOME`)

This package is special. Everything else in this repo stows to `$HOME` (`stow foo`), but this one stows to `/`:

```bash
cd ~/dotfiles
sudo stow -t / system        # deploy
sudo stow -D -t / system     # undeploy
```

Contents (mirrors real paths under `/`):

- `etc/pacman.conf` - ILoveCandy, ParallelDownloads=5, [multilib] enabled
- `etc/default/grub` - GRUB-only laptop. Ignored on systemd-boot laptop, do NOT run grub-mkconfig there.
- `etc/sddm.conf` - greeter theme selection
- `etc/pam.d/sddm` - gnome-keyring auto-unlock on login (manual fix, keep)
- `etc/mkinitcpio.conf` - shared by both laptops (generic udev-based HOOKS, autodetected per-machine at build time). See note below.
- `etc/locale.gen` - enables `en_US.UTF-8 UTF-8` (required for locale-gen)
- `etc/xdg/reflector/reflector.conf` - `--country India --latest 10 --sort rate`
- `usr/share/sddm/themes/catppuccin-mocha-lavender/` - vendored
- `usr/share/grub/themes/catppuccin-mocha/` - vendored

## Per-machine notes

- GRUB `etc/default/grub`: `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- systemd-boot: `etc/default/grub` and `usr/share/grub/themes/` are dead weight, harmless. Never run grub-mkconfig there.
- After editing `etc/mkinitcpio.conf` on either machine: `sudo mkinitcpio -P`

## mkinitcpio sharing

Machines share one generic config: empty MODULES/BINARIES/FILES + `autodetect`,  
so each machine bakes its own hardware drivers at `mkinitcpio -P` time.

Split into `system-common/` + `system-<hostname>/` only if one machine ever needs encrypted-root hooks (`encrypt` vs `sd-encrypt`) or special MODULES (nvidia/btrfs/etc).
