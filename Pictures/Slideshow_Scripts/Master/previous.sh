#!/bin/bash
#notify-send "previous" -t 3000

# Sending custom signal 2 to process named slideshow.sh
pkill -SIGRTMIN+2 slideshow.sh
