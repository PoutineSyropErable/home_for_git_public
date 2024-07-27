#!/bin/bash
notify-send "Killed slideshow" -t 3000


pkill -f "mpv"
pkill -f "horny"
pgrep -f "slideshow.sh" | grep -v "$(pgrep -f "$0")" | xargs kill
pkill -f setup.sh
