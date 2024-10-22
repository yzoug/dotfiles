#!/usr/bin/env bash
# Lockscreen to use with Sway, one or many monitors, imagemagick, jq and Swaylock
# Will screenshot the laptop monitor and only that monitor, then scales down the image
# The image is scaled back up: pixels have been lost which gives a blur effect
# zoug
#

LAPTOP_MONITOR_NAME="eDP-1"

# Temporary files to screenshot and resized images
TEMP_BASE=$(mktemp -t lockscreen_img_XXXXXXXX.png)
TEMP_SMALL=$(mktemp -t lockscreen_img_XXXXXXXX.png)
TEMP_FINAL=$(mktemp -t lockscreen_img_XXXXXXXX.png)

# Get first monitor (laptop monitor) mode
MODE_LAPTOP_MONITOR=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"${LAPTOP_MONITOR_NAME}\").current_mode | \"\(.width)x\(.height)\"")
POSITION_LAPTOP_MONITOR=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"${LAPTOP_MONITOR_NAME}\").rect | \"\(.x),\(.y)\"")

# Take screenshot
grim -g "${POSITION_LAPTOP_MONITOR} ${MODE_LAPTOP_MONITOR}" ${TEMP_BASE}

# Shrink it down
magick convert -resize 10% ${TEMP_BASE} ${TEMP_SMALL}
# Then back up
magick convert -resize 1000% ${TEMP_SMALL} ${TEMP_FINAL}

# Apply lockscreen
swaylock -f -i ${TEMP_FINAL}

# Cleanup
rm ${TEMP_SMALL} ${TEMP_BASE} ${TEMP_FINAL}
