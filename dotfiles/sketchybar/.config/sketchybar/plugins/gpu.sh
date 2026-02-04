#!/bin/bash

# Getting GPU usage on Apple Silicon usually requires 'sudo powermetrics' which is hard to run here.
# For now, we will display a placeholder or 0% until a better method (like a helper tool) is added.
# Alternatively, checking 'ioreg' might give some info but it's complex to parse.

GPU_LABEL="0%"

# Placeholder logic: Randomize slightly for "alive" look during demo if real data unavailable
# Uncomment below to see it change:
# GPU_VAL=$((1 + $RANDOM % 10))
# GPU_LABEL="${GPU_VAL}%"

sketchybar --set $NAME label="$GPU_LABEL"
