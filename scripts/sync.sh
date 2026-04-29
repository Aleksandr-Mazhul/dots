#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
cd "$DOTFILES"

echo "📡 Pulling latest changes..."
git pull --rebase --autostash

echo "🔄 Re-stowing packages..."
stow -R common

case "$(uname -s)" in
  Darwin)
    stow -R macos
    stow -R hosts/macbook
    ;;
  Linux)
    stow -R linux
    ;;
esac

echo "✅ Sync complete!"
