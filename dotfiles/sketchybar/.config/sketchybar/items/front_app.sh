#!/bin/bash

sketchybar --add item front_app left \
           --set front_app \
                display=all \
                script="$PLUGIN_DIR/front_app.sh" \
                click_script="$PLUGIN_DIR/front_app_click.sh" \
                icon.font="sketchybar-app-font:Regular:16.0" \
                icon.drawing=on \
                icon.padding_left=12 \
                icon.padding_right=8 \
                label.font="$FONT:Black:12.0" \
                label.drawing=on \
                label.padding_right=12 \
                background.height=26 \
                background.corner_radius=10 \
                background.padding_right=10 \
                drawing=on \
                updates=on \
                label="Initializing..." \
           --subscribe front_app front_app_switched
