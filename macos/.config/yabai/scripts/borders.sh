#!/usr/bin/env bash

# borders.sh - Window border styling configuration
# Integrates with JankyBorders or other border tools (optional)

set -e

# Configuration
BORDERS_ENABLED=true       # Set to true to enable borders

if ! $BORDERS_ENABLED; then
  exit 0
fi

# Check if JankyBorders is installed
if command -v jankyborders &>/dev/null; then
  # Configure focused window border
  yabai -m signal --add event=window_focused action="
    jankyborders --color 0xFF61AFEF --width 5 &
  " 2>/dev/null || true
  
  # Configure unfocused window border (optional)
  yabai -m signal --add event=window_unfocused action="
    jankyborders --color 0xFF444B6A --width 2 &
  " 2>/dev/null || true
fi

# Alternative: Use SketchyBar for border integration if available
if command -v sketchybar &>/dev/null; then
  # SketchyBar can provide visual feedback via status bar
  # This is handled in signals.sh via window_focus trigger
  true
fi

exit 0
