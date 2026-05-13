#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
HOST_PACKAGE="${HOST_PACKAGE:-$(hostname -s)}"
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
if [ -d "$DOTFILES/hosts/$HOST_PACKAGE" ]; then
  stow -d hosts -t "$HOME" "$HOST_PACKAGE"
else
  echo "ℹ️  Host package hosts/$HOST_PACKAGE not found. Skipping host overrides."
fi

echo "✅ Bootstrap complete! Your dotfiles are ready."
echo "   Source your shell: exec $SHELL"
