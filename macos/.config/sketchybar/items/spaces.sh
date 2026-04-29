#!/bin/bash

PLUGIN_DIR="$CONFIG_DIR/plugins"

WORKSPACES=(1 B C D E M P Q T U V W X Z N Y)

for ws in "${WORKSPACES[@]}"; do
  sketchybar --add item space.$ws left \
  --set space.$ws \
    icon="$ws" \
    label.font="sketchybar-app-font:Regular:16.0" \
    background.height=22 \
    background.corner_radius=6 \
    icon.y_offset=1 \
    icon.padding_left=8 \
    icon.padding_right=8 \
    update_freq=1 \
    script="$PLUGIN_DIR/space.sh $ws" \
    click_script="aerospace workspace $ws"
done
