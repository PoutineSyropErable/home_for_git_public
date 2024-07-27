#!/bin/bash

if [ $# -lt 1 ]; then
  echo "ERROR: Missing arguments"
  exit 1
fi

command="$1"
shift

case "$command" in
  "toggle")
    $HOME/Videos/i3-video-wallpaper-main/control_toggle_video.sh
    ;;
  "seek")
    if [ -z "$1" ]; then
      echo "ERROR: Missing seek time"
      exit 1
    fi
    $HOME/Videos/i3-video-wallpaper-main/control_seek_video.sh "$1"
    ;;
  "volume")
    if [ -z "$1" ]; then
      echo "ERROR: Missing volume adjustment"
      exit 1
    fi
    $HOME/Videos/i3-video-wallpaper-main/control_volume_video.sh "$1"
    ;;
  "stop")
    $HOME/Videos/i3-video-wallpaper-main/control_stop_video.sh
    ;;
  *)
    echo "ERROR: Unknown command $command"
    exit 1
    ;;
esac
