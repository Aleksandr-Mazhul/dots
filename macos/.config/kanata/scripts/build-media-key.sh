#!/bin/bash
# Compile macos-media-key (NX_KEYTYPE helper used by Kanata on macOS).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/bin"
swiftc -O -framework AppKit -o "$ROOT/bin/macos-media-key" "$ROOT/scripts/macos-media-key.swift"
chmod 755 "$ROOT/bin/macos-media-key"
echo "built $ROOT/bin/macos-media-key"
