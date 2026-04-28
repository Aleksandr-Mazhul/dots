#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
cd "$DOTFILES"

"$DOTFILES/scripts/install-stow.sh"

stow common
stow linux
