#!/usr/bin/env bash

# query.sh - Helper CLI for querying yabai state
# Provides clean, formatted output for debugging and status checks

set -e

# Helper functions
query_windows() {
  yabai -m query --windows | jq '
    .[] | {
      id,
      app: .app,
      title: .title,
      space: .space,
      focused: .focused,
      sticky: .sticky,
      floating: .floating,
      layer: .layer,
      "sub-layer": .["sub-layer"]
    }
  '
}

query_spaces() {
  yabai -m query --spaces | jq '
    .[] | {
      id,
      index,
      label,
      display,
      "window-count": (.windows | length),
      layout,
      "has-focus": .["has-focus"]
    }
  '
}

query_displays() {
  yabai -m query --displays | jq '
    .[] | {
      id,
      index,
      label,
      "space-count": (.spaces | length),
      spaces: .spaces,
      "has-focus": .["has-focus"]
    }
  '
}

query_rules() {
  yabai -m rule --list | jq '.'
}

query_sticky_windows() {
  yabai -m query --windows | jq '.[] | select(.sticky == 1) | {
    id,
    app,
    title,
    sticky
  }'
}

query_focused_window() {
  yabai -m query --windows | jq '.[] | select(.focused == 1) | {
    id,
    app,
    title,
    space,
    floating,
    layer
  }'
}

# Main dispatch
case "${1:-}" in
  windows)
    query_windows
    ;;
  spaces)
    query_spaces
    ;;
  displays)
    query_displays
    ;;
  rules)
    query_rules
    ;;
  sticky)
    query_sticky_windows
    ;;
  focused)
    query_focused_window
    ;;
  *)
    cat << EOF
Usage: $(basename "$0") <query-type>

Query types:
  windows    - List all windows with properties
  spaces     - List all workspaces
  displays   - List all displays
  rules      - List all window rules
  sticky     - List sticky windows (should be empty)
  focused    - Show focused window info

Examples:
  $(basename "$0") windows
  $(basename "$0") spaces
  $(basename "$0") sticky
EOF
    exit 1
    ;;
esac

exit 0
