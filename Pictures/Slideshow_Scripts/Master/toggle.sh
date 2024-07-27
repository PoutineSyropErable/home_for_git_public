#!/bin/bash
#notify-send "Toggle" -t 3000

# Sending custom signal 1 to process named slideshow.sh
pkill -SIGRTMIN+3 slideshow.sh
