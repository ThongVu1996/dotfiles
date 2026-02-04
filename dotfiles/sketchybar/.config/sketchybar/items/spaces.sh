#!/bin/bash

# Load colors
source "$CONFIG_DIR/colors.sh"

sketchybar --add event aerospace_workspace_change

WORKSPACES=$(aerospace list-workspaces --all)

# 1. Create the Listener (Hidden)
sketchybar --add item aerospace_listener left \
           --subscribe aerospace_listener aerospace_workspace_change \
           --set aerospace_listener \
           drawing=off \
           script="$CONFIG_DIR/plugins/aerospace.sh"

# 2. Create Workspace Items (chỉ hiển thị tên workspace)
for sid in $WORKSPACES; do
  # Workspace number/letter
  sketchybar --add item space.$sid left \
             --set space.$sid \
             icon="$sid" \
             icon.font="$FONT:Heavy:14.0" \
             icon.padding_left=10 \
             icon.padding_right=8 \
             label.drawing=off \
             background.drawing=off \
             drawing=off \
             click_script="aerospace workspace $sid"
  
  # App icons for this workspace (separate item)
  sketchybar --add item space.$sid.apps left \
             --set space.$sid.apps \
             icon.drawing=off \
             label.font="sketchybar-app-font:Regular:14.0" \
             label.padding_left=8 \
             label.padding_right=10 \
             label.y_offset=-1 \
             background.color=0x44ffffff \
             background.corner_radius=5 \
             background.height=24 \
             background.drawing=off \
             drawing=off
done

# 3. Create the Bracket (Container) - chỉ bao workspace names
sketchybar --add bracket spaces '/space\..*/' \
           --set spaces \
           background.color=0x25ffffff \
           background.corner_radius=7 \
           background.border_color=0x00000000 \
           background.border_width=0 \
           background.height=32

# 4. Separator
sketchybar --add item spaces.separator left \
           --set spaces.separator \
           icon="􀆊" \
           icon.font="$FONT:Heavy:16.0" \
           icon.padding_left=10 \
           icon.padding_right=10 \
           label.drawing=off \
           icon.color=0xffffffff \
           background.padding_left=5

# 5. Front App
sketchybar --add item front_app left \
           --set front_app \
           script="$PLUGIN_DIR/front_app.sh" \
           click_script="$PLUGIN_DIR/front_app_click.sh" \
           icon.font="sketchybar-app-font:Regular:16.0" \
           icon.color=$WHITE \
           icon.padding_left=12 \
           icon.padding_right=8 \
           label="Loading..." \
           label.font="$FONT:Black:12.0" \
           label.color=$WHITE \
           label.padding_right=12 \
           background.color=0x44ffffff \
           background.corner_radius=5 \
           background.height=26 \
           background.drawing=on \
           background.padding_left=5 \
           drawing=on \
           updates=on \
           --subscribe front_app front_app_switched

# Initial update
$PLUGIN_DIR/aerospace.sh
$PLUGIN_DIR/front_app.sh

# Start polling
pkill -f "aerospace_poll.sh" 2>/dev/null
$PLUGIN_DIR/aerospace_poll.sh &
