#!/bin/bash

# A separator/toggle button that sits between the stats and the right-side control center items
toggle=(
  icon=􀆊
  icon.font="$FONT:Bold:15.0"
  icon.color=0xffffffff
  label.drawing=off
  padding_right=15
  padding_left=10
  click_script="$PLUGIN_DIR/toggle_stats.sh"
)

sketchybar --add item stats.separator right       \
           --set stats.separator "${toggle[@]}"
