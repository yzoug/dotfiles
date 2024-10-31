#!/usr/bin/env bash
# Lockscreen to use with Sway, one or many monitors, imagemagick, jq and Swaylock
# Screenshots the specified monitor then scales down the image then back up
# Pixels have been lost which gives a blur effect
#
# The script does nothing if invoked by swayidle and a specified hardware monitor is connected: I don't need lockscreen at home.
#
# zoug
#

# Don't apply lockscreen if invoked by swayidle and I'm at home
# Enter a string identifier for your monitor
HOME_MONITOR_IDENTIFIER="PXMGC2ADAFLL"
if swaymsg -t get_outputs | grep ${HOME_MONITOR_IDENTIFIER} && [[ $(ps -o comm= $PPID) == "swayidle" ]]; then
    notify-send -u low "You're at home!" "Use keybinding to lock manually."
    exit 0
fi

# Temporary files to screenshot and resized images
TEMP_BASE=$(mktemp -t lockscreen_img_XXXXXXXX.png)
TEMP_SMALL=$(mktemp -t lockscreen_img_XXXXXXXX.png)
TEMP_FINAL=$(mktemp -t lockscreen_img_XXXXXXXX.png)

# Get laptop monitor mode and position
# These values don't change but this way the script is portable
LAPTOP_MONITOR_NAME="eDP-1"
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
