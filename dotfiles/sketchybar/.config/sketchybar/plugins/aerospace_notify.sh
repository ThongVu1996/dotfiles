#!/bin/bash
echo "$(date): Wrapper called with AEROSPACE_FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE" >> /tmp/aerospace_wrapper.log
sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE
