#!/usr/bin/env bash

# spaces.sh - Workspace label management and validation
# Manages yabai space labels with AeroSpace-like naming

set -e

# Workspace mapping (yabai only supports letter labels, so "1" is mapped to "_1")
declare -A WORKSPACE_MAP=(
  [W]=1
  [C]=2
  [V]=3
  [D]=4
  [G]=5
  [X]=6
  [Z]=7
  [E]=8
  [T]=9
  [I]=10
  [P]=11
  [Q]=12
  [U]=13
  [Y]=14
  [R]=15
  [A]=16
)

# Initialize all workspace labels
init_workspaces() {
  local display_id="$1"

  for label in "${!WORKSPACE_MAP[@]}"; do
    local index="${WORKSPACE_MAP[$label]}"
    current=$(yabai -m query --spaces | jq 'length')
    if [[ "$current" -lt "$index" ]]; then
      yabai -m space --create 2>/dev/null || true
    fi
  done

  # Label the spaces
  for label in "${!WORKSPACE_MAP[@]}"; do
    local index="${WORKSPACE_MAP[$label]}"
    yabai -m space "$index" --label "$label" 2>/dev/null || true
  done
}

# Validate workspace configuration
validate_workspaces() {
  local spaces_json
  spaces_json=$(yabai -m query --spaces 2>/dev/null || echo "[]")

  # Check for duplicates
  local labels
  labels=$(echo "$spaces_json" | jq -r '.[].label' | sort)
  local unique_count
  unique_count=$(echo "$labels" | wc -l)
  local duplicate_count
  duplicate_count=$(echo "$labels" | sort -u | wc -l)

  if [[ "$unique_count" -ne "$duplicate_count" ]]; then
    echo "WARNING: Duplicate space labels detected" >&2
    return 1
  fi

  # Check for sticky windows (should be none)
  local sticky_windows
  sticky_windows=$(yabai -m query --windows 2>/dev/null | jq '[.[] | select(.sticky == 1)] | length' || echo "0")
  if [[ "$sticky_windows" -gt 0 ]]; then
    echo "WARNING: $sticky_windows sticky windows detected (should be 0)" >&2
    return 1
  fi

  return 0
}

# Get workspace label by index
get_workspace_label() {
  local index="$1"
  yabai -m query --spaces | jq -r ".[] | select(.index == $index) | .label" 2>/dev/null || echo ""
}

# Get workspace index by label
get_workspace_index() {
  local label="$1"
  yabai -m query --spaces | jq ".[] | select(.label == \"$label\") | .index" 2>/dev/null || echo ""
}

# Focus workspace by label
focus_workspace() {
  local label="$1"
  local index
  index=$(get_workspace_index "$label")
  if [[ -n "$index" ]]; then
    yabai -m space --focus "$index"
  else
    echo "Workspace not found: $label" >&2
    return 1
  fi
}

# Move window to workspace by label
move_window_to_workspace() {
  local window_id="$1"
  local label="$2"
  local space_index
  space_index=$(get_workspace_index "$label")

  if [[ -z "$space_index" ]]; then
    echo "Workspace not found: $label" >&2
    return 1
  fi

  yabai -m window "$window_id" --space "$space_index"
}

# Main
case "$1" in
init)
  init_workspaces "${2:-}"
  ;;
validate)
  validate_workspaces
  ;;
get-label)
  get_workspace_label "$2"
  ;;
get-index)
  get_workspace_index "$2"
  ;;
focus)
  focus_workspace "$2"
  ;;
move)
  move_window_to_workspace "$2" "$3"
  ;;
*)
  echo "Usage: $0 {init|validate|get-label|get-index|focus|move} [args...]"
  exit 1
  ;;
esac
