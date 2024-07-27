#!/bin/bash
#notify-send "next" -t 3000

# Sending custom signal 1 to process named slideshow.sh
pkill -SIGRTMIN+1 slideshow.sh
