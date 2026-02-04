#!/bin/bash

# Define items to toggle
ITEMS="cpu.percent gpu.percent ram.percent sensor.temp"

# Robust State Check System
# Instead of checking cpu.percent (which has confusing sub-properties like icon.drawing),
# We check the Toggle Button's own icon.
# 􀆉 = Left Arrow (Collapsed/Hidden)
# 􀆊 = Right Arrow (Expanded/Shown)

QUERY=$(sketchybar --query stats.separator)

if echo "$QUERY" | grep -q "􀆊"; then
  # Current is Right Arrow (EXPANDED) -> We want to HIDE
  echo "State: EXPANDED -> Hiding..."
  NEW_STATE="off"
  NEW_ICON="􀆉"
else
  # Current is Left Arrow (COLLAPSED) -> We want to SHOW
  echo "State: COLLAPSED -> Showing..."
  NEW_STATE="on"
  NEW_ICON="􀆊"
fi

# Build arguments
ARGS=()
ARGS+=(--set stats.separator icon=$NEW_ICON)

for item in $ITEMS; do
  ARGS+=(--set "$item" drawing="$NEW_STATE")
done

# Execute
sketchybar "${ARGS[@]}"