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
  ["Arc"]="V"
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
  for app in "${APPS_UNMANAGED[@]}"; do
    yabai -m rule --add app="^${app}$" manage=off sticky=off 2>/dev/null || true
  done
}

# Apply general rules for all managed windows
# Float transient dialogs / modal windows
apply_dialog_rules() {
  yabai -m rule --add title="^(Open|Save|Save As|Export|Import|Preferences|Settings)$" manage=off 2>/dev/null || true
  yabai -m rule --add title=".*(Preferences|Settings|Inspector).*" manage=off 2>/dev/null || true
  yabai -m rule --add title="^(Quick Look)$" manage=off 2>/dev/null || true
  yabai -m rule --add title=".*(Authentication|Login|Sign In).*" manage=off 2>/dev/null || true
}

# Apply JetBrains dialog float rules
# Apply JetBrains dialog float rules
apply_jetbrains_rules() {
  local jetbrains_apps='^(CLion|WebStorm|IntelliJ IDEA|PyCharm|GoLand|Rider|RubyMine|PhpStorm|DataGrip|DataSpell|AppCode|RustRover|Aqua|JetBrains Toolbox)$'

  local dialogs=(
    Rename
    Delete
    Move
    Copy
    Find
    "Find in Files"
    Replace
    "Replace in Files"
    Commit
    Settings
    Preferences
    "Project Structure"
    Plugins
    "Run/Debug Configurations"
    "Edit Configurations"
    "Safe Delete"
    Refactor
    "Refactor This"
    "New File"
    "New Directory"
    "New Scratch File"
    "Open Project"
    "Select Path"
    "Attach Directory"
    "Invalidate Caches"
    Terminal
    Keymap
    Appearance
    "Color Scheme"
    "New C++ Class"
  )
}

#Main execution
apply_unmanaged_rules
apply_dialog_rules
apply_jetbrains_rules
apply_workspace_rules

exit 0
