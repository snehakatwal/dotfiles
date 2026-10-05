#!/usr/bin/env bash
# Copy the configs in this repo into $HOME. Existing ones are moved to ~/.dotfiles-backup/<date>/ first.
set -euo pipefail
cd "$(dirname "$0")"
backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

for item in .[!.]* .config/*; do
  case $item in .git | .gitignore | .config) continue ;; esac
  target="$HOME/$item"
  if [[ "$(readlink -f "$target")" == "$PWD/$item" ]]; then
    echo "skip   $item (already linked to this repo)"
    continue
  fi
  if [[ -e $target || -L $target ]]; then
    mkdir -p "$backup/$(dirname "$item")"
    mv "$target" "$backup/$item"
  fi
  mkdir -p "$(dirname "$target")"
  cp -a "$item" "$target"
  echo "copied $item"
done
[[ -d $backup ]] && echo "Old configs are in $backup"
exit 0
