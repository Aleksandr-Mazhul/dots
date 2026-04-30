#!/bin/bash

SPACE_SIDS=($(yabai -m query --spaces | jq -r '.[] | select(."has-focus" or (.windows | length) > 0) | .index'))

for sid in "${SPACE_SIDS[@]}"
do
  label="$(yabai -m query --spaces | jq -r ".[] | select(.index==$sid) | .label")"
  label="${label#_}"

  sketchybar --add space space.$sid left \
             --set space.$sid space=$sid \
                              icon="$label" \
                              label.font="sketchybar-app-font:Regular:16.0" \
                              label.padding_right=20 \
                              label.y_offset=-1 \
                              script="$PLUGIN_DIR/space.sh"
done

sketchybar --add item space_separator left \
           --set space_separator icon="􀆊" \
                                 icon.color=$ACCENT_COLOR \
                                 icon.padding_left=4 \
                                 label.drawing=off \
                                 background.drawing=off \
                                 script="$PLUGIN_DIR/space_windows.sh" \
           --subscribe space_separator space_windows_change
