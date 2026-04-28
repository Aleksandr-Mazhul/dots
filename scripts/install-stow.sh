#!/usr/bin/env bash
set -euo pipefail

if command -v stow >/dev/null 2>&1; then
  exit 0
fi

OS="$(uname -s)"
case "$OS" in
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew is required to install stow on macOS."
      exit 1
    fi
    brew install stow
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y stow
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y stow
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm stow
    else
      echo "Install stow manually for this distro."
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac
