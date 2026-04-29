#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

echo "🔄 Updating macOS dotfiles..."
echo ""

echo "1️⃣  Pulling latest from GitHub..."
cd "$DOTFILES"
git pull --rebase --autostash

echo ""
echo "2️⃣  Updating Homebrew packages..."
brew update
brew upgrade
brew bundle --file="$DOTFILES/common/Brewfile"
brew cleanup

echo ""
echo "3️⃣  Syncing dotfiles..."
bash "$DOTFILES/scripts/sync.sh"

echo ""
echo "4️⃣  Validating SSH keys..."
for key in ~/.ssh/id_*[^.pub]; do
  if [ -f "$key" ]; then
    perms=$(stat -f %A "$key")
    if [ "$perms" != "600" ]; then
      echo "⚠️  SSH key $key has permissions $perms (should be 600)"
      chmod 600 "$key"
      echo "✅ Fixed: $key"
    fi
  fi
done

echo ""
echo "✅ Update complete!"
echo ""
echo "Summary:"
echo "  ✓ Git pulled"
echo "  ✓ Brew updated"
echo "  ✓ Dotfiles synced"
echo "  ✓ SSH keys validated"
