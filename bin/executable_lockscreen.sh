#!/usr/bin/env bash
# Lockscreen to use with Sway, imagemagick, jq and Swaylock
# Screenshot using my screenshot.sh script, scales down the image then back up
# Pixels have been lost which gives a blur effect
#
# The script does nothing if invoked by swayidle and a specified hardware monitor is connected: I don't need lockscreen at home.
#
# zoug
#

# Don't apply lockscreen if invoked by swayidle and I'm at home
# Enter a string identifier for your monitor
HOME_MONITOR_IDENTIFIER="HNMY105546"
if swaymsg -t get_outputs | grep ${HOME_MONITOR_IDENTIFIER} && [[ $(ps -o comm= $PPID) == "swayidle" ]]; then
    notify-send -u low "You're at home!" "Use keybinding to lock manually."
    exit 0
fi

# Temporary files to screenshot and resized images
TEMP_BASE=$(mktemp -t lockscreen_img_XXXXXXXX.png)
TEMP_SMALL=$(mktemp -t lockscreen_img_XXXXXXXX.png)
TEMP_FINAL=$(mktemp -t lockscreen_img_XXXXXXXX.png)

# Take screenshot
SCREENSHOT_FILENAME="${TEMP_BASE}" SCREENSHOT_MODE="no-clip" screenshot.sh

# Shrink it down
magick convert -resize 10% "${TEMP_BASE}" "${TEMP_SMALL}"
# Then back up
magick convert -resize 1000% "${TEMP_SMALL}" "${TEMP_FINAL}"

# Apply lockscreen
swaylock -f -i "${TEMP_FINAL}"

# Cleanup
rm "${TEMP_SMALL}" "${TEMP_BASE}" "${TEMP_FINAL}"
