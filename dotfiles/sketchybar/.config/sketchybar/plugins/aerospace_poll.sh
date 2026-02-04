#!/bin/bash

# Poll aerospace for workspace changes
LAST_WORKSPACE=""
SCRIPT_DIR="$HOME/.config/sketchybar/plugins"

echo "$(date): Polling script started" >> /tmp/aerospace_poll.log

while true; do
    CURRENT=$(aerospace list-workspaces --focused 2>/dev/null)
    
    if [ -n "$CURRENT" ] && [ "$CURRENT" != "$LAST_WORKSPACE" ]; then
        echo "$(date): Workspace changed from '$LAST_WORKSPACE' to '$CURRENT'" >> /tmp/aerospace_poll.log
        LAST_WORKSPACE="$CURRENT"
        # Call aerospace.sh directly with FOCUSED env var
        FOCUSED="$CURRENT" "$SCRIPT_DIR/aerospace.sh"
        echo "$(date): Called aerospace.sh with FOCUSED=$CURRENT" >> /tmp/aerospace_poll.log
    fi
    
    sleep 0.1
done
