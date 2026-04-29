#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
cd "$DOTFILES"

echo "📦 Installing GNU Stow..."
"$DOTFILES/scripts/install-stow.sh"

echo "📥 Installing Homebrew packages..."
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/common/Brewfile"
else
  echo "⚠️  Homebrew not found. Skipping brew bundle."
fi

echo "🔗 Creating symlinks with GNU Stow..."
stow common
stow macos
stow hosts/macbook

echo "✅ Bootstrap complete! Your dotfiles are ready."
echo "   Source your shell: exec $SHELL"
