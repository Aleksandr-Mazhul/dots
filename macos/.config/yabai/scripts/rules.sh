#!/usr/bin/env bash

# rules.sh - Application window management rules
# Defines window rules, app-to-workspace mappings, and special handling

set -e

yabai -m rule --remove 2>/dev/null || true

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
  "Preview"
  "Calculator"
  "Image Capture"
  "Audio MIDI Setup"
  "Migration Assistant"
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
  yabai -m rule --add app="^System Preferences$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^System Settings$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^1Password$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Raycast$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Alfred$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Bezel$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Windscribe$" manage=off sticky=off layer=above 2>/dev/null || true
  yabai -m rule --add app="^Bartender$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Activity Monitor$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Directory Utility$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^App Store$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Preview$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Calculator$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Image Capture$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Audio MIDI Setup$" manage=off sticky=off layer=normal 2>/dev/null || true
  yabai -m rule --add app="^Migration Assistant$" manage=off sticky=off layer=normal 2>/dev/null || true
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

# Float transient dialogs / modal windows
apply_dialog_rules() {
  yabai -m rule --add title="^(Open|Save|Save As|Export|Import|Preferences|Settings)$" manage=off 2>/dev/null || true
  yabai -m rule --add title=".*(Preferences|Settings|Inspector).*" manage=off 2>/dev/null || true
  yabai -m rule --add title="^(Quick Look)$" manage=off 2>/dev/null || true
  yabai -m rule --add title=".*(Authentication|Login|Sign In).*" manage=off 2>/dev/null || true
}

# Main execution
apply_general_rules
apply_unmanaged_rules
apply_windscribe_rules
apply_dialog_rules
apply_workspace_rules

exit 0
