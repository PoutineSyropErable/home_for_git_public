#!/bin/bash

# Function to get property from mpv using socat and jq
get_property() {
  local property="$1"
  local result
  result=$(echo '{ "command": ["get_property", "'"$property"'"] }' | socat - /tmp/mpvsocket 2>/dev/null | jq -r '.data')
  echo "${result:-Off/No Title}"
}

# Function to truncate the title if it exceeds a maximum length
truncate_title() {
  local title="$1"
  local max_length="$2"
  
  if [ ${#title} -gt $max_length ]; then
    echo "${title:0:$max_length}..."
  else
    echo "$title"
  fi
}

# Retrieve media title from mpv
media_title=$(get_property "media-title")

# Check if media title is empty or not returned
if [ "$media_title" = "Off/No Title" ]; then
  echo "No video"
  exit 1
fi

# Define maximum length for title display
max_title_length=45  # Adjust this value to your desired maximum length

# Truncate title if it exceeds maximum length
truncated_title=$(truncate_title "$media_title" "$max_title_length")

# Print the formatted information including the truncated media title
echo "$truncated_title"
