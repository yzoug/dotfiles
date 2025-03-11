#!/usr/bin/env bash
# Simple script to save screenshots in clipboard + in dedicated folder
# zoug
#

# input: SCREENSHOT_MODE variable
# "full": for fullscreen screenshot of focused monitor
# any other value: default (ask region from slurp)

[[ ${DEBUG} -eq 1 ]] && set -x

FILENAME_SCREENSHOT=~/shots/$(date +%F-%T).png
if [[ ${SCREENSHOT_MODE} == "full" ]]; then
    # Get focused monitor mode and position
    # These values don't change but this way the script is portable
    FOCUSED_MONITOR_NAME=$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name")
    MODE_LAPTOP_MONITOR=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"${FOCUSED_MONITOR_NAME}\").current_mode | \"\(.width)x\(.height)\"")
    POSITION_LAPTOP_MONITOR=$(swaymsg -t get_outputs | jq -r ".[] | select(.name==\"${FOCUSED_MONITOR_NAME}\").rect | \"\(.x),\(.y)\"")

    echo -n "${POSITION_LAPTOP_MONITOR} ${MODE_LAPTOP_MONITOR}" | grim -g - - | tee >(wl-copy) > ${FILENAME_SCREENSHOT} && notify-send -i ${FILENAME_SCREENSHOT} "Screenshot of full desktop taken" -t 1000
else
    slurp | grim -g - - | tee >(wl-copy) > ${FILENAME_SCREENSHOT} && notify-send -i ${FILENAME_SCREENSHOT} "Screenshot of region taken" -t 1000
fi
