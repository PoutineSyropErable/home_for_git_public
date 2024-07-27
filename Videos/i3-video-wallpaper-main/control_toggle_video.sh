#!/bin/bash

# Function to send play/pause command to mpv via IPC socket
toggle_play_pause() {
  echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket > /dev/null
}

# Call the function to toggle play/pause
toggle_play_pause
