#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
cd "$DOTFILES"

git pull --rebase --autostash

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
