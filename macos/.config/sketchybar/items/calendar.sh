#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon=<U+1009DE>  \
                          update_freq=1 \
                          script="$PLUGIN_DIR/calendar.sh"