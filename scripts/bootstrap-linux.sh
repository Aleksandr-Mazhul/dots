#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
HOST_PACKAGE="${HOST_PACKAGE:-$(hostname -s)}"
cd "$DOTFILES"

"$DOTFILES/scripts/install-stow.sh"

stow common
stow linux
if [ -d "$DOTFILES/hosts/$HOST_PACKAGE" ]; then
  stow -d hosts -t "$HOME" "$HOST_PACKAGE"
else
  echo "ℹ️  Host package hosts/$HOST_PACKAGE not found. Skipping host overrides."
fi
