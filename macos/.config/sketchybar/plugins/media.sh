#!/bin/bash

INFO="$(nowplaying-cli get --json title artist playbackRate 2>/dev/null)"

STATE="$(echo "$INFO" | jq -r '.playbackRate // 0')"

if [ "$STATE" = "1" ]; then
  TITLE="$(echo "$INFO" | jq -r '.title // ""')"
  ARTIST="$(echo "$INFO" | jq -r '.artist // ""')"

  MEDIA="$(printf "%s - %s" "$TITLE" "$ARTIST" | sed 's/^ - //; s/ - $//')"

  sketchybar --set "$NAME" label="$MEDIA" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
