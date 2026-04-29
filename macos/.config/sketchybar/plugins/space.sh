#!/bin/bash

source "$CONFIG_DIR/colors.sh"

WS="$1"

FOCUSED="$(aerospace list-workspaces --focused)"

# Check if called due to event or regular update
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Event-driven update - full workspace refresh
  "$CONFIG_DIR/plugins/update_workspace_icons.sh" "$WS"
else
  # Fallback: show focused indicator
  if [ "$WS" = "$FOCUSED" ]; then
    sketchybar --set "space.$WS" background.drawing=on
  else
    sketchybar --set "space.$WS" background.drawing=off
  fi
fi