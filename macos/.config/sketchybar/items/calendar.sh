#!/bin/bash

# Display system time directly from macOS menu bar
# No scripts, no polling, zero SketchyBar overhead
# System updates time automatically

sketchybar --add alias "Control Center,NSClockMenulet" right \
           --set "Control Center,NSClockMenulet" \
                 icon=􀧞