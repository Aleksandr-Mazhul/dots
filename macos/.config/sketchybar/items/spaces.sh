#!/bin/bash

spaces_json="$(yabai -m query --spaces 2>/dev/null || echo "[]")"

printf '%s\n' "$spaces_json" | jq -r '.[] | "\(.index)\t\(.label // "")"' | while IFS=$'\t' read -r sid label; do
  [ -n "$sid" ] || continue
  label="${label#_}"

  sketchybar --add space space.$sid left \
    --set space.$sid \
    space=$sid \
    icon="$label" \
    label="" \
    label.font="sketchybar-app-font:Regular:16.0,JetBrainsMono Nerd Font Mono:Regular:16.0" \
    label.padding_right=20 \
    label.y_offset=-1 \
    click_script="yabai -m space --focus $sid" \
    script="$PLUGIN_DIR/space.sh"
done

# hidden worker item for events
sketchybar --add item space_windows_worker left \
  --set space_windows_worker drawing=off \
  script="$PLUGIN_DIR/space_windows.sh" \
  --subscribe space_windows_worker space_windows_change
