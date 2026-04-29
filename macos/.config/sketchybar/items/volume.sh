#!/bin/bash

sketchybar --add item volume right \
           --set volume update_freq=0 \
                        script="$CONFIG_DIR/plugins/volume.sh" \
           --subscribe volume volume_change \