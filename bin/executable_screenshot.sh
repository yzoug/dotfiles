#!/usr/bin/env bash
# Simple script to save screenshots in clipboard + in dedicated folder
# zoug
#

# input: SCREENSHOT_MODE variable
# full: for screenshot of fullscreen
# any other value: default (ask region from slurp)

FILENAME_SCREENSHOT=~/shots/$(date +%F_%T).png
if [[ ${SCREENSHOT_MODE} == "full" ]]; then
    grim -g - - | tee >(wl-copy) > ${FILENAME_SCREENSHOT} && notify-send -i ${FILENAME_SCREENSHOT} "Screenshot of full desktop taken" -t 1000
else
    slurp | grim -g - - | tee >(wl-copy) > ${FILENAME_SCREENSHOT} && notify-send -i ${FILENAME_SCREENSHOT} "Screenshot of region taken" -t 1000
fi
