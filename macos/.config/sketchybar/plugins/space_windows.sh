#!/bin/bash

if [ "$SENDER" = "space_windows_change" ]; then
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]?')"

  if [ -n "$apps" ]; then
    icon_strip=" "

    while read -r app
    do
      [ -z "$app" ] && continue
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<< "$apps"

    sketchybar --set "space.$space" drawing=on label="$icon_strip"
  else
    sketchybar --set "space.$space" drawing=off
  fi
fi
