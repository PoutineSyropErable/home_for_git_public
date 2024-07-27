#!/bin/bash

# Function to get property from mpv using socat and jq
get_property() {
  local property="$1"
  local result
  result=$(echo '{ "command": ["get_property", "'"$property"'"] }' | socat - /tmp/mpvsocket 2>/dev/null | jq -r '.data')
  echo "${result:-Off/No Video}"
}

# Retrieve current time, total duration, volume, and media title from mpv
current_time=$(get_property "time-pos")
total_time=$(get_property "duration")
volume=$(get_property "volume")

# Check if any property is missing (indicating no video is playing)
if [ "$current_time" = "Off/No Video" ] || [ "$total_time" = "Off/No Video" ] || [ "$volume" = "Off/No Video" ]; then
  echo "lf and er on video to play"
  exit 1
fi

# Convert the times to integers (rounding to the nearest whole number)
current_time_int=$(printf "%.0f" "$current_time")
total_time_int=$(printf "%.0f" "$total_time")

# Format the times into HH:MM:SS
current_time_formatted=$(printf '%02d:%02d:%02d' $(($current_time_int/3600)) $(($current_time_int%3600/60)) $(($current_time_int%60)))
total_time_formatted=$(printf '%02d:%02d:%02d' $(($total_time_int/3600)) $(($total_time_int%3600/60)) $(($total_time_int%60)))

# Format the volume into an integer percentage
volume_int=$(printf "%.0f" "$volume")

# Print the formatted information including the media title
echo "$current_time_formatted/$total_time_formatted   $volume_int%"
