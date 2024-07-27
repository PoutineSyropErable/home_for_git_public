#!/bin/bash

pkill -f play_video
pkill -f mpv
#feh  --bg-center --bg-fill --no-fehbg "$HOME/Pictures/Desktop Background Slideshow/Cool Pictures/resized_1200/anime cyberpunk girl.png"

echo "Activating the Desktop Slideshow, For correct usage do 'script &'"



pgrep -f "slideshow.sh" | grep -v "$(pgrep -f "$0")" | xargs kill


resized_dir="${1-resized_1200}"

#sleep 1  # Adjust delay as needed

#~/Pictures/Slideshow_Scripts/Master/slideshow.sh "Cool Pictures" $resized_dir "no_print" "$HOME/Pictures/Desktop Background Slideshow/Cool Pictures/resized_1200/anime cyberpunk girl.png"&

~/Pictures/Slideshow_Scripts/Master/slideshow.sh "Cool Pictures" $resized_dir "no_print" "$HOME/Pictures/Desktop Background Slideshow/Cool Pictures/resized_1200/8714ab1fb626c435433e749ca0cc83cd.png"




#pkill -f "^horny"
#pkill -f "^toohorny"


