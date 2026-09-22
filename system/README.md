# system/ - machine-wide config (target: `/`, NOT `$HOME`)

This package is special. Everything else in this repo stows to `$HOME`, but this one stows to `/`. Deploy it only through stank (it handles sudo and the target split): `stank deploy system`, `stank undeploy system`.

Contents (mirrors real paths under `/`):

- `etc/pacman.conf` - ILoveCandy, ParallelDownloads=5, [multilib] enabled
- `etc/default/grub` - GRUB-only laptop. Ignored on systemd-boot laptop, do NOT run grub-mkconfig there.
- `etc/sddm.conf` - greeter theme selection
- `etc/pam.d/sddm` - gnome-keyring auto-unlock on login (manual fix, keep)
- `etc/mkinitcpio.conf` - shared by both laptops (generic udev-based HOOKS, autodetected per-machine at build time). See note below.
- `etc/locale.gen` - enables `en_US.UTF-8 UTF-8` (required for locale-gen)
- `etc/xdg/reflector/reflector.conf` - `--country India --latest 10 --sort rate`

Themes (SDDM, GRUB) live in the `sddm-theme/` and `grub-theme/` packages, not here - split per bootloader so each machine deploys only what it needs. Boot-time assets must be REAL files under `/usr/share`: GRUB reads its theme before `/home` is mounted, and the `sddm` greeter user cannot traverse a `0700` home, so symlinks into the repo break both. Both theme packages deploy via copy (`method=copy` in `.stank.conf`), never via stow link.

## Per-machine notes

- GRUB `etc/default/grub`: `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- systemd-boot: `etc/default/grub` and `usr/share/grub/themes/` are dead weight, harmless. Never run grub-mkconfig there.
- After editing `etc/mkinitcpio.conf` on either machine: `sudo mkinitcpio -P`

## mkinitcpio sharing

Machines share one generic config: empty MODULES/BINARIES/FILES + `autodetect`,  
so each machine bakes its own hardware drivers at `mkinitcpio -P` time.

Split into `system-common/` + `system-<hostname>/` only if one machine ever needs encrypted-root hooks (`encrypt` vs `sd-encrypt`) or special MODULES (nvidia/btrfs/etc).
