#!/usr/bin/env bash

# rules.sh - Application window management rules
# Defines window rules, app-to-workspace mappings, and special handling

set -e

# App to workspace mapping (AeroSpace-like)
declare -A APP_WORKSPACE=(
  ["WebStorm"]="W"
  ["CLion"]="C"
  ["Mail"]="M"
  ["WezTerm"]="Z"
  ["Google Chrome"]="V"
  ["Brave Browser"]="V"
  ["Safari"]="V"
  ["Finder"]="E"
  ["Telegram"]="T"
  ["Spotify"]="U"
  ["Yandex"]="B"
  ["zoom.us"]="Y"
  ["Discord"]="D"
  ["Wolfram Mathematica"]="Q"
  ["Preview"]="P"
  ["Notes"]="N"
  ["ChatGPT"]="X"
)

# Apps that should not be managed by yabai
declare -a APPS_UNMANAGED=(
  "System Preferences"
  "System Settings"
  "1Password"
  "Raycast"
  "Alfred"
  "Bezel"
  "Windscribe"
  "Bartender"
  "Activity Monitor"
  "Directory Utility"
  "App Store"
)

# Apply workspace assignment rules
apply_workspace_rules() {
  for app in "${!APP_WORKSPACE[@]}"; do
    local workspace="${APP_WORKSPACE[$app]}"
    yabai -m rule --add app="^$app$" space="$workspace" 2>/dev/null || true
  done
}

# Apply unmanaged app rules (manage=off)
apply_unmanaged_rules() {
  for app in "${APPS_UNMANAGED[@]}"; do
    yabai -m rule --add app="^$app$" manage=off layer=above 2>/dev/null || true
  done
}

# Apply Windscribe special rules
apply_windscribe_rules() {
  yabai -m rule --add app="^Windscribe$" manage=off sticky=off layer=above 2>/dev/null || true
}

# Apply general rules for all managed windows
apply_general_rules() {
  # All windows start on normal sublayer
  yabai -m rule --add app=".*" sub-layer=normal 2>/dev/null || true
}

# Main execution
apply_general_rules
apply_unmanaged_rules
apply_windscribe_rules
apply_workspace_rules

exit 0
