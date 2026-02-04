#!/bin/bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  # Icon slot will hold the Percentage TEXT -> Use Text Font
  icon.font="$FONT:Heavy:12"
  icon.padding_right=0
  icon.color=0xffffffff
  
  # Label slot will hold the Battery ICON -> Use Icon Font
  label.font="$FONT:Regular:19.0"
  label.padding_left=4
  
  padding_right=15
  padding_left=0
  width=80
  update_freq=120
  updates=on
)

sketchybar --add item battery right      \
           --set battery "${battery[@]}" \
           --subscribe battery system_woke power_source_change
