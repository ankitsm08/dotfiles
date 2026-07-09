# Ankarchy

> _A living record of a Linux system that bends to my will._

---

## What this repo **is**

This repository is my **personal Linux configuration archive**. It captures how I think, work, move, and flow inside a machine. These dotfiles are tuned for **speed, minimal friction, keyboard-first workflows, and long-term mastery**.

It is not just configs. It is **muscle memory encoded as text**.

I use this repo to:

- Rebuild my system from scratch without guesswork
- Track how my workflow evolves over time
- Experiment safely and roll back confidently
- Keep my environment _mine_ across machines

---

## What this repo **is not**

- NOT A **one-click** install for everyone
- NOT A **beginner-friendly** Linux starter pack
- NOT A perfectly **portable** setup across distros
- NOT A guarantee that things won't break

> Warning:
> These configs are **opinionated**, **biased**, and **shaped around my habits**.
> If something explodes on your system, _that's on you_. Future me knows this. Others have been **warned**.

---

<!-- ## 📸 Showcase -->
<!---->
<!-- > A system should look as sharp as it feels. -->
<!---->
<!-- [Showcase Video](https://www.youtube.com/watch?v=) -->
<!---->
<!-- |                                         Some | Pictures                                     | -->
<!-- | -------------------------------------------: | :------------------------------------------- | -->
<!-- | ![Setup 1](./assets/screenshots/setup-1.png) | ![Setup 2](./assets/screenshots/setup-2.png) | -->
<!-- | ![Setup 3](./assets/screenshots/setup-3.png) | ![Setup 4](./assets/screenshots/setup-4.png) | -->
<!---->
<!-- _(Screenshots are intentionally representative, not exhaustive.)_ -->
<!---->
<!-- --- -->

## What's inside

This repo currently manages:

- **Window Manager** - Hyprland
- **Terminal** - Ghostty + Foot (floating)
- **Shell** - Zsh + Bash (for scripts)
- **Multiplexer / Prompt** - Tmux + Starship
- **Editor** - Neovim (main) + VSCodium (edge cases)
- **Status Bar / Launcher** - Waybar + Vicinae
- **Notifications / OSD** - SwayNC + SwayOSD
- **Themes & UI** - Catppuccin Mocha + JetBrainsMono NF
- **Keybindings** - Very personal and opinionated
- **Scripts** - Many, many, many

Anything that affects how my hands talk to the machine eventually ends up here.

---

## Installation (for future me, mostly)

> ⚠️ **Read before running anything**

These steps assume:

- Arch-based system
- Comfortable with broken shells
- Willing to read scripts before executing them

### 1. Clone the repo

```bash
git clone https://github.com/ankitsm08/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Inspect before running

Do **not** blindly run scripts. Skim:

- `setup.sh`
- `setup/*`

Understand what gets installed and what gets linked.

### 3. Run the installer

```bash
./setup.sh
```

This will:

- Create required directories
- Symlink configs into `~` and `~/.config` and `~/.local`
- Install packages and configure services

### 4. Restart everything

Log out. Log back in. Restart your shell. Reload WM.
If something breaks, check git history.

---

## 🧠 Design philosophy

- Keyboard > Mouse
- Speed > Beauty (but both is better)
- Explicit over magical
- Fewer tools, deeper mastery
- Automation beats memory

If a task repeats, it gets scripted.
If a keybind feels awkward, it gets replaced.
If a feature is missing, it gets added.

---

## Things intentionally NOT tracked

- Wallpapers (licensing hell)
- Secrets / tokens / private keys
- Machine-specific hacks
- Temporary experiments

If it shouldn't survive a clean install, it doesn't belong here.

---

## Status

This repo is:

- Constantly changing and volatile
- Often unstable and incomplete
- Actively used daily

Breaking changes are normal. Stability is build slowly, not assumed.

---

## MIT License

Steal whatever helps you. Credit appreciated, not required.

---

_Built slowly. Refined daily. Owned completely._
