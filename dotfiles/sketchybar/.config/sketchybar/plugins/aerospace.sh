#!/bin/bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$PLUGIN_DIR")"
source "$CONFIG_DIR/colors.sh"

# Determine focused workspace
if [ -n "$FOCUSED" ]; then
  FOCUSED_WS="$FOCUSED"
else
  FOCUSED_WS=$(aerospace list-workspaces --focused)
fi

OCCUPIED=$(aerospace list-workspaces --monitor all --empty no)
ALL_SPACES=$(aerospace list-workspaces --all)

# Gather app icons
while IFS='|' read -r sid app_name; do
  if [ -n "$app_name" ]; then
    icon=$("$PLUGIN_DIR/icon_map.sh" "$app_name")
    current=$(eval echo "\$ICONS_$sid")
    if [[ "$current" != *"$icon"* ]]; then
      eval "ICONS_$sid+=\" $icon\""
    fi
  fi
done < <(aerospace list-windows --all --format '%{workspace}|%{app-name}')

ARGS=()

for sid in $ALL_SPACES; do
  DRAWING="off"
  # Show occupied spaces or the focused space
  if echo "$OCCUPIED" | grep -q "^$sid$"; then DRAWING="on"; fi
  if [ "$sid" = "$FOCUSED_WS" ]; then DRAWING="on"; fi
  
  ICONS=$(eval echo "\$ICONS_$sid")
  ICONS=$(echo "$ICONS" | xargs)

  # Update workspace name (space.$sid)
  if [ "$sid" = "$FOCUSED_WS" ]; then
    # Active: Chữ màu đỏ
    ICON_COLOR=$RED
  else
    # Inactive: Chữ màu xám
    ICON_COLOR=0x90ffffff
  fi
  
  ARGS+=(--animate tanh 10 \
         --set space.$sid \
         drawing=$DRAWING \
         icon.color=$ICON_COLOR)
  
  # Update app icons (space.$sid.apps)
  # CHỈ hiển thị app icons cho workspace ACTIVE
  if [ "$sid" = "$FOCUSED_WS" ] && [ -n "$ICONS" ]; then
    # Active workspace có apps: Hiển thị với background trắng
    ARGS+=(--set space.$sid.apps \
           drawing=on \
           label="$ICONS" \
           label.color=$WHITE \
           background.drawing=on)
  else
    # Inactive workspace hoặc không có apps: Ẩn hoàn toàn
    ARGS+=(--set space.$sid.apps drawing=off)
  fi
done

sketchybar "${ARGS[@]}"
