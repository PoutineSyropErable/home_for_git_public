#!/bin/bash
echo "for correct usage do 'toohorny &'"
pgrep -f "slideshow.sh\!^horny_slideshow.sh" | grep -v "$(pgrep -f "$0")" | xargs kill


nohup "$HOME/Videos/i3-video-wallpaper-main/play_video" "\"$HOME/Videos/My Videos/Silence Wench I do not wish to be horny anymore I just want to be Happy.mp4\"" &


# Ah, didn't think i'd get you, right?
