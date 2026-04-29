#!/bin/bash

sketchybar --add item volume right \
           --set volume update_freq=0 \
                        script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change \