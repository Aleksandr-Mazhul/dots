#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
HOST_PACKAGE="${HOST_PACKAGE:-$(hostname -s)}"
cd "$DOTFILES"

echo "📡 Pulling latest changes..."
git pull --rebase --autostash

echo "🔄 Re-stowing packages..."
stow -R common

case "$(uname -s)" in
  Darwin)
    stow -R macos
    ;;
  Linux)
    stow -R linux
    ;;
esac

if [ -d "$DOTFILES/hosts/$HOST_PACKAGE" ]; then
  stow -R -d hosts -t "$HOME" "$HOST_PACKAGE"
else
  echo "ℹ️  Host package hosts/$HOST_PACKAGE not found. Skipping host overrides."
fi

echo "✅ Sync complete!"
