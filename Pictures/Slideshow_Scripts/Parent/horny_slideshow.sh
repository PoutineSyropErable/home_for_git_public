#!/bin/bash




pgrep -f "slideshow.sh" | grep -v "$(pgrep -f "$0")" | xargs kill


resized_dir="${1-resized}"


#sleep 4  # Adjust delay as needed
~/Pictures/Slideshow_Scripts/Master/slideshow.sh "Hot Shrek Pictures" $resized_dir "no_print" 
