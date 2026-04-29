#!/bin/bash

for sid in $(aerospace list-workspaces --all); do

  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  icon_strip=""

  if [ "${apps}" != "" ]; then
    while read -r app; do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"${apps}"
  fi

  sketchybar --set space.$sid label="$icon_strip"

done