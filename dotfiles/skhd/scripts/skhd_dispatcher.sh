#!/usr/bin/env bash
# skhd contextual dispatcher
# Usage: ./skhd_dispatcher.sh <tmux_key> <fallback_key>
# Example: ./skhd_dispatcher.sh "s" "cmd - s"

TMUX_KEY=$1
FALLBACK_KEY=$2

ACTIVE_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

echo "$(date) - Triggered with TMUX_KEY=$TMUX_KEY, FALLBACK=$FALLBACK_KEY, APP=$ACTIVE_APP" >> /tmp/skhd_dispatcher.log

SKHD_BIN="/etc/profiles/per-user/thongvu/bin/skhd"

if [[ "${ACTIVE_APP,,}" == "rio" ]]; then
    # Check if we are attached to a Tmux session
    if tmux display-message -p '#{session_name}' &>/dev/null; then
        # In Tmux: Send Prefix + Key (for Popup)
        $SKHD_BIN -k "ctrl - a"
        sleep 0.05
        $SKHD_BIN -k "$TMUX_KEY"
    else
        # Outside Tmux in Rio: Handle keys directly
        if [[ "$TMUX_KEY" == "t" ]]; then
            # We simulate typing 'tv sesh' into the terminal
            # First send Ctrl+C to clear any current line, then the command
            $SKHD_BIN -k "ctrl - c"
            sleep 0.05
            # Type 'tv sesh' and Enter
            # Note: We use -t for 'text' if supported, otherwise individual keys
            $SKHD_BIN -t "tv sesh"
            $SKHD_BIN -k "return"
        else
            # Fallback for other keys when outside Tmux
            if [[ -n "$FALLBACK_KEY" ]]; then
                $SKHD_BIN -k "$FALLBACK_KEY"
            fi
        fi
    fi
else
    # In other apps, send the fallback key (if provided)
    if [[ -n "$FALLBACK_KEY" ]]; then
        $SKHD_BIN -k "$FALLBACK_KEY"
    fi
fi