# Dotfiles Configuration

A clean, modern, and unified configuration setup for Linux featuring Hyprland (modular Lua configuration), dynamic Material You theming via Matugen, Waybar status bar, Kitty terminal, Rofi application menu, SwayNC notification center, Neovim (LazyVim), Fastfetch system fetch tool, Cava visualizer, and Zsh.

---

## Overview

This repository manages configurations for:

- **Window Manager:** Hyprland (configured via modular Lua)
- **Status Bar:** Waybar
- **Terminal:** Kitty
- **Application Launcher & Pickers:** Rofi
- **Notifications:** SwayNC
- **Dynamic Theming:** Matugen (Material You palette extraction)
- **Wallpaper Daemon:** awww
- **Text Editor:** Neovim (LazyVim setup)
- **System Information Fetch:** Fastfetch
- **Shell:** Zsh (Oh My Zsh)
- **Audio Visualizer:** Cava
- **Display Manager Theming:** SDDM (Matugen theme integration)

---

## Required Packages

To ensure all configurations, scripts, shortcuts, and themes work properly, install the following packages.

### Arch Linux / Pacman & AUR

#### 1. Official Repositories (Pacman)

```bash
sudo pacman -S --needed \
    hyprland \
    waybar \
    kitty \
    swaynotificationcenter \
    fastfetch \
    cava \
    neovim \
    zsh \
    git \
    curl \
    jq \
    dolphin \
    imagemagick \
    grim \
    slurp \
    satty \
    wl-clipboard \
    playerctl \
    brightnessctl \
    pipewire-pulse \
    wireplumber \
    libnotify \
    ttf-jetbrains-mono-nerd
```

#### 2. AUR Packages (Yay / Paru)

```bash
yay -S --needed \
    matugen-bin \
    awww \
    rofi-wayland \
    hyprshutdown
```

### Categorized Package Breakdown

| Category | Packages | Purpose |
|---|---|---|
| **Compositor & System** | `hyprland`, `waybar`, `swaynotificationcenter`, `awww`, `hyprshutdown` | Window manager, top status bar, notifications, and wallpaper daemon |
| **Terminal & Editor** | `kitty`, `neovim` | Terminal emulator and code editor |
| **Menu & Application Launcher** | `rofi-wayland` | App launcher, dynamic wallpaper selector, and color palette picker |
| **Color Generation & Theming** | `matugen-bin`, `imagemagick` | Dynamic Material You palette extraction and template rendering |
| **Screenshot & Clipboard** | `grim`, `slurp`, `satty`, `wl-clipboard` | Screen capture, area selection, image annotation, and clipboard sharing |
| **Audio & Media Control** | `cava`, `playerctl`, `pipewire-pulse`, `wireplumber` | Audio visualization in Waybar, media controls, and volume management |
| **System Utilities** | `fastfetch`, `brightnessctl`, `libnotify`, `dolphin`, `curl`, `jq` | System information fetch, brightness keys, desktop notifications, file manager, and script parsers |
| **Shell & Environment** | `zsh`, `git` | Modern shell and version control |

### Typography & Fonts

- **Terminal Font (Kitty):** `AnnotationM Nerd Font` (`AnnotationMNF`) - 11pt
- **UI & Bar Font (Waybar / Rofi):** `JetBrainsMono Nerd Font` (`ttf-jetbrains-mono-nerd`)

Ensure the Nerd Fonts are installed on your system (e.g. copied to `~/.local/share/fonts/` or installed via your package manager) and run `fc-cache -fv` to refresh the font cache.

---

## Installation Steps

### 1. Clone the Repository

Clone this repository into your home directory or local projects path:

```bash
git clone https://github.com/cloudlein/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
```

### 2. Backup Existing Configurations

Before deploying symlinks, backup any existing configuration folders to prevent data loss:

```bash
mkdir -p ~/.config-backup
for item in hypr kitty rofi waybar swaync matugen nvim cava fastfetch; do
    [ -e "$HOME/.config/$item" ] && mv "$HOME/.config/$item" ~/.config-backup/
done
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" ~/.config-backup/
```

### 3. Deploy Configuration Files

Create symbolic links from the dotfiles repository to your `~/.config` and `~/.zshrc`:

```bash
mkdir -p ~/.config

# Symlink configurations to ~/.config
ln -sfn ~/projects/dotfiles/hypr ~/.config/hypr
ln -sfn ~/projects/dotfiles/kitty ~/.config/kitty
ln -sfn ~/projects/dotfiles/rofi ~/.config/rofi
ln -sfn ~/projects/dotfiles/waybar ~/.config/waybar
ln -sfn ~/projects/dotfiles/swaync ~/.config/swaync
ln -sfn ~/projects/dotfiles/matugen ~/.config/matugen
ln -sfn ~/projects/dotfiles/nvim ~/.config/nvim
ln -sfn ~/projects/dotfiles/cava ~/.config/cava
ln -sfn ~/projects/dotfiles/fastfetch ~/.config/fastfetch

# Symlink Zsh configuration
ln -sf ~/projects/dotfiles/.zshrc ~/.zshrc
```

### 4. Ensure Script Permissions

Grant execution rights to custom helper scripts:

```bash
chmod +x ~/.config/hypr/scripts/*
chmod +x ~/.config/waybar/scripts/*
```

### 5. Setup Wallpapers Directory

The dynamic wallpaper picker script scans `~/wallpapers` for image files (`.jpg`, `.jpeg`, `.png`, `.webp`):

```bash
mkdir -p ~/wallpapers
```

Place your wallpaper collection inside `~/wallpapers`.

### 6. Install Oh My Zsh & Shell Plugins

If Oh My Zsh is not already installed:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the required Zsh plugins:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

---

## Directory Structure

```
dotfiles/
├── cava/                 # Cava audio visualizer configuration & themes
├── fastfetch/            # Fastfetch configuration and custom assets
├── hypr/                 # Hyprland modular Lua configs and helper scripts
│   ├── hyprland.lua      # Lua entrypoint for Hyprland
│   ├── lua/              # Modular settings (env, keybinds, autostart, etc.)
│   └── scripts/          # Dynamic wallpaper & color picker
├── kitty/                # Kitty terminal emulator configuration
├── matugen/              # Material You templates and configuration
├── nvim/                 # Neovim (LazyVim) IDE configuration
├── rofi/                 # Application launcher and picker themes
├── swaync/               # Sway Notification Center styling and configuration
├── waybar/               # Status bar configuration, custom modules & scripts
├── .zshrc                # Zsh shell configuration and aliases
└── README.md             # Documentation and installation guide
```

---

## Keybindings Reference

Default modifier: `SUPER` (Windows key)

| Keybinding | Action |
|---|---|
| `SUPER + Q` | Launch Terminal (Kitty) |
| `SUPER + C` | Close Active Window |
| `SUPER + R` | Application Launcher (Rofi) |
| `SUPER + E` | File Manager (Dolphin) |
| `SUPER + V` | Toggle Floating Window |
| `SUPER + W` | Dynamic Wallpaper & Theme Selector |
| `SUPER + L` | Screenshot Tool (Grim + Slurp + Satty) |
| `SUPER + J` | Toggle Split (Dwindle layout) |
| `SUPER + M` | Exit Session / Hyprshutdown |
| `SUPER + 1..0` | Switch Workspace 1-10 |
| `SUPER + SHIFT + 1..0` | Move Window to Workspace 1-10 |
| `SUPER + S` | Toggle Special Workspace (Scratchpad) |
| `SUPER + SHIFT + S` | Move Window to Special Workspace |
| `SUPER + Arrow Keys` | Focus Window Navigation |

---

## Theming & Matugen Integration

The wallpaper picker script (`SUPER + W`) dynamically updates the system theme:

1. Select a wallpaper from `~/wallpapers` via Rofi.
2. Select an extracted color swatch from the image palette.
3. Matugen applies dynamic colors across Waybar, Kitty, Rofi, Neovim, and SDDM without requiring a full session restart.
