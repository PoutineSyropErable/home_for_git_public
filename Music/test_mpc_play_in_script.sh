#!/bin/bash

# Check if the file name is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide a file name."
  exit 1
fi

# Function to get absolute path from relative path
get_absolute_path() {
  local file="$1"
  if [[ "$file" != /* ]]; then
    # If file path is relative, convert to absolute path
    file="$(readlink -f "$file")"
  fi
  echo "$file"
}

# Get the absolute path of the file
file=$(get_absolute_path "$1")

# Get the music directory from mpd.conf
music_dir=$(awk -F '"' '/music_directory/ {print $2}' ~/.mpdrc)

if [ -z "$music_dir" ]; then
  echo "Could not determine the music directory from mpd.conf."
  exit 1
fi

# Ensure the file is within the music directory
if [[ "$file" != "$music_dir"* ]]; then
  echo "File is not within the music directory."
  exit 1
fi

# Compute the relative path
relative_path="${file#$music_dir/}"

echo "Music directory: $music_dir"
echo "File: $file"
echo "Relative path: $relative_path"

# Update MPD database
echo "Updating MPD database..."
mpc update --wait

# Clear current playlist, add new file, and play it
echo "Clearing current playlist..."
mpc clear

echo "Adding file to playlist..."
mpc add "$relative_path"

echo "Starting playback..."
mpc play


