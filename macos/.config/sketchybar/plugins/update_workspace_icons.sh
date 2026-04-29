#!/bin/bash

# Event-driven workspace update triggered by aerospace events
# Called when workspace changes or windows change

SID="$1"

if [ -z "$SID" ]; then
  # If no workspace specified, update all (fallback)
  for sid in $(aerospace list-workspaces --all); do
    update_workspace "$sid"
  done
else
  update_workspace "$SID"
fi

update_workspace() {
  local ws_id="$1"
  local apps=$(aerospace list-windows --workspace "$ws_id" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
  local icon_strip=""

  if [ "${apps}" != "" ]; then
    while read -r app; do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"${apps}"
  fi

  sketchybar --set space.$ws_id label="$icon_strip"
}