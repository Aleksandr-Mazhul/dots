#!/usr/bin/env bash
set -euo pipefail

SPACE="$1"
WID="$(yabai -m query --windows --window | jq -r '.id')"

[ -n "$WID" ] || exit 1

yabai -m window --space "$SPACE"
yabai -m space --focus "$SPACE"
sleep 0.05
yabai -m window --focus "$WID"
