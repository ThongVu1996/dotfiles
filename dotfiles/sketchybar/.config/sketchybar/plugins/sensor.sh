#!/bin/bash

# Getting CPU Temp on Apple Silicon usually requires 'sudo powermetrics' or third-party tools like 'osx-cpu-temp'.
# For now, we will display a logical placeholder if no tool is found.

TEMP_LABEL="40°"

# Check if osx-cpu-temp is installed (some users might have it)
if command -v osx-cpu-temp &> /dev/null; then
  TEMP_VAL=$(osx-cpu-temp)
  TEMP_LABEL="${TEMP_VAL}"
fi

sketchybar --set $NAME label="$TEMP_LABEL"
