#!/bin/bash

source "$CONFIG_DIR/colors.sh"

WS="$1"

FOCUSED="$(aerospace list-workspaces --focused)"

WINDOWS="$(aerospace list-windows --workspace "$WS")"

# если workspace пустой
if [ -z "$WINDOWS" ]; then
  sketchybar --set "$NAME" drawing=off
  exit
fi

ICONS=""

while IFS='|' read -r wid app rest
do
  app=$(echo "$app" | xargs)
  icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
  ICONS="$ICONS $icon"
done <<< "$WINDOWS"

if [ "$WS" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" \
    drawing=on \
    label="$ICONS" \
    label.drawing=on \
    background.drawing=on \
    background.color=$ACCENT_COLOR \
    icon.color=$BAR_COLOR \
    label.color=$BAR_COLOR
else
  sketchybar --set "$NAME" \
    drawing=on \
    label="$ICONS" \
    label.drawing=on \
    background.drawing=off \
    icon.color=$ACCENT_COLOR \
    label.color=$ACCENT_COLOR
fi