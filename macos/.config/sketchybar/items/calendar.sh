#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon=􀧞 \
                          update_freq=1 \
                          script="$CONFIG_DIR/plugins/calendar.sh"