#!/usr/bin/env bash
# Set up these dotfiles on an Arch Linux machine. Safe to run again any time.
#
# Usage: ./install.sh [options]
#   --dry-run       print what would happen, change nothing
#   --no-packages   skip pacman / AUR / npm installs (only copy configs)
#   --no-aur        skip AUR packages (they build slowly)
#   --no-sddm       skip the SDDM login theme
#   -h, --help      show this help

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDDM_THEME_DIR=/usr/share/sddm/themes/sddm-astronaut-theme
SDDM_VARIANT="${SDDM_VARIANT:-astronaut}"   # see $SDDM_THEME_DIR/Themes/ for others

DRY_RUN=0 DO_PACKAGES=1 DO_AUR=1 DO_SDDM=1
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --no-packages) DO_PACKAGES=0 ;;
    --no-aur) DO_AUR=0 ;;
    --no-sddm) DO_SDDM=0 ;;
    -h | --help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg (try --help)"; exit 1 ;;
  esac
done

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*"; }
run() { if ((DRY_RUN)); then echo "  [dry-run] $*"; else "$@"; fi; }
in_container() { [[ -f /.dockerenv || -n "${container:-}" ]]; }
# Read a package list: drop comments and blank lines.
read_list() { sed 's/#.*//; s/[[:space:]]//g; /^$/d' "$1"; }

[[ -f /etc/arch-release ]] || { echo "This script only supports Arch Linux."; exit 1; }
[[ $EUID -ne 0 ]] || { echo "Run as your normal user (it uses sudo when needed)."; exit 1; }

install_packages() {
  local pkgs
  info "Installing packages from the official repos"
  mapfile -t pkgs < <(read_list "$DOTFILES/packages/pacman.txt")
  run sudo pacman -Syu --needed --noconfirm "${pkgs[@]}"

  if ((DO_AUR)); then
    if ! command -v paru >/dev/null; then
      info "Installing paru (AUR helper)"
      local tmp
      tmp="$(mktemp -d)"
      run git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$tmp/paru"
      if ((!DRY_RUN)); then (cd "$tmp/paru" && makepkg -si --noconfirm); fi
      rm -rf "$tmp"
    fi
    info "Installing AUR packages"
    mapfile -t pkgs < <(read_list "$DOTFILES/packages/aur.txt")
    run paru -S --needed --noconfirm "${pkgs[@]}"
  fi

  info "Installing global npm packages into ~/.local/npm"
  mapfile -t pkgs < <(read_list "$DOTFILES/packages/npm.txt")
  run npm config set prefix "$HOME/.local/npm"
  run npm install -g "${pkgs[@]}"
}

setup_tmux() {
  if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
    info "Installing tmux plugin manager"
    run git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
  # A tmux server started before TPM existed never ran the tpm line in .tmux.conf, so
  # TMUX_PLUGIN_MANAGER_PATH is unset there and install_plugins aborts. Re-source it.
  if tmux has-session 2>/dev/null; then
    run tmux source-file "$HOME/.tmux.conf"
  fi
  info "Installing tmux plugins"
  run "$HOME/.tmux/plugins/tpm/bin/install_plugins"
}

setup_sddm() {
  info "Installing SDDM astronaut theme ($SDDM_VARIANT)"
  if [[ -d $SDDM_THEME_DIR/.git ]]; then
    # metadata.desktop is edited below; put it back first so the pull can't conflict.
    run sudo git -C "$SDDM_THEME_DIR" checkout -- metadata.desktop
    run sudo git -C "$SDDM_THEME_DIR" pull --ff-only
  else
    run sudo git clone --depth 1 https://github.com/Keyitdev/sddm-astronaut-theme.git "$SDDM_THEME_DIR"
  fi
  run sudo cp -r "$SDDM_THEME_DIR/Fonts/." /usr/share/fonts/
  run sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/$SDDM_VARIANT.conf|" "$SDDM_THEME_DIR/metadata.desktop"
  run sudo install -Dm644 "$DOTFILES/system/sddm/theme.conf" /etc/sddm.conf.d/theme.conf
}

setup_system() {
  if in_container; then
    info "Running in a container, skipping login shell and services"
    return 0
  fi
  if [[ "$(getent passwd "$USER" | cut -d: -f7)" != */zsh ]]; then
    info "Changing login shell to zsh"
    run chsh -s /usr/bin/zsh
  fi
  info "Enabling services"
  run sudo systemctl enable bluetooth.service
  ((DO_SDDM)) && run sudo systemctl enable sddm.service
  return 0
}

((DO_PACKAGES)) && install_packages
info "Copying configs into \$HOME"
run "$DOTFILES/apply.sh"
setup_tmux
((DO_SDDM)) && setup_sddm
setup_system

info "Done. Reboot (or log out) to start Hyprland from the SDDM login screen."
