#!/usr/bin/env bash
# Simple script to save screenshots in clipboard and a file
# For use with Sway, slurp, grim, wl-copy and jq
# zoug
#

# input: SCREENSHOT_MODE variable
# "full": for fullscreen screenshot of focused monitor and copy in clipboard
# "no-clip": for fullscreen screenshot without copying to clipboard
# any other value: ask region from slurp and copy in clipboard

[[ ${DEBUG} -eq 1 ]] && set -x

# Where the screenshot is saved
# Either supply this env variable to the script, or it goes to my default folder
SCREENSHOT_FILENAME="${SCREENSHOT_FILENAME:=$HOME/shots/$(date +%F-%T).png}"

# Get focused monitor name, mode and position
FOCUSED_MONITOR_NAME=$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name")
FOCUSED_MONITOR_MODE=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"${FOCUSED_MONITOR_NAME}\").current_mode | \"\(.width)x\(.height)\"")
FOCUSED_MONITOR_POSITION=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"${FOCUSED_MONITOR_NAME}\").rect | \"\(.x),\(.y)\"")

if [[ ${SCREENSHOT_MODE} == "full" ]]; then
    echo -n "${FOCUSED_MONITOR_POSITION} ${FOCUSED_MONITOR_MODE}" | grim -g - - | tee >(wl-copy) > "${SCREENSHOT_FILENAME}" && notify-send -i "${SCREENSHOT_FILENAME}" "Screenshot of full desktop taken" -t 3000
elif [[ ${SCREENSHOT_MODE} == "no-clip" ]]; then
    echo -n "${FOCUSED_MONITOR_POSITION} ${FOCUSED_MONITOR_MODE}" | grim -g - - > "${SCREENSHOT_FILENAME}"
else
    slurp | grim -g - - | tee >(wl-copy) > "${SCREENSHOT_FILENAME}" && notify-send -i "${SCREENSHOT_FILENAME}" "Screenshot of region taken" -t 3000
fi
