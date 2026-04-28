#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
cd "$DOTFILES"

"$DOTFILES/scripts/install-stow.sh"

if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/common/Brewfile"
fi

stow common
stow macos
stow hosts/macbook
