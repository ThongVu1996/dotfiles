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
    # In Rio, we send Tmux prefix (Ctrl+A), sleep briefly, then the key
    $SKHD_BIN -k "ctrl - a"
    sleep 0.05
    $SKHD_BIN -k "$TMUX_KEY"
else
    # In other apps, send the fallback key (if provided)
    if [[ -n "$FALLBACK_KEY" ]]; then
        $SKHD_BIN -k "$FALLBACK_KEY"
    fi
fi