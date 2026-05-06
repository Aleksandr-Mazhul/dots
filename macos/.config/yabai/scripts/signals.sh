#!/usr/bin/env bash

# signals.sh - Yabai event signal handlers
# Defines event-driven behaviors for window focus, application launch, etc.

set -e

yabai -m signal --remove 2>/dev/null || true

# Signal: Update bar when window focus changes
yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus 2>/dev/null || true" 2>/dev/null || true

# Signal: Track mouse position changes (optional - helps with window focus)
# Disabled by default to prevent cursor jumps
# yabai -m signal --add event=window_focused action="cliclick m:0,0" 2>/dev/null || true

# Signal: Refresh when a window is created
yabai -m signal --add event=window_created action="sketchybar --trigger window_focus 2>/dev/null || true" 2>/dev/null || true

# Signal: Follow newly created managed window to its space
# Signal: Follow newly created window to its space
yabai -m signal --add event=window_created action='
WINDOW_JSON=$(yabai -m query --windows --window "$YABAI_WINDOW_ID" 2>/dev/null) || exit 0

APP=$(echo "$WINDOW_JSON" | jq -r ".app")
FLOATING=$(echo "$WINDOW_JSON" | jq -r ".\"is-floating\"")
ROLE=$(echo "$WINDOW_JSON" | jq -r ".role")
SUBROLE=$(echo "$WINDOW_JSON" | jq -r ".subrole")
SPACE=$(echo "$WINDOW_JSON" | jq -r ".space")

FOLLOW=false

# normal managed windows
if [[ "$FLOATING" == "false" && "$ROLE" == "AXWindow" && "$SUBROLE" == "AXStandardWindow" ]]; then
  FOLLOW=true
fi

# floating apps we still want to follow
if [[ "$APP" =~ ^(Books|Weather|Wolfram)$ ]]; then
  FOLLOW=true
fi

if [[ "$FOLLOW" == "true" ]]; then
  yabai -m space --focus "$SPACE"
  yabai -m window "$YABAI_WINDOW_ID" --focus
fi
' 2>/dev/null || true

# Signal: Ensure new windows respect sublayer rules

# Signal: Handle Mission Control enter (restore full opacity)
yabai -m signal --add event=mission_control_enter action="yabai -m config normal_window_opacity 1.0" 2>/dev/null || true

# Signal: Handle Mission Control exit (restore active opacity)
yabai -m signal --add event=mission_control_exit action="yabai -m config active_window_opacity 1.0" 2>/dev/null || true

# Signal: Refresh on dock restart (yabai may need SA reload)

# Signal: Handle display add/remove events
yabai -m signal --add event=display_added action="sleep 0.5 && sketchybar --trigger display_change 2>/dev/null || true" 2>/dev/null || true
yabai -m signal --add event=display_removed action="sleep 0.5 && sketchybar --trigger display_change 2>/dev/null || true" 2>/dev/null || true

exit 0
