#!/usr/bin/env bash

# opacity.sh - Window opacity configuration
# Manages focused/unfocused window transparency

set -e

# Configuration
ACTIVE_OPACITY=1.0          # Fully opaque
INACTIVE_OPACITY=0.90       # Slightly transparent
OPACITY_ENABLED=false       # Set to true to enable transparency effects

# Enable/disable opacity
if $OPACITY_ENABLED; then
  yabai -m config window_opacity on
else
  yabai -m config window_opacity off
fi

# Set default opacities
yabai -m config active_window_opacity "$ACTIVE_OPACITY"
yabai -m config normal_window_opacity "$INACTIVE_OPACITY"
yabai -m config window_opacity_duration 0.0

# Optional: Apply opacity to specific apps (currently disabled)
# Apps to make transparent (e.g., terminals, editors)
# declare -a TRANSPARENT_APPS=("Neovide" "Code")
# for app in "${TRANSPARENT_APPS[@]}"; do
#   yabai -m rule --add app="^$app$" opacity=0.87
# done

exit 0
