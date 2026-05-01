#!/usr/bin/env bash

set -e

yabai -m rule --remove 2>/dev/null || true

# =============================================================================
# Constants
# =============================================================================

# App -> workspace mapping
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

# Apps unmanaged by yabai
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

# JetBrains family
JETBRAINS_APPS='^(CLion|WebStorm|IntelliJ IDEA|PyCharm|GoLand|Rider|RubyMine|PhpStorm|DataGrip|DataSpell|AppCode|RustRover|Aqua|JetBrains Toolbox)$'

# JetBrains windows that should float
declare -a JETBRAINS_FLOAT_PATTERNS=(
  # basic actions
  '^Rename$'
  '^Delete$'
  '^Move$'
  '^Copy$'
  '^Find.*'
  '^Replace.*'
  '^Commit.*'

  # settings / config
  '^Settings$'
  '^Keyboard Shortcut$'
  '^Preferences$'
  '^Project Structure$'
  '^Plugins$'
  '^Terminal$'
  '^Keymap$'
  '^Appearance$'
  '^Color Scheme$'
  '^Code Style.*'
  '^Inspection.*'
  '^Scopes$'
  '^Templates.*'
  '^Live Templates.*'
  '^File Types$'
  '^Plugins.*'
  '^SDKs$'
  '^Project SDK.*'

  # plugin / update / notification / errors
  '.*Plugin.*'
  '.*Update.*'
  '^IDE .*'
  '.*Error.*'
  '.*Warning.*'
  '^Notifications$'

  # create / open / import
  '^New .*'
  '^Open .*'
  '^Create .*'
  '^Select .*'
  '^Choose .*'
  '^Attach .*'
  '^Register .*'
  '^Import .*'
  '^Export .*'
  '^Invalidate .*'

  # refactor / run / debug
  '^Refactor.*'
  '^Safe Delete.*'
  '^Run.*'
  '^Debug.*'
  '^Edit .*'

  # code generation
  '^Generate.*'
  '^Override.*'
  '^Implement.*'

  # extended file ops
  '^Rename .*'
  '^Move .*'
  '^Copy .*'
  '^Delete .*'

  # git
  '^Git .*'
  '^Merge.*'
  '^Rebase.*'
  '^Cherry-Pick.*'
  '^Push.*'
  '^Pull.*'

  # navigation
  '^Search Everywhere$'
  '^Go to .*'
)

# =============================================================================
# Rules
# =============================================================================

apply_workspace_rules() {
  for app in "${!APP_WORKSPACE[@]}"; do
    yabai -m rule --add \
      app="^${app}$" \
      space="${APP_WORKSPACE[$app]}" 2>/dev/null || true
  done
}

apply_unmanaged_rules() {
  for app in "${APPS_UNMANAGED[@]}"; do
    yabai -m rule --add \
      app="^${app}$" \
      manage=off \
      sticky=off 2>/dev/null || true
  done
}

apply_dialog_rules() {
  yabai -m rule --add title="^(Open|Save|Save As|Export|Import|Preferences|Settings)$" manage=off 2>/dev/null || true
  yabai -m rule --add title=".*(Preferences|Settings|Inspector).*" manage=off 2>/dev/null || true
  yabai -m rule --add title="^(Quick Look)$" manage=off 2>/dev/null || true
  yabai -m rule --add title=".*(Authentication|Login|Sign In).*" manage=off 2>/dev/null || true
}

apply_jetbrains_rules() {
  for pattern in "${JETBRAINS_FLOAT_PATTERNS[@]}"; do
    yabai -m rule --add \
      app="$JETBRAINS_APPS" \
      title="$pattern" \
      manage=off 2>/dev/null || true
  done
}

# =============================================================================
# Main
# =============================================================================

apply_unmanaged_rules
apply_dialog_rules
apply_jetbrains_rules
apply_workspace_rules

exit 0
